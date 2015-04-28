module Memo


  def memoize(method)
    old_method = instance_method(method)
    memo = {}

    define_method(method) do |*args|
      memo[args] ||= old_method.bind(self).call(*args)  
    end
  end


end


if $0 == __FILE__ 
  class Sample
    extend Memo

    def some_expensive_method
      sleep 1
      puts "Method called"
      23
    end

    memoize :some_expensive_method
  end

  sample = Sample.new
  10.times do 
    puts sample.some_expensive_method
  end
end

