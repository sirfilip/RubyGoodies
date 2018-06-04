require 'irb/completion'

IRB.conf[:SAVE_HISTORY] = 1000
IRB.conf[:AUTO_INDENT] = true
IRB.conf[:PROMPT_MODE] = :SIMPLE

def time
  start = Time.now
  yield
ensure
  puts "Time: #{Time.now - start} seconds"
end

def edit
  tmpfile = '_edit_irb_tmp_file.rb'
  system("vim #{tmpfile}")
  eval File.read(tmpfile)
ensure
  File.delete(tmpfile)
end
