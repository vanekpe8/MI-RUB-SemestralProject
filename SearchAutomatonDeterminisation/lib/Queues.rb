#This module contains queue types
module Queues

  #This class is a typical queue used for processing new nodes in DeterministicAutomaton
  class NodeQueue
    #Creates a new instance of NodeQueue
    def initialize
      @items = []
    end
    
    #Adds given node to the queue
    def enqueue(node)
      @items[@items.count] = node
    end
    
    #Returns first node from the queue
    def dequeue
      @items.delete_at(0)
    end
    
    #Returns true is this queue is empty
    def empty?
      @items.count == 0
    end
  end
end
