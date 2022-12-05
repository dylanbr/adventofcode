@test = <<-END
Alice would gain 54 happiness units by sitting next to Bob.
Alice would lose 79 happiness units by sitting next to Carol.
Alice would lose 2 happiness units by sitting next to David.
Bob would gain 83 happiness units by sitting next to Alice.
Bob would lose 7 happiness units by sitting next to Carol.
Bob would lose 63 happiness units by sitting next to David.
Carol would lose 62 happiness units by sitting next to Alice.
Carol would gain 60 happiness units by sitting next to Bob.
Carol would gain 55 happiness units by sitting next to David.
David would gain 46 happiness units by sitting next to Alice.
David would lose 7 happiness units by sitting next to Bob.
David would gain 41 happiness units by sitting next to Carol.
END

@data = @test
load './data.rb'
@rules = @data.split(/\n/).map do |line|
  line
    .match(/(?<target>\w+) would (?<direction>gain|lose) (?<points>\d+) happiness units by sitting next to (?<source>\w+)./)
    .named_captures
end
  .group_by do |rule|
    rule['target']
  end
  .map do |target, rules|
    [
      target,
      rules.group_by do |rule|
        rule['source']
      end.map do |source, rule|
        [source, rule.first['points'].to_i * (rule.first['direction'] == 'gain' ? 1 : -1)]
      end.to_h
    ]
  end.to_h

@people = @rules.keys
@seatings = @people.permutation(@people.size).to_a
@happiness = @seatings.map do |seating|
  seating.each_with_index.map do |person, index|
    left = seating[index - 1]
    right = seating[index + 1 < seating.size ? index + 1 : 0]
    @rules[person][left] + @rules[person][right]
  end.reduce(&:+)
end.max

print @happiness
