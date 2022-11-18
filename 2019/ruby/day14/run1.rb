require './data.rb'

@data['FUEL']['required'] = 1

loop do
  @data.each do |target, item|
    if @data[target]['produces'].empty?
      required = (item['required'].to_f / item['amount']).ceil
      #print "[#{target}] required = #{item['required']} amount = #{item['amount']} = #{amount}\n"
      @data[target]['recipe'].each do |name, amount|
        @data[name]['required'] += amount * required
        #print "\t[#{name}] requirement = #{requirement['amount']} total = #{requirement['amount'] * amount}\n"
        @data[name]['produces'].delete(target)
      end
      @data.delete(target)
      break
    end
  end
  break if @data.keys.size == 1
end

print "\nOre required = #{@data['ORE']['required']}\n\n"
