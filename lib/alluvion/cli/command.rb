# frozen_string_literal: true

# Copyright (C) 2019-2020 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../cli'

# rubocop:disable Style/Documentation

class Alluvion::Cli
  # rubocop:enable Style/Documentation
  autoload(:Thor, 'thor')

  # Base command
  #
  # @abstract
  class Command < Thor
    class << self
      # rubocop:disable Layout/LineLength

      # Parse the command and options from the given args, and invoke the command.
      #
      # @param [Array<String>] given_args
      # @param [Hash{Symbol => Object}] config
      #
      # @raise [SystemExit]
      #
      # @see https://github.com/erikhuda/thor/blob/master/lib/thor/base.rb#L475
      def start(given_args = ARGV, config = {})
        config[:shell] ||= Thor::Base.shell.new
        handle_interrupt(config) { dispatch(nil, given_args.dup, nil, config) }
      rescue Thor::UndefinedCommandError, Thor::InvocationError => e
        config[:shell].error(e.message)
        exit(Errno::EINVAL::Errno)
      rescue Thor::Error => e
        config[:debug] || ENV['THOR_DEBUG'] == '1' ? (raise e) : config[:shell].error(e.message)
        exit(false)
      rescue Errno::EPIPE
        # This happens if a thor command is piped to something like `head`,
        # which closes the pipe when it's done reading. This will also
        # mean that if the pipe is closed, further unnecessary
        # computation will not occur.
        exit(true)
      end

      # rubocop:enable Layout/LineLength

      def handle_interrupt(config = {}, &block)
        block.call if block # rubocop:disable Style/SafeNavigation
      rescue Interrupt
        Process.kill(:HUP, -pgid)
        exit(0)
      rescue SignalException => e
        config[:shell].error("Interrupted by signal (#{e.signo})")
        Process.kill(:HUP, -pgid)
        exit(Errno::ESRCH::Errno)
      end

      def pid
        (require 'English').yield_self { $PID }
      end

      def pgid
        Process.getpgid(pid)
      end

      def method_option(name, **options)
        super(name, options)
      end

      # @see https://www.ruby-lang.org/en/news/2019/12/12/separation-of-positional-and-keyword-arguments-in-ruby-3-0/
      alias option method_option
    end
  end
end
