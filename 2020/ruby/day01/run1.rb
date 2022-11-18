load './data.rb'

@data = @data.split(/\n+/)
# Demo data
#@data = %w(1721 979 366 299 675 1456)
@data = @data.map(&:to_i)

hash = {}
@data.each do |num|
  hash[2020-num] = true
end

@data.each do |num|
  if hash.has_key? num
    print "#{num} + #{2020-num} = 2020\n"
    print "#{num} * #{2020-num} = #{ num * (2020-num) }\n"
    exit
  end
end
