require_relative '../lib/InputHandling.rb'
require 'test/unit'

include InputHandling

#This class contains various tests for input handling.
class InputTest < Test::Unit::TestCase
  def test_loading_input
    input = Input.new
    loader = InputLoader.new
    loader.loadInput(input,File.new("testInput.txt"))
    assert_equal(["a","b","c"], input.alphabet)
    assert_equal(["abba","bbb","aaba"], input.searchPatterns)
    assert_equal(true, input.file.is_a?(File))
  end
end
