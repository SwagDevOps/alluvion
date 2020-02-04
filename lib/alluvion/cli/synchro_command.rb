# frozen_string_literal: true

# Copyright (C) 2017-2019 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative 'command'

# Synchro command
#
# Expose up and down synchros.
class Alluvion::Cli::SynchroCommand < Alluvion::Cli::Command
  class << self
    protected

    # @return [Array]
    def config_option_args
      # @formatter:off
      [:config, {
        aliases: '-c',
        desc: 'Load given config file',
        type: :string,
        default: Alluvion::ConfigFile.new.to_s
      }]
      # @formatter:on
    end
  end

  desc 'todo', 'Execute synchro (up)'
  config_option_args.tap { |args| option(args[0], **args[1]) }

  # @see Alluvion.Synchro#up
  def todo
    configure(options).yield_self { synchro.call(__method__) }
  end

  desc 'done', 'Execute synchro (down)'
  config_option_args.tap { |args| option(args[0], **args[1]) }

  # @see Alluvion::Synchro#down
  def done
    configure(options).yield_self { synchro.call(__method__) }
  end

  protected

  # @return [Alluvion::Config]
  attr_accessor :config

  # @param {Hash} options
  def configure(options)
    self.tap { self.config = Alluvion::ConfigFile.new(*options[:config]).parse }
  end

  # Get a new instance of synchro.
  #
  # @return [Alluvion::Synchro]
  def synchro
    Alluvion::Synchro.new(config)
  end
end
