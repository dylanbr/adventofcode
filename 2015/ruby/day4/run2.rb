require 'digest/md5'

@data = "yzbqklnj"
#@data = "abcdef"
#@data = "pqrstuv"

@found = false
@count = 0
while not @found
  hash = Digest::MD5.hexdigest(@data + @count.to_s)
  if hash[0..5] == "000000"
    @found = true
  else
    @count += 1
  end
end
print "Count = #{@count}\n"

