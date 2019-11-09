# frozen_string_literal: true

# Copyright (C) 2017-2019 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../alluvion'

# Describe a file
class Alluvion::File < Pathname
  autoload(:MimeMagic, 'mimemagic')

  # Get mime (type) by content.
  #
  # @return [MimeMagic]
  def mime
    return MimeMagic.new('empty') if empty?

    File.open(self.to_path).yield_self { |fd| MimeMagic.by_magic(fd) }
  end

  # Get mime type by file content.
  #
  # @return [String]
  def mime_type
    mime.type
  end
end
