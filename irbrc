require 'irb/completion'

IRB.conf[:AUTO_INDENT] = true
IRB.conf[:SAVE_HISTORY] = 1000
IRB.conf[:PROMPT_MODE] = :SIMPLE

def tmpfile
  '_edit_irb_tmp_file.rb'
end


def edit
  system("vim #{tmpfile}")
  eval File.read(tmpfile)
ensure
  # File.delete(tmpfile)
end

def ri(method)
  puts `ri #{method}`
end

def vim(filename)
  system("vim #{filename}")
end

# shell
def ls(path = nil)
  if path
    Dir["#{path}/*"]
  else
    Dir["*"]
  end
end

def cd(path)
  Dir.chdir(path)
end

def pwd
  Dir.pwd
end

def cat(filename)
  puts File.read(filename)
end

# benchmark 
def time
  start = Time.now
  yield
ensure
  puts "Time: #{Time.now - start} seconds"
end

at_exit do
  File.delete(tmpfile) if File.exists?(tmpfile)
end

