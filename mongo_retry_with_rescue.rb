def rescue_connection_failure(max_retries=60)
  retries = 0
  begin
    yield
  rescue Mongo::ConnectionFailure => ex
    retries += 1
    raise ex if retries > max_retries
    sleep(0.5)
    retry
  end
end

# usage 
rescue_connection_failure do 
  # do something with db here...
end
