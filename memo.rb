module Memo


  def memoize(method)
    old_method = instance_method(method)
    memo = {}

    define_method(method) do |*args|
      unless memo.has_key?(args) 
        memo[args] = old_method.bind(self).call(*args)
      end
      memo[args]
    end
  end


end


if $0 == __FILE__ 
  class Sample
    extend Memo

    def some_expensive_method(n)
      sleep 1
      puts "Method called"
      n
    end

    memoize :some_expensive_method
  end

  sample = Sample.new
  10.times do |i| 
    puts sample.some_expensive_method(i)
    puts sample.some_expensive_method(i)
    puts sample.some_expensive_method(i)
  end
end

