require_relative "stack.rb"
require_relative "comment_validator.rb"
require_relative "key_value_validator.rb"
require_relative "char_matrix.rb"
require "byebug"
class HashValidator
  HASH_NEXT_RULE = {
  	"\"" => [",", "{"],
  	"," => ["\""],
  	"/" => ["\"", ",", "{"],
  	"}" => ["\"", ",", "{"]
  }

  HASH_PUSH_RULE = ["\"", ","]

  VALIDATOR_CLASS_RULE = {
  	"/" => "CommentValidator",
  	"\"" => "KeyValueValidator"
  }

  SKIP = [" ", "\n", "\t", "\s"]
  attr_accessor :i, :j, :char_matrix, :stack
  def initialize(i,j,char_matrix)
  	@i = i
  	@j = j
  	@char_matrix = char_matrix
  	@stack = Stack.new
  end

  def valid
  	skip_char = false
	next_row = 0
	next_column = 0

  	for row in i..(char_matrix.size-1)
  		if row != i
  			@j = 0
  		end
	    for column in j..(char_matrix[row].size-1)
	    	char = char_matrix[row][column]
	    	if skip_char == true
	    	 next if row < next_row
	    	 next if column < next_column
				next_row = 0
				next_column = 0
			 	
	    	 skip_char = false
	    	end
	    	
	    	next if SKIP.include?(char)
	    
	    	if char == "{"
	    		raise "Error at line #{row}: Hash cannot have two {" unless stack.empty?
	    		stack.push(char)
	    	else
	    		last_entry = stack.peek
	    		
	    		puts row,column
	    		HASH_NEXT_RULE[char]&.include?(last_entry)
				raise "Error at line #{row}: Unexpected token here" unless HASH_NEXT_RULE[char]&.include?(last_entry)
				if char == "}"
					if char_matrix[row][column+1]
						return row, column+1
					elsif char_matrix[row+1] && char_matrix[row+1][0]
						return row+1, 0
					else
						return row, column
					end
				end
				stack.push(char) if HASH_PUSH_RULE.include?(char)
				if VALIDATOR_CLASS_RULE[char]
				 next_row, next_column = Object.const_get(VALIDATOR_CLASS_RULE[char]).new(row, column, char_matrix).valid
				 skip_char = true
				end
			end
	    end
	 end
	 raise "Error at line #{char_matrix.size-1}: Hash must end with }"
	end
 end
