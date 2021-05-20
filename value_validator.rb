require_relative "hash_validator.rb"
# require_relative "array_validator.rb"
require_relative "string_validator.rb"
require_relative "boolean_validator.rb"
require_relative "number_validator.rb"
require_relative "char_matrix.rb"
require_relative "unexpected_token_error.rb"
require "byebug"
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
        	NumberValidator.new(i, j, char_matrix).valid                           # ~> RuntimeError: Error at line 0: Number is invalid
        else
  		  raise "Error at line #{i}: Wrong way to start a value"
  	    end
	end
 end

# >> [["-", "-", "1", "2", "3"]]
# >> [["-", "-", "1", "2", "3"]]

# ~> RuntimeError
# ~> Error at line 0: Number is invalid
# ~>
# ~> /Users/rajeevvishnu/Desktop/Deepsource/number_validator.rb:29:in `valid'
# ~> /Users/rajeevvishnu/Desktop/Deepsource/value_validator.rb:28:in `valid'
# ~> /Users/rajeevvishnu/Desktop/Deepsource/value_validator.rb:36:in `<top (required)>'
# ~> /Users/rajeevvishnu/Desktop/Deepsource/key_value_validator.rb:2:in `require_relative'
# ~> /Users/rajeevvishnu/Desktop/Deepsource/key_value_validator.rb:2:in `<top (required)>'
# ~> /Users/rajeevvishnu/Desktop/Deepsource/hash_validator.rb:3:in `require_relative'
# ~> /Users/rajeevvishnu/Desktop/Deepsource/hash_validator.rb:3:in `<top (required)>'
# ~> /Users/rajeevvishnu/Desktop/Deepsource/value_validator.rb:1:in `require_relative'
# ~> /Users/rajeevvishnu/Desktop/Deepsource/value_validator.rb:1:in `<main>'