require "password"

RSpec.describe Password do
  describe '#to_s' do
    it 'returns the password' do
      expect(Password.new('abc').to_s).to eq('abc')
      expect(Password.new('12345678').to_s).to eq('12345678')
    end
  end
  describe '#validate' do
    it 'rejects passwords not exactly 8 characters' do
      expect(Password.new('abcdef').valid?).to eq(false)
      expect(Password.new('1234').valid?).to eq(false)
    end
    it 'rejects passwords not made up of lowercase letters' do
      expect(Password.new('12345678').valid?).to eq(false)
      expect(Password.new('ABCDEFGH').valid?).to eq(false)
      expect(Password.new('ABCDFFAA').valid?).to eq(false)
    end
    it 'rejects passwords without an increasing straight of at least three' do
      expect(Password.new('aabbabab').valid?).to eq(false)
      expect(Password.new('aabbefgh').valid?).to eq(true)
    end
    it 'cannot contain i, o or l' do
      expect(Password.new('ssttwxyz').valid?).to eq(true)
      expect(Password.new('opqrstuv').valid?).to eq(false)
      expect(Password.new('hijklmno').valid?).to eq(false)
    end
    it 'must contain two unique pairs' do
      expect(Password.new('abchhzzz').valid?).to eq(true)
      expect(Password.new('abcdefgh').valid?).to eq(false)
    end
    it 'validates a password' do
      expect(Password.new('abcdffaa').valid?).to eq(true)
      expect(Password.new('ghjaabcc').valid?).to eq(true)
      expect(Password.new('abcppzza').valid?).to eq(true)
      expect(Password.new('hijklmmn').valid?).to eq(false)
      expect(Password.new('abbceffg').valid?).to eq(false)
      expect(Password.new('abbcegjk').valid?).to eq(false)
    end
  end
  describe '#increment' do
    it 'increments a password' do
      expect(Password.new('abcaabbc').increment.to_s).to eq('abcaabbd')
      expect(Password.new('abcaabbz').increment.to_s).to eq('abcaabca')
    end
  end
  describe '#next' do
    it 'find the next valid password' do
      expect(Password.new('abcdefgh').next.to_s).to eq('abcdffaa')
      expect(Password.new('ghijklmn').next.to_s).to eq('ghjaabcc')
    end
  end
end
