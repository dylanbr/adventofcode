@t = 6

case @t
when 1
  @data = <<-END
  939
  7,13,x,x,59,x,31,19
  END
when 2
  @data = <<-END
  939
  17,x,13,19
  END
when 3
  @data = <<-END
  939
  67,7,59,61
  END
when 4
  @data = <<-END
  939
  67,x,7,59,61
  END
when 5
  @data = <<-END
  939
  67,7,x,59,61
  END
when 6
  @data = <<-END
  939
  1789,37,47,1889
  END
end
