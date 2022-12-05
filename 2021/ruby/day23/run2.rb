load "./data.rb"
#load "./test.rb"
#
@more = <<-EOF
  #D#C#B#A#
  #D#B#A#C#
EOF
@data = @data.split(/\n/).insert(3,*@more.split(/\n/))

@buckets = @data.select { |line| line.match(/[A-D]/) }.map do |line|
  line.gsub("#","").strip.split("")
end.transpose.map(&:reverse)

@energy = {
  'A' => 1,
  'B' => 10,
  'C' => 100,
  'D' => 1000
}

@home = {
  'A' => 0,
  'B' => 1,
  'C' => 2,
  'D' => 3
}

@who = @home.invert

@bucket_to_passage = [
  [ [0,1,nil], [1,nil], [nil,2], [nil,2,nil,3], [nil,2,nil,3,nil,4], [nil,2,nil,3,nil,4,nil,5], [nil,2,nil,3,nil,4,nil,5,6] ], # Bucket A
  [ [0,1,nil,2,nil], [1,nil,2,nil], [2,nil], [nil,3], [nil,3,nil,4], [nil,3,nil,4,nil,5], [nil,3,nil,4,nil,5,6] ], # Bucket B
  [ [0,1,nil,2,nil,3,nil], [1,nil,2,nil,3,nil], [2,nil,3,nil], [3,nil], [nil,4], [nil,4,nil,5], [nil,4,nil,5,6] ], # Bucket C
  [ [0,1,nil,2,nil,3,nil,4,nil], [1,nil,2,nil,3,nil,4,nil], [2,nil,3,nil,4,nil], [3,nil,4,nil], [4,nil], [nil,5], [nil,5,6] ], # Bucket D
]

def allow_bucket_to_passage(bucket, passage, passages)
  @bucket_to_passage[bucket][passage].reject do |p|
    p.nil? or passages[p].nil?
  end.empty?
end

def skip_bucket(bucket, buckets)
  amphipod = @who[bucket]
  buckets[bucket].reject { |a| a == amphipod }.empty?
end

def score_bucket_to_passage(bucket, passage)
  @bucket_to_passage[bucket][passage].size
end

def allow_amphipod_to_home(amphipod, buckets)
  buckets[@home[amphipod]].reject {|a| a == amphipod}.empty?
end

def allow_passage_to_bucket(passage, amphipod, passages)
  bucket = @home[amphipod]
  @bucket_to_passage[bucket][passage].reject do |p|
    p.nil? or p == passage or passages[p].nil?
  end.empty?
end



@states = Hash.new(nil)
def turn(buckets, passages=Array.new(7), total=0)
  print "Turn with state #{[buckets, passages]}\n"
  # Stop if cycling
  #@states[[buckets, passages]] += 1

  # Is the board complete
  done = true
  ['A','B','C','D'].each_with_index do |amphipod,i|
    if buckets[i].select { |a| a == amphipod }.size != 4
      done = false
    end
  end

  if done
    print "FOUND #{buckets}\n"
    return 0
  end

  scores = Array.new

  # Possible move: passage to bucket
  passages.each_with_index do |amphipod, passage|
    next if amphipod.nil?
    # Only allow final moves
    if allow_amphipod_to_home(amphipod, buckets) and allow_passage_to_bucket(passage, amphipod, passages)
      new_buckets = buckets.dup.map { |b| b.dup }
      new_passages = passages.dup

      new_buckets[@home[amphipod]].push amphipod
      new_passages[passage] = nil
      if new_buckets[@home[amphipod]].size == 4
        extra = 0
      elsif new_buckets[@home[amphipod]].size == 3
        extra = 1
      elsif new_buckets[@home[amphipod]].size == 2
        extra = 2
      else
        extra = 3
      end
      score = (score_bucket_to_passage(@home[amphipod], passage) + extra) * @energy[amphipod]
      if @states[[new_buckets, new_passages]].nil? or @states[[new_buckets, new_passages]] > total+score
        @states[[new_buckets, new_passages]] = total+score
        result = turn(new_buckets, new_passages, total+score)
        if not result.nil?
          scores.push(result+score)
        end
      end
    end
  end

  # Possible moves: move from bucket to passage
  buckets.each_with_index do |bucket, i|
    next if skip_bucket(i, buckets) #bucket.empty?
    (0..6).each do |passage|
      if allow_bucket_to_passage(i, passage, passages)
        new_buckets = buckets.dup.map { |b| b.dup }
        new_passages = passages.dup
        amphipod = new_buckets[i].pop
        new_passages[passage] = amphipod
        if new_buckets[i].size == 0
          extra = 3
        elsif new_buckets[i].size == 1
          extra = 2
        elsif new_buckets[i].size == 2
          extra = 1
        else
          extra = 0
        end
        score = (score_bucket_to_passage(i, passage) + extra) * @energy[amphipod]
        if @states[[new_buckets, new_passages]].nil? or @states[[new_buckets, new_passages]] > total+score
          @states[[new_buckets, new_passages]] = total+score
          result = turn(new_buckets, new_passages, total+score)
          if not result.nil?
            scores.push(result + score)
          end
        end
      end
    end
  end

  if not scores.empty?
    scores.min
  else
    nil
  end
end

print turn(@buckets.dup)
