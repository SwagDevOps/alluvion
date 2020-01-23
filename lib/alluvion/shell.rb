# frozen_string_literal: true

# Copyright (C) 2017-2019 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../alluvion'

# Describe a shell command runner.
class Alluvion::Shell
  attr_reader :env

  # @param [Hash|nil] env
  def initialize(env = {})
    @env = env
  end

  # @return [Boolean]
  def call(*args)
    [self.env].concat(args).yield_self do |params|
      system(*params) || -> { raise args.inspect }.call
    end
  end

  protected

  # @type [Hash]
  attr_writer :env
end
