def every_n_seconds(n)
  thread = Thread.new do 
    while true do 
      before = Time.now
      yield
      interval = n-(Time.now - before)
      sleep(interval) if interval > 0
    end
  end
end


if $0 == __FILE__ 
  every_n_seconds(5) do 
    puts "Nananananananananaa"
  end.join
end
