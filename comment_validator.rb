class CommentValidator
  attr_reader :i, :j, :char_matrix, :hash_stack
  def initialize(i,j,char_matrix)
  	@i = i
  	@j = j
  	@char_matrix = char_matrix
  end

	def valid
		next_item = char_matrix[i][j+1]
		if next_item && next_item == "/"
			if char_matrix[i+1] && char_matrix[i+1][0]
				return i+1, 0
			else
				raise UnexpectedTokenError.new(i,char_matrix[i].size-1,"ANON cannot end with a comment")
			end
		else
			raise UnexpectedTokenError.new(i,j,"Invalid comment format")
		end
	end
end

# char_matrix = [["{", "/"], ["/", "/", " ", "I", "'", "m", " ", "i", "g", "n", "o", "r", "e", "d", "\n"], ["\"", "a", "b", "c", "\"", " ", " ", ":", " ", " ", "[", "\"", "a", "b", "c", "\"", ",", " ", "{", "\"", "d", "e", "f", "\"", ":", " ", "\"", "d", "e", "f", "\"", "}", "]", " ", " ", " ", "\n"], ["}"]]  # => [["{", "/"], ["/", "/", " ", "I", "'", "m", " ", "i", "g", "n", "o", "r", "e", "d", "\n"], ["\"", "a", "b", "c", "\"", " ", " ", ":", " ", " ", "[", "\"", "a", "b", "c", "\"", ",", " ...
# i,j = 1,0                                                                                                                                                                                                                                                                                                            # => [1, 0]
# pp CommentValidator.new(i,j,char_matrix).valid                                                                                                                                                                                                                                                                       # => [2, 0]

