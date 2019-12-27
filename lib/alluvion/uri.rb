# frozen_string_literal: true

# Copyright (C) 2017-2019 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../alluvion'

# Describe an URI
class Alluvion::URI < String
  # @return [Alluvion::Host]
  def hostname
    Alluvion::Host.new(self.to_uri.hostname)
  end

  alias host hostname

  # @return [::URI::Generic]
  #
  # @raise [::URI::InvalidURIError]
  def to_uri
    self.class.__send__(:parse, self)
  end

  # @!method user
  # Get user
  # @return [String]

  # @!method scheme
  # Get scheme
  # @return [String]

  # @!method path
  # Get path
  # @return [String]

  # @!method query
  # Get query
  # @return [String]

  # @!method fragment
  # Get fragment
  # @return [String]

  # @!method port
  # Get port
  # @return [String|Fixnum]

  def respond_to_missing?(method_name, include_private = false)
    return true if self.to_uri.respond_to?(method_name, include_private)

    super
  end

  def method_missing(method_name, *arguments, &block)
    # rubocop:disable Metrics/LineLength
    return to_uri.public_send(method_name, *arguments) if respond_to_missing?(method_name)

    super
    # rubocop:enable Metrics/LineLength
  end

  class << self
    autoload(:URI, 'uri')

    # @param [String] uri
    #
    # @return [::URI::Generic]
    def parse(uri)
      ::URI.parse(uri).tap do |result|
        %w[user hostname port].sort.each do |method_name|
          if result.public_send(method_name).nil?
            raise ::URI::InvalidURIError, "can not determine `#{method_name}'"
          end
        end
      end
    end
  end
end
