# frozen_string_literal: true

# Copyright (C) 2019-2020 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../alluvion'

# Describe a synchro
class Alluvion::Synchro
  autoload(:Pathname, 'pathname')

  # @formatter:off
  {
    Sequence: 'sequence',
  }.each { |s, fp| autoload(s, "#{__dir__}/synchro/#{fp}") }
  # @formatter:on

  # @param [Hash|Alluvion::Config] config
  def initialize(config)
    @config = Alluvion::Config.new(config)
    @sequences = [:done, :todo].sort.map do |direction|
      [direction, Alluvion::Synchro::Sequence.build(direction, self.config)]
    end.to_h
  end

  # Process a up synchro
  #
  # @raise [RuntimeError] when connection is not available
  def call(direction)
    with_lock(direction) do
      sequences.fetch(direction.to_sym).tap do |sequence|
        with_connection { sequence.call }
      end
    end
  end

  protected

  # @return [Alluvion::Config]
  attr_reader :config

  # Get commands sequences.
  #
  # @return [Hash{Symbol => Synchro::Sequence}]
  attr_reader :sequences

  # Acquire lock with given filepath before executing given block.
  #
  # @param [Symbol] direction
  #
  # @raise [Alluvion::FileLock::Error]
  def with_lock(direction, &block)
    (config["locks.#{direction}"] || lock_files.fetch(direction)).yield_self do |filepath| # rubocop:disable Layout/LineLength
      Alluvion::FileLock.new(filepath).call { block.call }
    end
  end

  # Ensure connection is available before executing given block.
  def with_connection(&block)
    Alluvion::URI.new(config['url']).tap do |uri|
      unless uri.host.port_open?(uri.port, timeout: config['timeout'] || 1)
        raise "can not connect to #{uri.to_s.inspect}"
      end

      return block.call
    end
  end

  # Get paths for default lock files.
  #
  # @return [Hash{Symbol => Pathname}]
  def lock_files
    require 'dry/inflector'
    require 'tmpdir' unless Dir.respond_to?(:tmpdir)

    Pathname.new(Dir.tmpdir).yield_self do |tmpdir|
      Dry::Inflector.new.underscore(self.class.name.split('::').first).yield_self do |name| # rubocop:disable Layout/LineLength
        # @formatter:off
        return [:done, :todo].map do |direction|
          [direction, tmpdir.join([name, ENV['UID'] || Process.uid, direction, 'lock'].join('.'))] # rubocop:disable Layout/LineLength
        end.to_h
        # @formatter:on
      end
    end
  end
end
