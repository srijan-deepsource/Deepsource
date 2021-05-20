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
  attr_accessor :i, :j, :char_matrix, :stack, :type
  def initialize(i,j,char_matrix, type = "other")
  	@i = i
  	@j = j
  	@char_matrix = char_matrix
  	@stack = Stack.new
  	@type = type
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
	    
	    	if stack.empty? && char == "{"
	    		stack.push(char)
	    	else
	    		last_entry = stack.peek
				raise UnexpectedTokenError.new(row,column,"Unexpected token here") unless HASH_NEXT_RULE[char]&.include?(last_entry)
				return next_char(row,column) if char == "}"
				stack.push(char) if HASH_PUSH_RULE.include?(char)
				if VALIDATOR_CLASS_RULE[char]
				 next_row, next_column = Object.const_get(VALIDATOR_CLASS_RULE[char]).new(row, column, char_matrix).valid
				 skip_char = true
				end
			end
	    end
	 end
	 raise UnexpectedTokenError.new(row,column,"Hash must end with }")
	end

	def next_char(i,column)
	  return true if type == "main"
      if char_matrix[i][column+1]
          return i, column+1
      elsif char_matrix[i+1] && char_matrix[i+1][0]
        return i+1, 0
      else
        raise UnexpectedTokenError.new(i,column,"Invalid end to a ANON")
      end
    end
 end
