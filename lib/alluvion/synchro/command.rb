# frozen_string_literal: true

# Copyright (C) 2017-2019 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../synchro'

# Describe a command
class Alluvion::Synchro::Command < Array
  autoload(:Pathname, 'pathname')

  # @param [Hash{String => Object}|Alluvion::Config] config
  def initialize(args, path: Dir.pwd)
    @path = Pathname.new(path)
    super(args)
  end
end
