def with_lock(key)
	loop do
		lock = Redis.current.sadd(key)
		
		break if lock === 1 || lock === true
		sleep 0.1
	end

	yield
ensure
  Redis.current.srem(key)
end
