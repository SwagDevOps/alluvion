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
  autoload(:Timeout, 'timeout')
  autoload(:FileUtils, 'fileutils')
  autoload(:Pathname, 'pathname')
  # @formatter:off
  {
    Error: 'error',
  }.each { |s, fp| autoload(s, "#{__dir__}/file_lock/#{fp}") }
  # @formatter:on

  # @param [String] filepath
  def initialize(filepath, timeout: 0.001)
    super(filepath)
    @fs = FileUtils
    @timeout = timeout
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

      fs.rm_f(self.to_path)
    end
  end

  protected

  # @return [Float]
  attr_reader :timeout

  # File utility methods for copying, moving, removing, etc.
  #
  # @return [FileUtils]
  # @see https://ruby-doc.org/stdlib-2.5.1/libdoc/fileutils/rdoc/FileUtils.html
  attr_reader :fs

  # Get lock file.
  #
  # @return [File]
  def file
    @lock ||= File.open(prepare.to_s, File::RDWR | File::CREAT, 0o644)
  end

  # @raise [LockError]
  def acquire_lock!
    # noinspection RubyBlockToMethodReference,RubyResolve
    Timeout.timeout(timeout) { lock_write }
  rescue StandardError => e
    abort("Can not acquire lock (#{basename('.*')})", cause: e)
  end

  # @return [File]
  def lock_write
    file.tap do |f|
      f.write("#{$PID}\n")
      f.flush
      f.flock(File::LOCK_EX)
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
