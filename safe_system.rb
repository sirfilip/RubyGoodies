def system!(command)
  fail "Command #{command} failed" unless system(command)
end
