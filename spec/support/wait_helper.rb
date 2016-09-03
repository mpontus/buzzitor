module WaitHelper
  extend self

  # Calls provided +block+ every 100ms
  #   and stops when it returns false
  #
  # @param timeout [Fixnum]
  # @yield block for execution
  #
  # @example
  #   current_time = Time.now
  #   WaitHelper.wait_until(3) do
  #     Time.now - current_time > 2
  #   end
  #
  #   # 2 seconds later ...
  #   # => true
  #
  #   current_time = Time.now
  #   WaitHelper.wait_until(3) do
  #     Time.now - current_time > 10
  #   end
  #
  #   # 3 seconds later (after timeout)
  #   # => false
  #
  def wait_until(timeout, &block)
    begin
      Timeout.timeout(timeout) do
        sleep(0.1) until value = block.call
        value
      end
    rescue TimeoutError
      false
    end
  end
end
