require_relative '../lib/Automatons.rb'
require_relative '../lib/Alphabet.rb'
require_relative '../lib/Printer.rb'

require 'test/unit'


include Automatons
#This class contains various tests for Printer class
class PrinterTest < Test::Unit::TestCase
  def test_fixed_string
    assert_equal(" abcd   ", fixed_string("abcd",8))
    assert_equal("   abcd ", fixed_string("abcd",8, true))
    assert_equal("      a ", fixed_string("a",8,true))
    assert_equal(" a      ", fixed_string("a",8))
  end
  

end
