# frozen_string_literal: true

# Copyright (C) 2017-2019 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../synchro'

# Describe a sequence of commands
class Alluvion::Synchro::Sequence < Array
  # @formatter:off
  {
    Command: 'command',
    Factory: 'factory',
    NotFoundError: 'not_found_error',
  }.each { |s, fp| autoload(s, "#{__dir__}/sequence/#{fp}") }
  # @formatter:on

  # @param [Array<Alluvion::Synchro::Sequence::Command>|Array<String>] commands
  def initialize(commands = [])
    commands.map do |command|
      command.is_a?(Command) ? command.dup : Command.new(command)
    end.yield_self do |args|
      super(args)
    end
  end

  def call
    self.map(&:call)
  end

  class << self
    # Build a sequence by given name and config.
    #
    # @param [String|Symbol] name
    # @param [Hash{String => Object}|Alluvion::Config] config
    #
    # @return [Alluvion::Synchro::Sequence]
    # @raise [Alluvion::Synchro::Sequence::NotFoundError]
    def build(name, config)
      Factory.new(config).get(name)
    end
  end
end
