require_relative '../lib/Node.rb'
require_relative '../lib/Alphabet.rb'
require 'test/unit'

include Automatons
include AlphabetManagement

#This class contains various tests for Nodes and related classes
class NodeTest < Test::Unit::TestCase
  def test_label
    label = Label.new(5)
    assert_equal(5, label.id)
  end
  
  def test_descriptor
    desc = NodeDescriptor.new
    desc.add(Label.new(0))
    desc.add(Label.new(3))
    desc.add(Label.new(1))
    assert_equal("[0,1,3]", desc.to_s)
  end
  
  def test_descriptor_comparison
    desc1 = NodeDescriptor.new
    desc2 = NodeDescriptor.new
    desc1.add(Label.new(2))
    desc1.add(Label.new(5))
    desc2.add(Label.new(5))
    desc2.add(Label.new(2))
    assert_equal(true, desc1 == desc2)
    assert_equal(true, desc1.eql?(desc2))
  end
  
  def test_transition
    alphabetItem = AlphabetItem.new("a")
    descriptor = NodeDescriptor.new
    descriptor.add(Label.new(0))
    node = Node.new(descriptor)
    transition = Transition.new(alphabetItem, node)
    assert_equal(alphabetItem, transition.alphabetItem)
    assert_equal(node, transition.targetNode)
  end
  
  def test_node
    descriptor = NodeDescriptor.new
    descriptor.add(Label.new(0))
    node = Node.new(descriptor)
    assert_equal(descriptor, node.descriptor)
    assert_equal(nil, node.finalPattern)
    node.finalPattern = "aaba"
    assert_equal("aaba", node.finalPattern)
    assert_equal({}, node.transitions)
  end
  
  def test_node_transitions
    #initialize
    alphabetItemA = AlphabetItem.new("a")
    alphabetItemB = AlphabetItem.new("b")
    descriptor0 = NodeDescriptor.new
    descriptor0.add(Label.new(0))
    descriptor1 = NodeDescriptor.new
    descriptor1.add(Label.new(1))
    node0 = Node.new(descriptor0)
    node1 = Node.new(descriptor1)
    #addTransitions
    node0.addTransition(Transition.new(alphabetItemA, node0))
    node0.addTransition(Transition.new(alphabetItemB, node0))
    node0.addTransition(Transition.new(alphabetItemB, node1))
    #test getting transitions
    assert_equal(1, node0.getTransitionsFor(alphabetItemA).count)
    assert_equal(2, node0.getTransitionsFor(alphabetItemB).count)
    assert_equal(node0, node0.getTransitionsFor(alphabetItemA)[0].targetNode)
    assert_equal(node0, node0.getTransitionsFor(alphabetItemB)[0].targetNode)
    assert_equal(node1, node0.getTransitionsFor(alphabetItemB)[1].targetNode)
  end
end
