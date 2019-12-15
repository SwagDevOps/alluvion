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

  # @return [Commands]
  attr_reader :commands

  # @param [Hash|Alluvion::Config] config
  def initialize(config)
    @config = Alluvion::Config.new(config)
  end

  # Process a down synchro
  #
  # @raise [RuntimeError] when connection is not available
  def down
    with_connection {}
  end

  # Process a up synchro
  #
  # @raise [RuntimeError] when connection is not available
  def up
    with_connection {}
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
end
