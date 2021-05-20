require_relative "hash_validator.rb"           # => true
require_relative "char_matrix.rb"              # => true
require_relative "constants.rb"                # => true
class AnonValidator
  attr_accessor :char_matrix                   # => nil
  def initialize
    @char_matrix = CharMatrix.new.char_matrix  # => [["{", "\n"], ["/", "/", " ", "I", "'", "m", " ", "i", "g", "n", "o", "r", "e", "d", "\n"], ["\"", "K", "E", "Y", "\"", ":", " ", "\"", "V", "A", "L", "U", "E", "\"", "\n"], ["}"]]
  end                                          # => :initialize

  def valid
    for i in 0..(char_matrix.size-1)                                                                                 # => 0..3
        for j in 0..(char_matrix[i].size-1)                                                                          # => 0..1
            char = char_matrix[i][j]                                                                                 # => "{"
            next if Constants::SKIP_CHARS.include?(char)                                                             # => false
            char                                                                                                     # => "{"
            if char == "{"                                                                                           # => true
                next_i, next_j = Object.const_get(Constants::VALIDATOR_CLASS_RULE[char]).new(i,j,char_matrix).valid  # ~> ArgumentError: comparison of Integer with nil failed
                validate_anon_ending(next_i, next_j)
            else
              raise "Error at line #{i}: ANON should start with {"
            end
        end
    end

  rescue 
  end                                                                                                                # => :valid

  def validate_anon_ending(next_i, next_j)
    last_line = char_matrix.size-1
    if next_i == last_line && next_j == char_matrix[last_line].size-1
        puts "You have given a valid ANON"
    else
      raise "Error at line #{next_i}: ANON should end with }"
    end    
  end                                                                  # => :validate_anon_ending
end                                                                    # => :validate_anon_ending




AnonValidator.new.valid

# >> [["{", "\n"], ["/", "/", " ", "I", "'", "m", " ", "i", "g", "n", "o", "r", "e", "d", "\n"], ["\"", "K", "E", "Y", "\"", ":", " ", "\"", "V", "A", "L", "U", "E", "\"", "\n"], ["}"]]
# >> [["{", "\n"], ["/", "/", " ", "I", "'", "m", " ", "i", "g", "n", "o", "r", "e", "d", "\n"], ["\"", "K", "E", "Y", "\"", ":", " ", "\"", "V", "A", "L", "U", "E", "\"", "\n"], ["}"]]

# ~> ArgumentError
# ~> comparison of Integer with nil failed
# ~>
# ~> /Users/rajeevvishnu/Desktop/Deepsource/hash_validator.rb:42:in `<'
# ~> /Users/rajeevvishnu/Desktop/Deepsource/hash_validator.rb:42:in `block (2 levels) in valid'
# ~> /Users/rajeevvishnu/Desktop/Deepsource/hash_validator.rb:38:in `each'
# ~> /Users/rajeevvishnu/Desktop/Deepsource/hash_validator.rb:38:in `block in valid'
# ~> /Users/rajeevvishnu/Desktop/Deepsource/hash_validator.rb:34:in `each'
# ~> /Users/rajeevvishnu/Desktop/Deepsource/hash_validator.rb:34:in `valid'
# ~> /Users/rajeevvishnu/Desktop/Deepsource/anon_validator.rb:17:in `block (2 levels) in valid'
# ~> /Users/rajeevvishnu/Desktop/Deepsource/anon_validator.rb:12:in `each'
# ~> /Users/rajeevvishnu/Desktop/Deepsource/anon_validator.rb:12:in `block in valid'
# ~> /Users/rajeevvishnu/Desktop/Deepsource/anon_validator.rb:11:in `each'
# ~> /Users/rajeevvishnu/Desktop/Deepsource/anon_validator.rb:11:in `valid'
# ~> /Users/rajeevvishnu/Desktop/Deepsource/anon_validator.rb:39:in `<main>'
