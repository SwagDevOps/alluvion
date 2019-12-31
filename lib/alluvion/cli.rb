# frozen_string_literal: true

# Copyright (C) 2017-2019 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../alluvion'

# Entrypoint for CLI.
class Alluvion::Cli
  class << self
    protected

    # @type [Array<Class>]
    attr_accessor :commands
  end

  @commands = []

  # @formatter:off
  {
    Command: 'command',
    SynchroCommand: 'synchro_command'
  }.each do |s, fp|
    autoload(s, Pathname.new(__dir__).join("cli/#{fp}"))

    self.commands.push(self.const_get(s)) if s.to_s =~ /[A-Z].+Command/
  end
  # @formatter:on

  # Execute CLI.
  #
  # @param [Array<String>] given_args
  #
  # @return [void]
  def call(given_args = ARGV.dup)
    callable.start(given_args)
  end

  # Get available commands (as classes)
  #
  # @return [Array<Class|Thor>]
  def commands
    self.class.__send__(:commands).dup
  end

  protected

  # rubocop:disable Metrics/AbcSize,Metrics/MethodLength

  # Build callable commands.
  #
  # @return [Class|Thor]
  #
  # @see Thor.register()
  # @see https://github.com/erikhuda/thor/blob/99330185faa6ca95e57b19a402dfe52b1eba8901/lib/thor.rb#L30
  def callable
    require 'dry/inflector'

    Class.new(Command).tap do |klass|
      self.commands.each do |command|
        Dry::Inflector.new.underscore(command.name.split('::').last).split('_')[0..-2].fetch(0).tap do |ns| # rubocop:disable Layout/LineLength
          command.commands.to_h.each do |name, c|
            klass.__send__(:desc, "#{ns}:#{name}", c.description)
            # @formatter:off
            c.options.each do |option_name, v|
              {
                aliases: v.aliases,
                desc: v.description,
                required: v.required,
                type: v.type,
                repeatable: v.repeatable,
              }.tap { |option| klass.__send__(:option, option_name, option) }
            end
            # @formatter:on

            klass.define_method("#{ns}:#{name}") { |*args| invoke(c, args) }
          end
        end
      end
    end
  end
  # rubocop:enable Metrics/AbcSize,Metrics/MethodLength
end
