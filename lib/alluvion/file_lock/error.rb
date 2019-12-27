# frozen_string_literal: true

# Copyright (C) 2017-2019 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../file_lock'

# Describe an error.
class Alluvion::FileLock::Error < ::RuntimeError
  # @param [String] message
  # @param [Exception] cause
  def initialize(message, cause: nil)
    super(message)

    @cause = cause if cause.class.ancestors.include?(::Exception)
  end

  # @return [Boolean]
  def cause?
    @cause.nil? != true
  end

  # @return [Exception|nil]
  def cause
    @cause ? @cause.dup : nil
  end
end
