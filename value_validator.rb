class ValueValidator
  VALIDATOR_CLASS_RULE = {
  	"\"" => "StringValidator",
  	"[" => "ArrayValidator",
  	"{" => "HashValidator",
  	"t" => "BooleanValidator",
  	"f" => "BooleanValidator"
  }
  SKIP = [" ", "\n", "\t", "\s"]
  attr_accessor :i, :j, :char_matrix
  def initialize(i,j,char_matrix)
  	@i = i
  	@j = j
  	@char_matrix = char_matrix
  end
  	def valid
  		char = char_matrix[i][j]
  		if VALIDATOR_CLASS_RULE[char]
  			Object.const_get(VALIDATOR_CLASS_RULE[char]).new(i, j, char_matrix).valid
  		elsif char == "-" || char =~ /[0-9]/
        	NumberValidator.new(i, j, char_matrix).valid
        else
  		  raise UnexpectedTokenError.new(i,j,"Wrong way to start a value")
  	    end
	end
 end