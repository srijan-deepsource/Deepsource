class ArrayValidator
  ARRAY_NEXT_RULE = {
  	"value" => ["[", ","],
  	"," => ["value"],
  	"]" => ["value","[", ","]
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
	    
	    	if stack.empty? && char == "["
	    		stack.push(char)
	    	else
	    		last_entry = stack.peek
	    		if char == ","
	    			raise UnexpectedTokenError.new(row,column,"Unexpected token here") unless ARRAY_NEXT_RULE[","]&.include?(last_entry)
	    			stack.push(",")
	    	    elsif char == "]"
	    	    	raise UnexpectedTokenError.new(row,column,"Unexpected token here") unless ARRAY_NEXT_RULE["]"]&.include?(last_entry)
	    	    	return next_char(row,column)
	    	    else
	    	    	raise UnexpectedTokenError.new(row,column,"Unexpected token here") unless ARRAY_NEXT_RULE["value"]&.include?(last_entry)
	    	    	next_row, next_column = ValueValidator.new(row, column, char_matrix).valid
	    	    	skip_char = true
	    	    	stack.push("value")
	    	    end	
	    	end    	    					
		end
	end
	raise UnexpectedTokenError.new(row,column,"Array must end with ]")
  end

    def next_char(i,column)
       if char_matrix[i][column+1]
          return i, column+1
      elsif char_matrix[i+1] && char_matrix[i+1][0]
          return i+1, 0
      else
        raise UnexpectedTokenError.new(i,column,"ANON cannot end with an Array")
      end
    end
end

# char_matrix = CharMatrix.new.char_matrix
# ArrayValidator.new(0,0,char_matrix).valid