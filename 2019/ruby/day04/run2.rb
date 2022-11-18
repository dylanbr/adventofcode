require "./data.rb"

def check(password)
  chars = password.to_s.split('')
  return false if chars.size != 6

  last = "0"
  adjacents = []
  adjacent_count = 0
  decrease = false
  for char in chars
    if char == last
      adjacent_count += 1
    else
      adjacents.push adjacent_count + 1
      adjacent_count = 0
    end
    if char < last
      decrease = true
      break
    end
    last = char
  end
  adjacents.push adjacent_count + 1
  adjacent = adjacents.find_index(2)

  return false if decrease
  return false if adjacent.nil?

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

