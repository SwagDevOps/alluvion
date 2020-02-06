# frozen_string_literal: true

# Copyright (C) 2019-2020 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../alluvion'
require 'pathname'

# Provides command behavior surrounding command execution.
class Alluvion::ConfigFile < Pathname
  class << self
    autoload(:Etc, 'etc')
    # Get path to config file.
    #
    # @return [Pathname]
    def file
      require 'dry/inflector'

      Dry::Inflector.new.underscore(self.name.split('::').first).tap do |name|
        return Pathname.new(Etc.sysconfdir).join("#{name}.yml")
      end
    end
  end

  def initialize(path = self.class.file)
    super(path)
  end

  # Get parsed config.
  #
  # @return [Alluvion::Config]
  # @raise [Errno::ENOENT]
  def parse
    Alluvion::Config.read(self.realpath)
  end
end
