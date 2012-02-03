require_relative '../lib/InputHandling.rb'
require_relative '../lib/Alphabet.rb'
require_relative '../lib/Automatons.rb'
require_relative '../lib/SearchListener.rb'
require_relative '../lib/Printer.rb'

#This module joins together all other modules to accomplish the goal of this semestral project.<br/>
#The goal of this project is to implement an application, which takes an alphabet, a list of patterns and a text file,
#and finds all occurences of all given patterns in given text file, using deterministic automaton (which is built from given patterns
#and given alphabet).
module SearchAutomatonDeterminisation

  include InputHandling
  include AlphabetManagement
  include Automatons
  
  #This class encapsulates the main entry point to the application
  class MainClass
  
    #This method is the main entry point to the application
    def run
      begin
      #handle input
      input = Input.new
      loader  = InputLoader.new
      loader.loadInput(input, ARGF)
      #create alphabet
      alphabet = Alphabet.new(input.alphabet)
      
      #get search patterns
      patterns = input.searchPatterns
      
      #create non-deterministic automaton
      nda = NonDeterministicAutomaton.new(alphabet)
      
      #add patterns
      patterns.each do |pattern|
        nda.addPattern(pattern)
      end
      nda.finalize
      p "NDA complete (#{nda.size} nodes)"
      #create deterministic automaton
      da = nda.makeDeterministic
      p "DA complete (#{da.size} nodes)"
      #initialize
      listener = SearchListener.new
      listener.bind_to(patterns)
      da.beginSearch(listener)
      
      #readFile
      file = input.file
      file.each_line do |line|
        line = line.chomp
        line.each_char do |char|
          da.changeState(alphabet.get(char))
        end
      end
      
      #print results
      puts "Following patterns were found [starting indices]:"
      patterns = listener.patterns
      patterns.each do |pattern|
        puts "#{pattern}: #{listener.indicesFor(pattern).to_s}"
      end
      puts "-------------------"
      puts "Non-Deterministic Automaton (Table of transitions):"
      printer = Printer.new(alphabet)
      printer.print_automaton(nda)
      puts ""
      puts "Deterministic Automaton (Table of transitions):"
      printer.print_automaton(da)
      
      rescue RuntimeError => ex
        puts "An error occured: #{ex.message}"
      ensure
        file.close if(file != nil)
      end
    
    end
  end

end

include SearchAutomatonDeterminisation

main = MainClass.new
main.run
