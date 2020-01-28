# frozen_string_literal: true

# Copyright (C) 2017-20120 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../alluvion'

# Describe a template
class Alluvion::Template
  autoload(:BabyErubis, 'baby_erubis')

  def initialize(value)
    @origin = value.to_s
  end

  def render(context = {})
    renderer.render(context)
  end

  protected

  # @return [String]
  attr_reader :origin

  def renderer
    BabyErubis::Text.new.from_str(origin)
  end
end
