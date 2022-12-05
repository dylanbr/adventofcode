load "./data.rb"
#load "./test.rb"

# Literal 2021
#@data = "D2FE28"

# 2 sub packets with length
#@data = "38006F45291200"

# 3 sub packets by count
#@data = "EE00D40C823060"

# Has sum of 16 for version numbers
#@data = "8A004A801A8002F478"

# 1 + 3 == 2 * 2
#@data = "9C0141080250320F1802104A08"

@binary = <<-EOF
0 = 0000
1 = 0001
2 = 0010
3 = 0011
4 = 0100
5 = 0101
6 = 0110
7 = 0111
8 = 1000
9 = 1001
A = 1010
B = 1011
C = 1100
D = 1101
E = 1110
F = 1111
EOF
@binary = @binary.split(/\n/).map do |item|
  item.split(" = ")
end.to_h

@packet = @data.chars.map do |hex|
  @binary[hex]
end.join("").chars.map(&:to_i)

@debug = false
#@debug = true
def debug(str)
  if @debug
    print "#{str}\n"
  end
end


@versions = 0
def process(packet,limit=nil)
  values = []
  count = 0
  loop do
    debug "packet = #{packet}"
    return [packet, values] if not limit.nil? and count == limit
    return values if packet.empty?
    version = packet.shift(3).join("").to_i(2)
    @versions += version
    type = packet.shift(3).join("").to_i(2)
    debug "version = #{version}, type = #{type}"
    case type
    when 4
      parts = []
      loop do
        parts.push packet.shift(5)
        break if parts.last[0] == 0
      end
      value = parts.map do |part|
        part[1..4]
      end.join.to_i(2)
      values.push value
      debug "Literal: parts = #{parts}, value = #{value}"
    else
      ltype = packet.shift
      case ltype
      when 0
        size = packet.shift(15).join.to_i(2)
        debug "  ltype 0, size = #{size}"
        value = process(packet.shift(size))
      when 1
        size = packet.shift(11).join.to_i(2)
        (packet, value) = process(packet,size)
        debug "  ltype 1, size = #{size}, value = #{value}"
      end
      values.push value
    end
    count += 1
  end
end

process(@packet)
print "Version sum = #{@versions}\n"
