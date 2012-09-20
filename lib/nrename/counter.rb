module Nrename
  class Counter
    def initialize
      @counter = 0
    end

    def next
      @counter = @counter.next
    end
  end
end
