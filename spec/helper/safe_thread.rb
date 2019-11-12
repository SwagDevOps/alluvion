# frozen_string_literal: true

# Thread providing exceptions handling
#
# @see https://stackoverflow.com/questions/9095316/handling-exceptions-raised-in-a-ruby-thread
class SafeThread < Thread
  def initialize(*args, &block)
    # rubocop:disable Lint/RescueException
    super(*args) do
      block.call
    rescue Exception => e
      @postponed_exception = e
    end
    # rubocop:enable Lint/RescueException
  end

  def join
    raise_postponed_exception.yield_self { super }
  end

  protected

  attr_reader :postponed_exception

  def postponed_exception?
    !!postponed_exception
  end

  def raise_postponed_exception
    Thread.main.raise(postponed_exception) if postponed_exception?
  end
end
