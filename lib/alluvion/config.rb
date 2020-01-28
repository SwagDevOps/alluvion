# frozen_string_literal: true

# Copyright (C) 2017-2019 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../alluvion'

# Describe a config
#
# Config keys
class Alluvion::Config < Hash
  # Provide ``ENV ``variables access in config template.
  #
  # To aceess an env variable, use ``@``.
  #
  # Examples: ``USER``, ``TIMEOUT`` and ``HOME``:
  #
  # ```yaml
  # ---
  # url: 'ssh://<%= @USER %>@example.org:22'
  # timeout: <%= @TIMEOUT || 1.5 %>
  # paths:
  #   local:
  #     done: "<%= @HOME %>/Downloads/complete"
  #     todo: "<%= @HOME %>/Downloads"
  # ```
  #
  # @return [Hash{Symbol => Object}]
  #
  # @see .template
  # @see #[]
  attr_reader :env

  # @param [Hash] config
  # @param [Hash|nil] env
  def initialize(config, env: nil)
    config.each { |k, v| self[k] = v }

    @env = (env || self.class.__send__(:env)).freeze
  end

  def [](key)
    (self.key?(key) ? super : dot_access(key)).yield_self do |value|
      self.class.template(value, env: self.env)
    end
  end

  class << self
    autoload(:YAML, 'yaml')

    # @param [String] filepath
    #
    # @return [Hash{String => Object}|Alluvion::Config]
    def read(filepath)
      # @formatter:off
      Pathname.new(filepath)
              .yield_self { |file| YAML.safe_load(file.read) }
              .yield_self { |config| self.new(config) }
      # @formatter:on
    end

    # @param [Object] value
    #
    # @return [Object]
    def template(value, env: self.env)
      return value unless value.is_a?(String)

      Alluvion::Template.new(value.to_s).call(env).yield_self do |v|
        YAML.safe_load(v)
      rescue Psych::Exception
        v
      end
    end

    protected

    # @return [Hash]
    def env
      ENV.to_h.to_a.map do |k, v|
        # @formatter:off
        [
          k.to_sym,
          lambda do
            YAML.safe_load(v)
          rescue Psych::Exception
            v
          end.call
        ]
        # @formatter:on
      end.to_h
    end
  end

  protected

  # rubocop:disable Metrics/MethodLength

  # @param [String] path
  #
  # @return [Object]
  def dot_access(path)
    result = nil

    self.to_h.dup.tap do |current|
      path.split('.').tap do |parts|
        parts.each do |k|
          return nil unless current.key?(k)

          result = current[k]
          current = current.dup[k]
        end
      end
    end

    result
  end

  # rubocop:enable Metrics/MethodLength
end
