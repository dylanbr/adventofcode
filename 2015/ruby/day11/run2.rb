load 'lib/password.rb';
@data = eval(File.open('data.rb').read)
print Password.new(@data).next.next.to_s
