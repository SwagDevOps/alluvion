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
      [:down].each { |k| self[k] = self.load_config(k) }
    end
  end

  def path
    Pathname.new(__dir__).join('commands')
  end

  protected

  def load_config(name)
    OpenStruct.new(variables).instance_eval { binding }.yield_self do |struct|
      YAML.safe_load(path.dup.join("#{name}.yml").read).map do |arg|
        ERB.new(arg.to_s).result(struct)
      end
    end
  end

  def variables
    {
      url: Alluvion::URI.new(self.config['url']),
      config: self.config.dup
    }
  end
end
