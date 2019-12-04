# frozen_string_literal: true

# Copyright (C) 2017-2019 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../synchro'

# Describe commands
class Alluvion::Synchro::Commands < Hash
  autoload(:ERB, 'erb')
  autoload(:YAML, 'yaml')
  autoload(:OpenStruct, 'ostruct')

  # @return [Alluvion::Config]
  attr_reader :config

  # @param [Hash{String => Object}|Alluvion::Config] config
  def initialize(config)
    @config = Alluvion::Config.new(config)
    self.tap do
      { down: :done } .each do |k, path|
        self[k] = self.load_config(k).yield_self do |v|
          path = self.config["paths.local.#{path}"]
          path ? Alluvion::Synchro::Command.new(v, path: path) : nil
        end
      end
    end
  end

  # Get path for commands template.
  #
  # @return [Pathname]
  def path
    Pathname.new(__dir__).join('commands')
  end

  protected

  # Load command template by given name.
  #
  # @return [Array<String>]
  def load_config(name)
    OpenStruct.new(variables).instance_eval { binding }.yield_self do |struct|
      YAML.safe_load(path.dup.join("#{name}.yml").read).map do |arg|
        ERB.new(arg.to_s).result(struct)
      end
    end
  end

  # Get variables used in commands templating.
  #
  # @return [Hash{Symbol => Object}]
  def variables
    {
      url: Alluvion::URI.new(self.config['url']),
      config: self.config.dup
    }
  end
end
