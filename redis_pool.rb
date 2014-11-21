require 'thread'
require 'redis'

class RedisPool 


  def initialize(size)
    @size = size
    @jobs = Queue.new

    @pool = Array.new(@size) do 
      Thread.new do 
        redis = Redis.new

        catch(:exit) do 
          loop do 
            job = @jobs.pop
            job.call(redis)
          end
        end
      end
    end

  end

  def work(&block)
    @jobs << block
  end

  def shutdown
    @size.times do 
      work { throw :exit }
    end

    at_exit { @pool.map(&:join) }
  end

end




if $0 == __FILE__ 

  require 'benchmark'


  Benchmark.bm do |x|
  
    x.report(:no_thread_pool) do 
      conn = Redis.new
      10_000.times do |i|
        conn.set("key_#{i}", i)
      end
    end

    x.report(:thread_pool) do 
      pool = RedisPool.new(5)
      10_000.times do |i|
        pool.work do |redis|
          redis.set("pool_key_#{i}", i)
        end
      end
      pool.shutdown
    end

  end
end
