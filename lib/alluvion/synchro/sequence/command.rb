# frozen_string_literal: true

# Copyright (C) 2019-2020 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../sequence'

# Describe a command
class Alluvion::Synchro::Sequence::Command < Array
  autoload(:Pathname, 'pathname')

  # @return [Pathname]
  attr_reader :path

  # @param [Array<String>] args
  # @param [String] path
  def initialize(args, path: Dir.pwd)
    @path = Pathname.new(path)
    super(args)
  end

  def freeze
    self.map(&:freeze)
    path.freeze
    super
  end

  # Execute command.
  #
  # @raise
  # @return [Boolean]
  def call
    Dir.chdir(path) { sh(*self) }
  end

  protected

  def sh(*args)
    Alluvion::Shell.new.call(*args)
  end
end
