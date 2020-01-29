# frozen_string_literal: true

# Copyright (C) 2017-2019 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../alluvion'

# Describe a synchro
class Alluvion::Synchro
  # @formatter:off
  {
    Sequence: 'sequence',
  }.each { |s, fp| autoload(s, "#{__dir__}/synchro/#{fp}") }
  # @formatter:on

  # @param [Hash|Alluvion::Config] config
  def initialize(config)
    @config = Alluvion::Config.new(config)
    @sequences = [:up, :down].sort.map do |direction|
      [direction, Alluvion::Synchro::Sequence.build(direction, self.config)]
    end.to_h
  end

  # Process a up synchro
  #
  # @raise [RuntimeError] when connection is not available
  def call(direction)
    with_lock(config["locks.#{direction}"]) do
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
  # @param [String] filepath
  #
  # @raise [Alluvion::FileLock::Error]
  def with_lock(filepath, &block)
    Alluvion::FileLock.new(filepath).call { block.call }
  end

  # Ensure connection is available before executing given block.
  def with_connection(&block)
    Alluvion::URI.new(config['url']).tap do |uri|
      unless uri.host.port_open?(uri.port, timeout: config['timeout'] || 1)
        raise "Can not connect to #{uri.to_s.inspect}"
      end

      return block.call
    end
  end
end
