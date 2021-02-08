load "./data.rb"
#load "./test.rb"

@data = @data.split(/\n+/).map do |line|
  op = line.split(/ = /)
  if op[0] == "mask"
    masks = op[1].split("").map do |bit|
      next [1,0] if bit == "X"
      next [0,0] if bit == "0"
      next [1,1] if bit == "1"
    end.reduce([[],[]]) do |bits, bit|
      bits[0].push(bit[0])
      bits[1].push(bit[1])
      bits
    end.map do |bit|
      bit.join("").to_i(2)
    end
    ["mask",masks]
  else
    ["mem",op[0].match(/\d+/)[0].to_i,op[1].to_i]
  end
end

mem = {}
masks = []
@data.each do |op|
  case op[0]
  when "mask"
    masks = op[1]
  when "mem"
    mem[op[1]] = op[2] & masks[0] | masks[1]
  end
end

print "Answer = #{mem.values.reduce(&:+)}\n"
#print "#{mem}\n"
#print "#{@data}\n"
