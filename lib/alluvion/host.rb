# frozen_string_literal: true

# Copyright (C) 2017-2019 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../alluvion'

# Describe an hostname
class Alluvion::Host < String
  autoload(:Timeout, 'timeout')
  autoload(:TCPSocket, 'socket')

  # @param [Fixnum] port
  # @param [Fixnum] timeout
  #
  # @return [Boolean]
  def port_open?(port, timeout: 3)
    # noinspection RubyYardReturnMatch
    lambda do
      TCPSocket.new(self, port).close
      true
    rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH, Errno::ENETUNREACH
      false
    end.tap { |conn| return with_timeout(conn, timeout: timeout) }
  rescue Timeout::Error
    false
  end

  protected

  # @param [Proc] callable
  # @param [Fixnum] timeout
  #
  # @return [Object]
  def with_timeout(callable, timeout: 3)
    Timeout.timeout(timeout) { callable.call }
  end
end
