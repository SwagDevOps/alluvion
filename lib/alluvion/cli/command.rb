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
    class << self
      # @see https://github.com/erikhuda/thor/blob/99330185faa6ca95e57b19a402dfe52b1eba8901/lib/thor.rb#L127
      def method_options(**options)
        super(options)
      end

      # @see https://www.ruby-lang.org/en/news/2019/12/12/separation-of-positional-and-keyword-arguments-in-ruby-3-0/
      alias options method_options
    end
  end
end
