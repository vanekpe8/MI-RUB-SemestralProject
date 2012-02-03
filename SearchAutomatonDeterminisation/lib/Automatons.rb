require_relative 'Queues.rb'
require_relative 'Node.rb'
include Queues

#This module contains classes related to Automatons
module Automatons

  #This class is a basic automaton class with functionality common for both
  #NonDeterministicAutomaton and DeterministicAutomaton
  class Automaton
    #Creates a new instance of Automaton and stores given alphabet for further usage.
    def initialize(alphabet)
      @alphabet = alphabet
      @nodes = Hash.new
      @nodes_array = []
    end
    
    #Returns number of nodes in this automaton
    def size
      @nodes.size
    end
    
    #Adds given node to this automaton
    def addNode(node)
      @nodes[node.descriptor] = node
      @nodes_array[@nodes_array.count] = node
      node
    end
    
    #Returns node which descriptor is the same as given descriptor
    def getNode(descriptor)
      @nodes[descriptor]
    end
    
    #Returns node by index
    def getNodeAt(index)
      @nodes_array[index]
    end
  end
  
  #This class represents a non-deterministic automaton. This type of automaton is essential
  #for creating deterministic automaton which can be used to search in the text.
  class NonDeterministicAutomaton < Automaton
    alias :superInit :initialize
    
    #Creates a new instance of NonDeterministicAutomaton
    def initialize(alphabet)
      superInit(alphabet)
      desc = NodeDescriptor.new
      desc.add(Label.new(0))
      @node0 = addNode(Node.new(desc))
      @nodeCtr = 1
    end
    
    #Updates structure of this automaton according to the given pattern
    def addPattern(pattern)
      node = @node0

      pl = pattern.length
      pl.times do |index|
        ch = pattern[index]
        if(!@alphabet.contains?(ch))
          raise "Search pattern contains elements, which are not in the alphabet."
        end
        aItem = AlphabetItem.new(ch)
        trs = node.getTransitionsFor(aItem)
        if(trs == nil)
          desc = NodeDescriptor.new
          desc.add(Label.new(@nodeCtr))
          @nodeCtr += 1
          newNode = addNode(Node.new(desc))
          node.addTransition(Transition.new(aItem, newNode))
        else
          newNode = trs[0].targetNode
        end
        node = newNode
      end
      node.finalPattern = pattern
        
    end
    
    #This method performs some steps, that must be performed after last search pattern is added
    #through NonDeterministicAutomaton#addPattern method.
    def finalize
      aSize = @alphabet.size
      aSize.times do |index|
        @node0.addTransition(Transition.new(@alphabet[index], @node0))
      end
    end
    
    #Returns instance of DeterministicAutomaton, created from this NonDeterministicAutomaton
    def makeDeterministic
      DeterministicAutomaton.new(self, @alphabet)
    end
  end
  
  #This class represents a deterministic search automaton. It is built from NonDeterministicAutomaton
  #and provides methods for continuous state changing. It also uses a listener, which is notified every
  #time, automaton reaches some of its final states.
  class DeterministicAutomaton < Automaton
    alias :superInit :initialize
    
    #Creates a new instance of DeterministicAutomaton from NonDeterministicAutomaton and an Alphabet
    def initialize(non_deterministic_automaton, alphabet)
      superInit(alphabet)
      @listener = nil
      @index = 0
      queue = NodeQueue.new
      desc = NodeDescriptor.new
      desc.add(Label.new(0))
      @node0 = addNode(Node.new(desc))
      queue.enqueue(@node0)
      create(non_deterministic_automaton, queue)
    end
    
    #Initializes search phase and sets a listener. The listener must respond to method
    #'report' with arguments 'pattern' and 'index'.
    def beginSearch(listener)
      raise "Wrong listener used." if(!listener.respond_to?(:report))
      @listener = listener
      @index = 0
      @currentState = @node0
    end
    
    #Given an AlphabetItem (alphabet symbol), this method changes state of this automaton.
    #It also notifies associated listener when final state is reached.
    def changeState(alphabetItem)
      #p "changing state for #{alphabetItem}"
      @currentState = @currentState.getTransitionsFor(alphabetItem)[0].targetNode
      #p "state changed successfully"
      if(@currentState.finalPattern != nil)
        raise 'No listener specified. "beginSearch" method must be called at the beginning of the search.' if(@listener == nil)
        @listener.report(@currentState.finalPattern, @index + 1 - @currentState.finalPattern.length)
      end
      @index += 1
    end
    
    private
    
    #This method handles the whole process of determinisation.
    def create(nda, queue)
      while(!queue.empty?)
        state = queue.dequeue # a deterministic state to resolve
        aSize = @alphabet.size
        aSize.times do |index|
          a = @alphabet[index]
          desc = NodeDescriptor.new # a descriptor for new deterministic node
          state.descriptor.labels.to_a.each do |label|
            #get non-deterministic node that is described by 'label'
            searchDescriptor = NodeDescriptor.new
            searchDescriptor.add(label)
            ndNode = nda.getNode(searchDescriptor)
            #if that node is final, the new deterministic node will be final too.
            if(ndNode.finalPattern != nil)
              state.finalPattern = ndNode.finalPattern
            end
            #get transitions for current alphabet symbol 'a'
            #Only non-deterministic node with label '0' may have more than one
            #transition for one alphabet symbol
            transitions = ndNode.getTransitionsFor(a)
            if(transitions == nil)
              #if there is no transition at all, it means there should be transition to node '0'
              transitions = [Transition.new(a, @node0)]
            end
            #add each target node label to the descriptor for new deterministic node.
            transitions.each do |transition|
              desc.add(transition.targetNode.descriptor.labels.to_a[0])
            end
          end
          newNode = getNode(desc)
          if(newNode == nil)
            newNode = addNode(Node.new(desc))
            queue.enqueue(newNode)
          end
          state.addTransition(Transition.new(a, newNode))
        end
      end
    end
    
  end
end
