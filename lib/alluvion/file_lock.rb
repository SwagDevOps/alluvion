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
  # @formatter:off
  {
    Error: 'error',
  }.each { |s, fp| autoload(s, "#{__dir__}/file_lock/#{fp}") }
  # @formatter:on

  # @param [String] filepath
  def initialize(filepath)
    super(filepath)
    @fs = FileUtils
  end

  def locked?
    # returns false if already locked, 0 if not
    # noinspection RubySimplifyBooleanInspection
    file.flock(File::LOCK_EX | File::LOCK_NB) == false
  end

  # Execute given block inside a lock, release lock after execution.
  #
  # @return [Object]
  #
  # @raise [LockError]
  def lock!(&block)
    acquire_lock!
    block.call.tap { self.unlock } if block
  end

  alias call lock!

  # @return [self]
  def unlock
    self.tap do
      file.tap { |f| f.flock(File::LOCK_UN) }

      fs.rm_f(self.to_path) if self.exist?
    end
  end

  protected

  # File utility methods for copying, moving, removing, etc.
  #
  # @return [FileUtils]
  # @see https://ruby-doc.org/stdlib-2.5.1/libdoc/fileutils/rdoc/FileUtils.html
  attr_reader :fs

  # Get lock file.
  #
  # @return [File]
  def file
    @file ||= File.open(prepare.to_s, File::RDWR | File::CREAT, 0o644)
  end

  # @raise [LockError]
  def acquire_lock!
    abort("Can not acquire lock (#{basename('.*')})") if locked?

    lock_write
  end

  # @return [File]
  def lock_write
    # return  file.flock(File::LOCK_EX).tap { |f| pp(f) }
    file.tap do |f|
      f.flock(File::LOCK_EX)
      f.write("#{$PID}\n")
      f.flush
    end
  end

  # @return [self]
  def prepare
    self.tap { fs.mkdir_p(self.dirname.to_s) }
  end

  # @param [string] msg
  #
  # @raise [LockError]
  def abort(msg, cause: nil)
    Error.new(msg, cause: cause).tap { |e| raise e }
  end
end
