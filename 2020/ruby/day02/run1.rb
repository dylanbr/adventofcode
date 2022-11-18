load './data.rb'

#@test = true
if not @test.nil?
  @data = <<-END
1-3 a: abcde
1-3 b: cdefg
2-9 c: ccccccccc
  END
end

@data = @data.split(/\n+/).map do |line|
  fields = line.match(/(?<min>\d+)-(?<max>\d+) (?<char>.): (?<password>.*)/)
  fields.names.zip(fields.captures).to_h
end

valid = 0
@data.each do |line|
  count = line["password"].count(line["char"])
  if count >= line['min'].to_i and count <= line['max'].to_i
    valid += 1
  end
end

print "Valid password #{valid}\n"
