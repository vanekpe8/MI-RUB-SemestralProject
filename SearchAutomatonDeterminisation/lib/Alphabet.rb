#This module contains classes related to the Alphabet
module AlphabetManagement

  require 'set'
  
  #This class represents an alphabet. An alphabet is a set of valid symbols (all
  #patterns, as well as searched file, must contain only symbols from alphabet)
  class Alphabet
  
    #Creates new instance of Alphabet, given an array of strings (alphabet symbols).
    #Current implementation requires that each alphabet symbol is only one character.
    def initialize(alphabet_values)
      @items = []
      @items_set = Set.new
      @items_hash = Hash.new
      alphabet_values.each_with_index do |value, index|
        raise "Alphabet symbols may be only one character strings." if value.length > 1
        @items[index] = AlphabetItem.new(value)
        @items_hash[value] = @items[index]
        @items_set.add(value)
      end
      raise "Repetitions found in alphabet." if @items.count != @items_set.size
    end
    
    #Returns stored AlphabetItem by string value.
    def get(value)
      ret = @items_hash[value]
      raise "Invalid alphabet character used." if(ret == nil)
      ret
    end
    
    #Returns true if 'item' is present in this alphabet. Item may be either
    #string value or AlphabetItem
    def contains?(item)
      @items_set.include?(item.to_s)
    end
    
    #Returns number of alphabet symbols used in this Alphabet
    def size
      @items_set.size
    end
    
    #Allows direct access to stored AlphabetItems by index
    def [](index)
      @items[index]
    end
    
    #Applies given block to each AlphabetItem
    def each(&block)
      @items.each do |item|
        block.call(item)
      end
    end
  end
  
  #This class represents one alphabet symbol
  class AlphabetItem
    #Creates new instance of AlphabetItem with given string value
    def initialize(value)
      @value = value
    end
    
    #Compares AlphabetItems
    def eql?(other)
      if(!other.instance_of?(AlphabetItem))
        false
      else
        @value == other.value
      end
    end
    
    #Compares AlphabetItems
    def ==(other)
      eql?(other)
    end
    
    #Returns hash value of this AlphabetItem
    def hash
      @value.hash
    end
    
    #Returns string representation of this AlphabetItem
    def to_s
      "#{@value}"
    end
    
    #value of this AlphabetItem (alphabet symbol string)
    attr_reader :value
  end
end
