#This module contains classes related to input loading
module InputHandling
  
  #This class holds primary input data. That is an alphabet, search patterns, and path to file which is to be searched
  class Input
    #Creates new instance of Input
    def initialize
      @alphabet = []
      @searchPatterns = []
      @file = nil
    end
    
    #An alphabet
    attr_accessor :alphabet
    #Array of search patterns
    attr_accessor :searchPatterns
    #File to search
    attr_accessor :file
  end
  
  #This class is responsible for loading input from file
  class InputLoader
    #This method takes empty instance of Input class and a File
    def loadInput(input, file)
      raise "Invalid Input type" unless input.respond_to?(:alphabet) &&
                                     input.respond_to?(:searchPatterns) &&
                                     input.respond_to?(:file)
      str = file.readline.chomp
      input.alphabet = str.split
      str = file.readline.chomp
      input.searchPatterns = str.split('|')
      str = file.readline.chomp
      input.file = File.new(str)
    end
  end
end
