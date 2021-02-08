require './data.rb'

def ore_required(fuel)
  data = Marshal.load(Marshal.dump(@data))
  data['FUEL']['required'] = fuel
  loop do
    data.each do |target, item|
      if data[target]['produces'].empty?
        required = (item['required'].to_f / item['amount']).ceil
        #print "[#{target}] required = #{item['required']} amount = #{item['amount']} = #{amount}\n"
        data[target]['recipe'].each do |name, amount|
          data[name]['required'] += amount * required
          #print "\t[#{name}] requirement = #{requirement['amount']} total = #{requirement['amount'] * amount}\n"
          data[name]['produces'].delete(target)
        end
        data.delete(target)
        break
      end
    end
    break if data.keys.size == 1
  end
  data['ORE']['required']
end

fuel = 1
loop do
  ore = ore_required(fuel)
  print "Fuel = #{fuel}, ore = #{ore}\r"
  if ore < 1000000000000
    fuel *= 2
  else
    break
  end
end
wstart = fuel / 2
wend = fuel
last = 0
print "\nWindow = #{wstart} to #{wend}\n"

loop do
  mid = (wend - wstart) / 2 + wstart
  ore = ore_required(mid)
  print "Fuel = #{mid}, ore = #{ore}\n"
  if last == mid
    break
  elsif ore > 1000000000000
    wend = mid
  elsif ore < 1000000000000
    wstart = mid
  else
    break
  end
  last = mid
end
print "\n\n1000000000000 ore = #{last} fuel\n\n"
