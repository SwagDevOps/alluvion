# frozen_string_literal: true

# Copyright (C) 2017-2019 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../file_lock'

# Describe an error.
class Alluvion::FileLock::Error < ::RuntimeError
  # @return [String]
  attr_reader :message

  # @param [String] message
  # @param [Exception] cause
  def initialize(message, cause: nil)
    @message = message.freeze
    @cause = cause if cause.class.ancestors.include?(Exception)
  end

  # @return [Boolean]
  def cause?
    @cause.nil? != true
  end

  def to_s
    message
  end

  # @return [Exception|nil]
  def cause
    @cause ? @cause.dup : nil
  end
end
