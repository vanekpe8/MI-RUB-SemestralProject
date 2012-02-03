require_relative '../lib/Alphabet.rb'
require 'test/unit'

include AlphabetManagement

#This class contains various tests for the Alphabet
class AlphabetTest < Test::Unit::TestCase
  def test_alphabet_item
    item = AlphabetItem.new("a")
    assert_equal("a", item.value)
    assert_equal("a", item.to_s)
  end
  
  def test_alphabet_creation
    alphabet_values = ["a", "b", "c"]
    alphabet = Alphabet.new(alphabet_values)
    assert_equal(3, alphabet.size)
    assert_equal(true, alphabet.contains?("a"))
    assert_equal(true, alphabet.contains?("b"))
    assert_equal(true, alphabet.contains?("c"))
    assert_equal("a", alphabet[0].value)
    assert_equal("b", alphabet[1].value)
    assert_equal("c", alphabet[2].value)
    assert_equal(true, alphabet.contains?(AlphabetItem.new("b")))
  end
  
  def test_alphabet_repetitions
    alphabet_values = ["a", "b", "a"]
    assert_raises(RuntimeError){
      alphabet = Alphabet.new(alphabet_values)
    }
    
  end
  
  def test_each
    alphabet = Alphabet.new(["a","b","c"])
    str = ""
    alphabet.each do |item|
     str = str + item.to_s
    end
    assert_equal("abc",str)
  end
end
