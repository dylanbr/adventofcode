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
  fields = line.match(/(?<pos1>\d+)-(?<pos2>\d+) (?<char>.): (?<password>.*)/)
  fields.names.zip(fields.captures).to_h
end

valid = 0
@data.each do |line|
  found = 0
  found += 1 if line["password"][line["pos1"].to_i-1] == line["char"]
  found += 1 if line["password"][line["pos2"].to_i-1] == line["char"]
  if found == 1
    valid += 1
  end
end

print "Valid password #{valid}\n"
