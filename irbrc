def edit
  tmpfile = '_edit_irb_tmp_file.rb'
  system("vim #{tmpfile}")
  eval File.read(tmpfile)
ensure
  File.delete(tmpfile)
end
