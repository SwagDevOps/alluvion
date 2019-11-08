# frozen_string_literal: true

# Copyright (C) 2017-2019 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../alluvion'

# Describe a config
class Alluvion::Config < Hash
  # @param [Hash] config
  def initialize(config)
    config.each { |k, v| self[k] = v }
  end

  def [](key)
    self.key?(key) ? super : dot_access(key)
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
