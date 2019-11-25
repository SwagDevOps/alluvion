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
  autoload(:FileUtils, 'fileutils')
  autoload(:Pathname, 'pathname')
  autoload(:Timeout, 'timeout')

  # Error acquiring lock.
  class LockError < RuntimeError
  end

  # Execute given block inside a lock, release lock after execution.
  #
  # @return [Object]
  #
  # @raise [LockError]
  def lock!(&block)
    acquire_lock!
    block.call.tap { self.unlock }
  end

  alias call lock!

  # @return [self]
  def unlock
    self.tap do
      file.flock(File::LOCK_UN) if self.exist?

      FileUtils.rm_f(self.to_path)
    end
  end

  protected

  # Get lock file.
  #
  # @return [File]
  def file
    @lock ||= File.open(prepare.to_s, File::RDWR | File::CREAT, 0o644)
  end

  # @raise [LockError]
  def acquire_lock!
    ::Timeout.timeout(0.001) { file.flock(File::LOCK_EX) }
  rescue ::Timeout::Error
    abort("Already locked (#{basename('.*')})")
  end

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
