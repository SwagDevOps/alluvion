# frozen_string_literal: true

# Copyright (C) 2017-2019 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../cli'

# rubocop:disable Style/Documentation

class Alluvion::Cli
  # rubocop:enable Style/Documentation
  autoload(:Thor, 'thor')

  # Base command
  #
  # @abstract
  class Command < Thor
  end
end
