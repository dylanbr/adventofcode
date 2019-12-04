require "./data.rb"

def check(password)
  chars = password.to_s.split('')
  return false if chars.size != 6

  last = "0"
  adjacent = false
  decrease = false
  for char in chars
    adjacent = true if char == last
    if char < last
      decrease = true
      break
    end
    last = char
  end

  return false if decrease
  return false if not adjacent

  true
end

total = 0
valid = 0
for i in  @data[0]..@data[1]
  total += 1
  valid += 1 if check(i)
end

print "Total passwords checked = #{total}\n"
print "Valid passwords = #{valid}\n"

