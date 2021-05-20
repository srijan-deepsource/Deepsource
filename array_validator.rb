require_relative "stack.rb"            # => true
require_relative "char_matrix.rb"      # => true
require_relative "value_validator.rb"  # => true
require "byebug"                       # => false
class ArrayValidator
  ARRAY_NEXT_RULE = {
  	"value" => ["[", ","],              # => ["[", ","]
  	"," => ["value"],                   # => ["value"]
  	"]" => ["value","[", ","]           # => ["value", "[", ","]
  }                                    # => {"value"=>["[", ","], ","=>["value"], "]"=>["value", "[", ","]}

  SKIP = [" ", "\n", "\t", "\s"]              # => [" ", "\n", "\t", " "]
  attr_accessor :i, :j, :char_matrix, :stack  # => nil
  def initialize(i,j,char_matrix)
  	@i = i                                     # => 0
  	@j = j                                     # => 0
  	@char_matrix = char_matrix                 # => [["[", "\"", "1", "2", "3", "\"", ",", " ", "\"", "\"", "\"", "\\", "\"", "1", "2", "3", "\"", "\"", "\"", ",", "]", " "]]
  	@stack = Stack.new                         # => #<Stack:0x00007f932810d160 @ary=[], @max_size=1000>
  end                                         # => :initialize

  def valid
  	skip_char = false  # => false
	next_row = 0         # => 0
	next_column = 0      # => 0

  	for row in i..(char_matrix.size-1)            # => 0..0
  		if row != i                                  # => false
  			@j = 0
  		end                                          # => nil
	    for column in j..(char_matrix[row].size-1)  # => 0..21
	    	char = char_matrix[row][column]            # => "[",   "\"",  "1",  "2",  "3",  "\"", ",",  " ",   "\"",  "\"", "\"", "\\", "\"", "1",  "2",  "3",  "\"", "\"", "\"", ",",  "]"
	    	if skip_char == true                       # => false, false, true, true, true, true, true, false, false, true, true, true, true, true, true, true, true, true, true, true, false
	    	 next if row < next_row                    # => false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false
	    	 next if column < next_column              # => true,  true,  true,  true,  false, true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  false
				next_row = 0                                 # => 0, 0
				next_column = 0                              # => 0, 0
			 	
	    	 skip_char = false  # => false, false
	    	end                 # => nil, nil, false, nil, nil, false, nil
	    	
	    	next if SKIP.include?(char)  # => false, false, false, true, false, false, false
	    
	    	if stack.empty? && char == "["                                                                                  # => true, false, false, false, false, false
	    		stack.push(char)                                                                                               # => ["["]
	    	else
	    		last_entry = stack.peek                                                                                        # => "[",   "value", ",",   "value", ","
	    		if char == ","                                                                                                 # => false, true,    false, true,    false
	    			raise "Error at line #{row}: Unexpected token here" unless ARRAY_NEXT_RULE[","]&.include?(last_entry)         # => nil,                 nil
	    			stack.push(",")                                                                                               # => ["[", "value", ","], ["[", "value", ",", "value", ","]
	    	    elsif char == "]"                                                                                           # => false, false, true
	    	    	raise "Error at line #{row}: Unexpected token here" unless ARRAY_NEXT_RULE["]"]&.include?(last_entry)      # => nil
	    	    	return next_char(row,column)                                                                               # => [0, 21]
	    	    else
	    	    	raise "Error at line #{row}: Unexpected token here" unless ARRAY_NEXT_RULE["value"]&.include?(last_entry)  # => nil,            nil
	    	    	next_row, next_column = ValueValidator.new(row, column, char_matrix).valid                                 # => [0, 6],         [0, 19]
	    	    	skip_char = true                                                                                           # => true,           true
	    	    	stack.push("value")                                                                                        # => ["[", "value"], ["[", "value", ",", "value"]
	    	    end	
	    	end    	    					
		end
	end
	raise "Error at line #{row}: Array must end with ]"
  end                                                                                                                 # => :valid

    def next_char(i,column)
       if char_matrix[i][column+1]                                 # => " "
          return i, column+1                                       # => 21
      elsif char_matrix[i+1] && char_matrix[i+1][0]
          return i+1, 0
      else
        raise "Error at line #{i}: ANON cannot end with an Array"
      end
    end                                                            # => :next_char
end                                                                # => :next_char  # => [0, 21]

# >> [["[", "\"", "1", "2", "3", "\"", ",", " ", "\"", "\"", "\"", "\\", "\"", "1", "2", "3", "\"", "\"", "\"", ",", "]", " "]]
# >> [["[", "\"", "1", "2", "3", "\"", ",", " ", "\"", "\"", "\"", "\\", "\"", "1", "2", "3", "\"", "\"", "\"", ",", "]", " "]]
# >> 
# >> [127, 136] in /Users/rajeevvishnu/Desktop/Deepsource/string_validator.rb
# >>    127:       if stack.empty?                                                                                                # => true, false, false
# >>    128:           stack.push("\"")                                                                                           # => ["\""]
# >>    129:           return false                                                                                               # => false
# >>    130:         else
# >>    131:           byebug                                                                                                     # => nil,   nil
# >> => 132:           last_entry = stack.peek                                                                                    # => "\\",  "\""
# >>    133:           raise "Error at line #{i}: Unexpected double quote here" unless KEY_NEXT_RULE["\""]&.include?(last_entry)  # => nil,   nil
# >>    134:           stack.pop if last_entry == "\\"                                                                            # => "\\",  nil
# >>    135:           if last_entry == "\""                                                                                      # => false, true
# >>    136:             return true if char_matrix[i][column..column+2].join == "\"\"\""                                         # => true
# >> (byebug) 
# >> [127, 136] in /Users/rajeevvishnu/Desktop/Deepsource/string_validator.rb
# >>    127:       if stack.empty?                                                                                                # => true, false, false
# >>    128:           stack.push("\"")                                                                                           # => ["\""]
# >>    129:           return false                                                                                               # => false
# >>    130:         else
# >>    131:           byebug                                                                                                     # => nil,   nil
# >> => 132:           last_entry = stack.peek                                                                                    # => "\\",  "\""
# >>    133:           raise "Error at line #{i}: Unexpected double quote here" unless KEY_NEXT_RULE["\""]&.include?(last_entry)  # => nil,   nil
# >>    134:           stack.pop if last_entry == "\\"                                                                            # => "\\",  nil
# >>    135:           if last_entry == "\""                                                                                      # => false, true
# >>    136:             return true if char_matrix[i][column..column+2].join == "\"\"\""                                         # => true
# >> (byebug) 