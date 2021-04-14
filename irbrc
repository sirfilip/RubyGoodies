require 'irb/completion'

IRB.conf[:AUTO_INDENT] = true
IRB.conf[:SAVE_HISTORY] = 1000
IRB.conf[:PROMPT_MODE] = :SIMPLE

module IRB::ExtendCommandBundle
  def tmpfile
    '_edit_irb_tmp_file.rb'
  end

  def edit
    system("vim #{tmpfile}")
    eval File.read(tmpfile)
  ensure
    File.delete(tmpfile) if File.exists?(tmpfile)
  end

  def ri(method)
    puts `ri #{method}`
  end

  def vim(filename)
    system("vim #{filename}")
  end

  # benchmark 
  def time
    start = Time.now
    value = yield
    puts "Time: #{Time.now - start} seconds"
    value
  end
end

# at_exit do
#   File.delete(tmpfile) if File.exists?(tmpfile)
# end
