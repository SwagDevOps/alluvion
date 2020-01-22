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
  end

  # Process a down synchro
  #
  # @raise [RuntimeError] when connection is not available
  def down
    sequences.fetch(__method__).tap do |sequence|
      with_connection do
      end
    end
  end

  # Process a up synchro
  #
  # @raise [RuntimeError] when connection is not available
  def up
    sequences.fetch(__method__).tap do |sequence|
      with_connection do
      end
    end
  end

  protected

  # @return [Alluvion::Config]
  attr_reader :config

  def with_connection(&block)
    Alluvion::URI.new(config['url']).tap do |uri|
      unless uri.host.port_open?(uri.port, timeout: config['timeout'] || 1)
        raise "Can not connect to #{uri.to_s.inspect}"
      end

      return block.call
    end
  end

  # Get commands sequences.
  #
  # @return [Hash{Symbol => Synchro::Sequence}]
  def sequences
    Alluvion::Synchro::Sequence::Factory.new(config).yield_self do |f|
      [:up, :down].sort.map { |direction| [direction, f.get(direction)] }.to_h
    end
  end
end
