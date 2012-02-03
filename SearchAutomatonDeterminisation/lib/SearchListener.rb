module Automatons
  #This class implements a listener for DeterministicAutomaton.
  #This listener stores start indices of each reported pattern.
  class SearchListener
    #Creates a new instance of SearchListener
    def initialize
      clear
    end
    #Clears the listener's memory
    def clear
      @patterns = Set.new
      @arrays_of_indices = Hash.new
    end
    
    #Sets a patterns, which are expected to be found (This is optional)
    def bind_to(patterns)
      patterns.each do |pattern|
        @patterns.add(pattern)
        @arrays_of_indices[pattern] = []
      end
    end
    
    #This method is called by DeterministicAutomaton every time it finds an occurence
    #of some pattern
    def report(pattern, index)
      @patterns.add(pattern) if(!@patterns.include?(pattern))
      arr = @arrays_of_indices[pattern]
      if(arr == nil)
        @arrays_of_indices[pattern] = [index]
      else
        arr[arr.count] = index
      end
      
    end
    
    #Returns sorted list of reported patterns
    def patterns
      @patterns.to_a.sort
    end
    
    #Returns an array of start indices for given pattern
    def indicesFor(pattern)
      @arrays_of_indices[pattern]
    end
  end
  
end
