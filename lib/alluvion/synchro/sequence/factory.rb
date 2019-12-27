# frozen_string_literal: true

# Copyright (C) 2017-2019 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../sequence'

# Describe commands
#
# Commands are indexed by direction up/down as sequences:
# ``Array<Alluvion::Synchro::Command>``.
#
class Alluvion::Synchro::Sequence::Factory
  autoload(:ERB, 'erb')
  autoload(:YAML, 'yaml')
  autoload(:OpenStruct, 'ostruct')

  # @param [Hash{String => Object}|Alluvion::Config] config
  def initialize(config)
    @config = Alluvion::Config.new(config)
    @sequences = {}

    # Prepare sequences ---------------------------------------------
    { down: :done, up: :todo }.each do |k, path|
      @sequences[k] = make_commands(k, path)&.yield_self do |commands|
        Alluvion::Synchro::Sequence.new(commands)
      end
    end
  end

  # @return [Alluvion::Config]
  def config
    @config.dup
  end

  # @param [String|Symbol] name
  # @return [Synchro::Sequence]
  #
  # @raise [Alluvin::]Synchro::Sequence::NotFoundError]
  def get(name)
    sequences.fetch(name.to_sym)
  rescue KeyError => e
    "sequence not found: #{e.key.inspect}".yield_self do |message|
      # rubocop:disable Layout/LineLength
      Alluvion::Synchro::Sequence::NotFoundError.new(e.key, message).tap do |error|
        # noinspection RubyBlockToMethodReference
        raise error
      end
      # rubocop:enable Layout/LineLength
    end
  end

  # @param [String|Symbol] name
  #
  # @return [Boolean]
  def has?(name)
    sequences.key?(name.to_sym)
  end

  protected

  # @param [String] key
  def fetch(key)
    return config[key] unless config[key].nil?

    # @formatter:off
    {
      'todo.extensions' => ['torrents'],
      'todo.mime_types' => ['application/x-bittorrent']
    }[key]
    # @formatter:on
  end

  def sequences
    @sequences.dup.delete_if { |_k, v| v.nil? }
  end

  # Get todos (files) based on some config keys.
  #
  # @return [Array<String>]
  def todos
    fetch('todo.extensions').map do |ext|
      pattern = Pathname.new(config['paths.local.todo']).join("*.#{ext}")
      Dir.glob(pattern).map { |fp| Alluvion::File.new(fp) }.keep_if do |f|
        fetch('todo.mime_types').include?(f.mime_type)
      end
    end.flatten.sort_by(&:ctime).map { |fp| fp.basename.to_s }
  end

  # @return [Pathname]
  def config_path
    Pathname.new(__dir__).join('commands').freeze
  end

  # Load command template by given name.
  #
  # @return [Array<String>|Alluvion::Synchro::Command]
  def load_command(name, path, variables = {})
    YAML.safe_load(config_path.dup.join("#{name}.yml").read).map do |arg|
      ERB.new(arg.to_s).result(struct(variables))
    end.yield_self do |args|
      return Alluvion::Synchro::Sequence::Command.new(args, path: path)
    end
  end

  # @return [OpenStruct]
  def struct(variables = {})
    OpenStruct.new(self.variables.merge(variables)).instance_eval { binding }
  end

  # @param [Symbol] direction
  # @param [String|Symbol] path_id
  # @raise [ArgumentError]
  #
  # @return [Hash{Symbol => Array<Alluvion::Synchro::Command>}]
  def make_commands(direction, path_id)
    self.config["paths.local.#{path_id}"].tap do |path|
      return nil unless path

      return [load_command(direction, path)] if direction == :down

      if direction == :up
        return todos.map do |fname|
          # rubocop:disable Layout/LineLength
          { file: fname }.yield_self { |variables| load_command(direction, path, variables) }
          # rubocop:enable Layout/LineLength
        end
      end
    end

    raise ArgumentError, "Invalid direction: #{direction.inspect}"
  end

  # Get variables used in commands templating.
  #
  # @return [Hash{Symbol => Object}]
  def variables
    # @formatter:off
    {
      url: Alluvion::URI.new(self.config['url']),
      config: self.config.dup
    }
    # @formatter:on
  end
end
