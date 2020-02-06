# frozen_string_literal: true

# Copyright (C) 2019-2020 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../alluvion'

# Describe a template
class Alluvion::Template
  autoload(:BabyErubis, 'baby_erubis')

  # @param [String] value
  def initialize(value)
    @origin = value.to_s
  end

  # Rendder template with given context.
  #
  # @param [Hash] context
  # @return [String]
  def render(context = {})
    renderer.render(context)
  end

  alias call render

  protected

  # @return [String]
  attr_reader :origin

  # @return [BabyErubis::Template]
  def renderer
    BabyErubis::Text.new.from_str(origin)
  end
end
