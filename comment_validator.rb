require_relative "stack.rb"                      # => true
require_relative "char_matrix.rb"                # => true
class CommentValidator
  attr_reader :i, :j, :char_matrix, :hash_stack  # => nil
  def initialize(i,j,char_matrix)
  	@i = i                                        # => 0
  	@j = j                                        # => 0
  	@char_matrix = char_matrix                    # => [["/", "/", "a", "b", "c", "\n"]]
  end                                            # => :initialize

	def valid
		next_item = char_matrix[i][j+1]                               # => "/"
		if next_item && next_item == "/"                              # => true
			if char_matrix[i+1] && char_matrix[i+1][0]                   # => nil
				return i+1, 0
			else
				raise "Error at line #{i}: ANON cannot end with a comment"  # ~> RuntimeError: Error at line 0: ANON cannot end with a comment
			end
		else
			raise "Error at line #{i}: Invalid comment format"
		end
	end                                                            # => :valid
end                                                             # => :valid                                                          # => "'"

# char_matrix = [["{", "/"], ["/", "/", " ", "I", "'", "m", " ", "i", "g", "n", "o", "r", "e", "d", "\n"], ["\"", "a", "b", "c", "\"", " ", " ", ":", " ", " ", "[", "\"", "a", "b", "c", "\"", ",", " ", "{", "\"", "d", "e", "f", "\"", ":", " ", "\"", "d", "e", "f", "\"", "}", "]", " ", " ", " ", "\n"], ["}"]]  # => [["{", "/"], ["/", "/", " ", "I", "'", "m", " ", "i", "g", "n", "o", "r", "e", "d", "\n"], ["\"", "a", "b", "c", "\"", " ", " ", ":", " ", " ", "[", "\"", "a", "b", "c", "\"", ",", " ...
# i,j = 1,0                                                                                                                                                                                                                                                                                                            # => [1, 0]
# pp CommentValidator.new(i,j,char_matrix).valid                                                                                                                                                                                                                                                                       # => [2, 0]

# >> [["/", "/", "a", "b", "c", "\n"]]
# >> "'"
# >> [["/", "/", "a", "b", "c", "\n"]]

# ~> RuntimeError
# ~> Error at line 0: ANON cannot end with a comment
# ~>
# ~> /Users/rajeevvishnu/Desktop/Deepsource/comment_validator.rb:17:in `valid'
# ~> /Users/rajeevvishnu/Desktop/Deepsource/comment_validator.rb:26:in `<main>'

