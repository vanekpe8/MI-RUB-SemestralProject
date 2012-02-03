require_relative 'Automatons.rb'
require_relative 'Node.rb'

module Automatons
  #This method takes a string, and adds a certain number of spaces to fix it
  #to given size ('fixedSize' parameter). It can be also told to align string
  #to the right.
  def fixed_string(string, fixedSize, rightAlign=false)
    len = string.length
    res = ""
    res = " " + string if !rightAlign
    (fixedSize - len - 1).downto(1) do
      res = res + " "
    end
    res = res + string + " " if rightAlign
    res 
  end
  
  #This class can print an Automaton to the standard output. The automaton is
  #printed as a table of transitions.
  class Printer
    #Creates a new instance of Printer
    def initialize(alphabet)
      @alphabet = alphabet
    end
    
    #Prints the given automaton
    def print_automaton(automaton)
      maxLength = 0
      #p automaton.size
      automaton.size.times do |index|
        #p "debug (cycle 1): #{index}"
        node = automaton.getNodeAt(index)
        str = node.descriptor.to_s
        if(index == 0)
          @alphabet.each do |item|
            transitions = node.getTransitionsFor(item)
            if(transitions.count > 1)
              str = get_string_from_transitions(transitions)
            end
          end
        end
        maxLength = str.length if str.length > maxLength
      end
      
      print_line_separator(maxLength+2,' ')
      
      
      @alphabet.each do |item|
        print fixed_string(item.to_s, maxLength,true)
        print '|'
      end
      print "\n"
      print_whole_line_separator(maxLength, @alphabet.size)
      automaton.size.times do |node_index|
        node = automaton.getNodeAt(node_index)
        print fixed_string(node.descriptor.to_s,maxLength+2)
        print "|"
        @alphabet.each do |item|
          transitions = node.getTransitionsFor(item)
          if(transitions == nil || transitions.count == 0)
            print fixed_string("",maxLength)
          else
            str = ""
            if(transitions.count > 1)
              str = get_string_from_transitions(transitions).delete("[]")
            else
              str = transitions[0].targetNode.descriptor.to_s.delete("[]")
            end
            #transitions.each_with_index do |transition, tr_index|
            #  str = str + "," if(tr_index > 0)
            #  str = str + transition.targetNode.descriptor.to_s.delete("[]")
            #end
            print fixed_string(str, maxLength)
          end
          print '|'
        end
        print "\n"
        print_whole_line_separator(maxLength,@alphabet.size)
      end
    end
    
    private
    
    #Prints a 'filling' 'width' times followed by character '|' (column separator)
    def print_line_separator(width, filling='-')
      width.times do
        print filling
      end
      print '|'
    end
    
    #Prints a line separator accross the whole table
    def print_whole_line_separator(col_width, alphabet_size)
      print_line_separator(col_width+2)
      alphabet_size.times do |index|
        print_line_separator(col_width)
      end
      print "\n"
    end
    
    #Prints a string, consisting of descriptors
    #of target nodes of all transitions
    def get_string_from_transitions(transitions)
      id_arr = []
      index = 0
      transitions.each do |transition|
        labels = transition.targetNode.descriptor.labels.to_a
        labels.each do |label|
          id_arr[index] = label.id
          index = index + 1
        end
      end
      id_arr = id_arr.sort
      res = "["
      id_arr.each_with_index do |id,index|
        res = res + "," if(index > 0)
        res = res + id.to_s
      end
      res = res + "]"
      res
    end
  end
  
  
end
