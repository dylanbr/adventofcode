class Password
  def initialize(password)
    @password = password.chars.map do |char|
      char_to_num(char)
    end.reverse
  end

  def char_to_num(char)
    char.ord - 'a'.ord
  end

  def num_to_char(num)
    (num + 'a'.ord).chr
  end

  def to_s(password=@password)
    password.reverse.map do |num|
      num_to_char(num)
    end.join
  end

  def valid?
    return false if @password.size != 8
    return false if not @password.all? do |char|
      char >= 0 && char <= 26
    end
    # 8='i', 11='l', 14='o'
    return false if not ([8, 11, 14] & @password).empty?
    return false if not @password.each_cons(3).any? do |triple|
      triple[0] == (triple[1] + 1) && triple[1] == (triple[2] + 1)
    end
    return false if @password.each_cons(2).select do |pair|
      pair[0] == pair[1]
    end.uniq.count < 2
    true
  end

  def increment
    carry = 1
    @password = @password.map do |num|
      next num if carry == 0
      num = num + carry
      if num >= 26
        num = 0
      else 
        carry = 0
      end
      num
    end
    self
  end

  def next
    loop do
      increment
      break if valid?
    end
    self
  end
end
