require 'forwardable'

module Nrename
  class Counter
    extend Forwardable

    def_delegator :@counter, :next

    def initialize
      @counter = Enumerator.new do |yielder|
        idx = 1

        loop do
          yielder << idx
          idx += 1
        end
      end
    end
  end
end
