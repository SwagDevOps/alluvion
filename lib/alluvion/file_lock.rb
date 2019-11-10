# frozen_string_literal: true

# Copyright (C) 2017-2019 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../alluvion'

autoload(:Pathname, 'pathname')

# Provide file locking (based on `flock`).
class Alluvion::FileLock < Pathname
  autoload(:Digest, 'digest')
  autoload(:FileUtils, 'fileutils')
  autoload(:Pathname, 'pathname')

  # Error acquiring lock.
  class LockError < RuntimeError
  end

  # @return [Object]
  #
  # @raise [LockError]
  def lock!(&block)
    File.open(prepare.to_s, File::CREAT).yield_self do |lock|
      # returns false if already locked, 0 if not
      lock.flock(File::LOCK_EX | File::LOCK_NB)
    end.yield_self do |ret|
      # noinspection RubySimplifyBooleanInspection
      # @formatter:off
      {
        true => -> { abort("Already locked (#{basename('.*')})") },
        false => block
      }.fetch(false == ret).call
      # @formatter:on
    end
  end

  # @return [self]
  def unlock
    self.tap { FileUtils.rm_f(self) }
  end

  protected

  # @return [self]
  def prepare
    self.tap { FileUtils.mkdir_p(self.dirname.to_s) }
  end

  # @param [string] msg
  #
  # @raise [LockError]
  def abort(msg)
    raise LockError, msg
  end
end
