# frozen_string_literal: true

# Copyright (C) 2019-2020 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../sequence'

# No entry was found in the factory.
class Alluvion::Synchro::Sequence::NotFoundError < KeyError
  # @param [String|Symbol|Object] key
  def initialize(key, message = nil)
    @key = key
    @message = message
  end

  # @return [String|Symbol|Object]
  attr_reader :key

  def message
    @message || key
  end
end
