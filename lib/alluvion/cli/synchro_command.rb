# frozen_string_literal: true

# Copyright (C) 2017-2019 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative 'command'

# Up command
class Alluvion::Cli::SynchroCommand < Alluvion::Cli::Command
  desc 'up', 'Execute synchro up'
  option :delete,
         aliases: '-d',
         desc: 'Delete the file after parsing it',
         type: :boolean,
         default: false

  def up
    # @todo implement method
  end
end