load "./data.rb"
#load "./test.rb"

@data = @data.split(/\n\n/)

@calls = @data.shift.split(",")

@boards = @data.map do |board|
  board.split(/\n/).map do |row|
    row.strip.split(/\s+/)
  end
end

@called = []
@calls.each do |call|
  @called.push call

  @boards.each do |board|
    found = {}
    marked = []
    board.each_with_index do |cols,row|
      cols.each_with_index do |number,col|
        if @called.include? number
          marked.push number
          col_key = "col_#{col}"
          row_key = "row_#{row}"
          if found[col_key].nil?
            found[col_key] = []
          end
          if found[row_key].nil?
            found[row_key] = []
          end

          found[col_key].push number
          found[row_key].push number
        end
      end
    end
    winners = found.filter do |index, value|
      value.size >= 5
    end
    if winners.size > 0
      print "Winners = #{winners.first[1]}\n"
      #winner = winners.first[1]
      unmarked = []
      board.each_with_index do |cols,row|
        cols.each_with_index do |number,col|
          if not marked.include? number
            unmarked.push number.to_i
          end
        end
      end
      print "Answer = #{unmarked.sum * @called.last.to_i}\n"
      exit
    end
  end
end

#print "Called = #{@calls}\n"
#print "Boards = #{@boards}\n"
