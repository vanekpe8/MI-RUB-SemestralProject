require_relative '../lib/Automatons.rb'
require_relative '../lib/Alphabet.rb'
require_relative '../lib/Node.rb'
require 'test/unit'

include Automatons
include AlphabetManagement

#This class implements a simple test listener for the DeterministicAutomaton
class TestListener
  def report(pattern, index)
    @pattern = pattern
    @index = index
  end
  
  attr_reader :pattern, :index
end

#This class contains various tests for Automatons
class AutomatonsTest < Test::Unit::TestCase
  def test_automaton
    alphabet = Alphabet.new(["a","b"])
    a = Automaton.new(alphabet)
    assert_equal(0, a.size)
    
    nodes = []
    3.times do |index|
      descriptor = NodeDescriptor.new
      descriptor.add(Label.new(index))
      node = Node.new(descriptor)
      nodes[index] = node
      a.addNode(node)
    end
    assert_equal(3, a.size)
    descriptor = NodeDescriptor.new
    descriptor.add(Label.new(1))
    assert_equal(nodes[1], a.getNode(descriptor))
    assert_equal(nodes[0], a.getNodeAt(0))
    assert_equal(nodes[2], a.getNodeAt(2))
  end
  
  def getNodeDesc(node)
    node.descriptor.labels.to_a[0].id
  end
  
  def getTransitionTarget(node, alphabetItem, arrayIndex)
    node.getTransitionsFor(alphabetItem)[arrayIndex].targetNode
  end
  
  def test_non_deterministic_automaton
    alphabet = Alphabet.new(["a","b"])
    a = NonDeterministicAutomaton.new(alphabet)
    a.addPattern("aba")
    a.finalize
    aItem = AlphabetItem.new("a")
    bItem = AlphabetItem.new("b")
    assert_equal(4, a.size)
    node0 = a.getNodeAt(0)
    assert_equal(1, getNodeDesc(getTransitionTarget(node0, aItem, 0)))
    assert_equal(0, getNodeDesc(getTransitionTarget(node0, aItem, 1)))
    assert_equal(0, getNodeDesc(getTransitionTarget(node0, bItem, 0)))
    node1 = getTransitionTarget(node0, aItem, 0)
    assert_equal(2, getNodeDesc(getTransitionTarget(node1, bItem, 0)))
    node2 = getTransitionTarget(node1, bItem, 0)
    assert_equal(3, getNodeDesc(getTransitionTarget(node2, aItem, 0)))
    node3 = getTransitionTarget(node2, aItem, 0)
    
    assert_equal("aba", node3.finalPattern)
    assert_equal(nil, node0.finalPattern)
    assert_equal(nil, node1.finalPattern)
    assert_equal(nil, node2.finalPattern)
  end
  
  def test_deterministic_automaton
    alphabet = Alphabet.new(["a","b"])
    nda = NonDeterministicAutomaton.new(alphabet)
    nda.addPattern("bba")
    nda.finalize
    da = nda.makeDeterministic
    assert_equal(4,da.size)
    strings = ["[0]", "[0,1]", "[0,1,2]", "[0,3]"]
    4.times do |index|
      assert_equal(strings[index], da.getNodeAt(index).descriptor.to_s)
    end
  end
  
  def test_more_complex_deterministic_automaton
    alphabet = Alphabet.new(["a","b"])
    nda = NonDeterministicAutomaton.new(alphabet)
    nda.addPattern("abba")
    nda.addPattern("bbb")
    nda.finalize
    assert_equal(8,nda.size)
    da = nda.makeDeterministic
    assert_equal(8, da.size)
    strings = ["[0]","[0,1]","[0,5]","[0,2,5]","[0,5,6]","[0,3,5,6]","[0,5,6,7]","[0,1,4]"]
    8.times do |index|
      #p "#{da.getNodeAt(index).descriptor.to_s} (#{da.getNodeAt(index).finalPattern.to_s})"
      assert_equal(strings[index], da.getNodeAt(index).descriptor.to_s)
    end
  end
  
  def test_search
    text = "aababbaababbbabbabbbaa"
    alphabet = Alphabet.new(["a","b"])
    nda = NonDeterministicAutomaton.new(alphabet)
    nda.addPattern("abba")
    nda.addPattern("bbb")
    nda.finalize
    da = nda.makeDeterministic
    listener = TestListener.new
    da.beginSearch(listener)
    text.length.times do |index|
      da.changeState(alphabet.get(text[index]))
      assert_equal("abba", listener.pattern) if(index == 6)
      assert_equal(3, listener.index) if(index == 6)
      assert_equal("bbb", listener.pattern) if(index == 12)
      assert_equal(10, listener.index) if(index == 12)
      assert_equal("abba", listener.pattern) if(index == 16)
      assert_equal(13, listener.index) if(index == 16)
      assert_equal("bbb", listener.pattern) if(index == 19)
      assert_equal(17, listener.index) if(index == 19)
    end
    
  end
end
