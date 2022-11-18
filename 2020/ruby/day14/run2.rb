load "./data.rb"
load "./test.rb"
#load "./test2.rb"

@data = @data.split(/\n+/).map do |line|
  op = line.split(/ = /)
  if op[0] == "mask"
    masks = [[]]
    print "MASK GEN\n"
    count = 0
    op[1].split("").each do |bit|
      count += 1
      print "CHAR = #{count}, SIZE = #{masks.size}"
      if bit == "X"
        print ", SPLIT!"
        masks.concat(masks.dup.map(&:dup))
      end
      print "\n"
      half = masks.size / 2
      masks.each_index do |index|
        case bit
        when "0"
          masks[index].push([0,1])
        when "1"
          masks[index].push([1,1])
        when "X"
          if index < half
            masks[index].push([0,0])
          else
            masks[index].push([1,1])
          end
        end
      end
    end
    masks = masks.map do |mask|
      mask.reduce([[],[]]) do |bits, bit|
        bits[0].push(bit[0])
        bits[1].push(bit[1])
        bits
      end
    end.map do |pair|
      pair.map do |mask|
        mask.join("").to_i(2)
      end
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
    masks.each do |mask|
      address = (op[1] | mask[0]) & mask[1]
      mem[address] = op[2]
    end
  end
end

print "Answer = #{mem.values.reduce(&:+)}\n"
#print "#{mem}\n"
#print "#{@data}\n"
