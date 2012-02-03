module Automatons
  require 'set'
  
  #This class represents a node in the automaton
  class Node
    #Creates a new instance of Node with given NodeDescriptor
    def initialize(descriptor)
      @descriptor = descriptor
      @finalPattern = nil
      @transitions = Hash.new
    end
    
    #Adds a new transition
    def addTransition(transition)
      t_arr = @transitions[transition.alphabetItem]
      if(t_arr == nil)
        @transitions[transition.alphabetItem] = [transition]
      else
        t_arr[t_arr.count] = transition
      end
    end
    
    #Returns all transitions for given AlphabetItem
    def getTransitionsFor(alphabetItem)
      @transitions[alphabetItem]
    end
    
    #Returns true if this node is equal to other
    def ==(other)
      eql?(other)
    end
    
    #Returns true if this node is equal to other
    def eql?(other)
      if(!other.instance_of?(Node))
        false
      else
        @descriptor == other.descriptor &&
        @finalPattern == other.finalPattern &&
        @transitions == other.transitions
      end
    end
    
    #A Hash in which all transitions are stored
    attr_reader :transitions
    #The descriptor for this node. It is a unique identifier inside the automaton.
    attr_reader :descriptor
    #Gets or sets a final pattern for this node. If it is not nil, this node is final and 'finalPattern' has been found.
    attr_accessor :finalPattern
  end
  
  #This class represents a descriptor for Node class. It is a unique identifier
  #of the node inside the automaton.
  class NodeDescriptor
    #Creates a new instance of NodeDescriptor
    def initialize
      @labels = Set.new
    end
    
    #Adds a Label to the descriptor
    def add(item)
      @labels.add(item)
    end
    
    #Returns string representation of this descriptor
    def to_s
      @labels.to_a.sort.to_s.delete(" ")
    end
    
    #Returns true if this NodeDescriptor is equal to 'other'
    def eql?(other)
      if(!other.instance_of?(NodeDescriptor))
        false
      else
        @labels.eql?(other.labels)
      end
    end
    
    #Returns true if this NodeDescriptor is equal to 'other'
    def ==(other)
      eql?(other)
    end
    
    #Returns a hash value for this descriptor
    def hash
      @labels.hash
    end
    
    #A Set of Labels used in this descriptor
    attr_reader :labels
  end
  
  #This class is a Label for a Node. It is stored inside
  #the node's descriptor.
  class Label
    #Creates a new instance of Label
    def initialize(id)
      @id = id
    end
    
    #Returns true if this Label is equal to 'other'
    def eql?(other)
      if(!other.instance_of?(Label))
        false
      else
        @id == other.id
      end
    end
    
    #Returns true if this Label is equal to 'other'
    def ==(other)
      eql?(other)
    end
    
    #Compares this Label to the 'other' and returns -1,0 or 1
    #if this Label is lesser, equal of greater than the 'other'
    def <=>(other)
      @id <=> other.id
    end
    
    #Returns a hash value for this Label
    def hash
      @id
    end
    
    #Returns a string representation of this Label
    def to_s
      "#{@id}"
    end
    
    #ID of this Label
    attr_reader :id
  end
  
  #This class represents a transition in the automaton.
  class Transition
    #Creates a new instance of Transition, given an AlphabetItem, which invokes the transition,
    #and a target Node.
    def initialize(alphabetItem, targetNode)
      @alphabetItem = alphabetItem
      @targetNode = targetNode
    end
    
    #An AlphabetItem (alphabet symbol) which invokes this Transition
    attr_reader :alphabetItem
    #Target Node of this Transition
    attr_reader :targetNode
  end
  
end
