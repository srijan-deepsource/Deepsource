require_relative "comment_validator.rb"        # => true
require_relative "key_value_validator.rb"      # => true
require_relative "stack.rb"                    # => true
require_relative "value_validator.rb"          # => true
require_relative "hash_validator.rb"           # => true
require_relative "array_validator.rb"          # => true
require_relative "string_validator.rb"         # => true
require_relative "boolean_validator.rb"        # => true
require_relative "number_validator.rb"         # => true
require_relative "char_matrix.rb"              # => true
require_relative "unexpected_token_error.rb"   # => true
require "byebug"                               # => true
class AnonValidator
  SKIP = [" ", "\n", "\t", "\s"]               # => [" ", "\n", "\t", " "]
  attr_accessor :char_matrix                   # => nil
  def initialize
    @char_matrix = CharMatrix.new.char_matrix  # => [["{", "\n"], ["\"", "h", "e", "r", "o", "e", "s", "\"", ":", " ", "[", "\n"], ["{", "\n"], ["\"", "r", "e", "a", "l", "_", "n", "a", "m", "e", "\"", ":", " ", "\"", "C", "l", "i", "n", "t", " ", "B", "a", "r", "t", "o", "n", "\"", ",", "\n"], ["\"", "s", "u", "p", "e", "r", "h", "e", "r", "o", "_", "n", "a", "m", "e", "\"", ":", " ", "\"", "H", "a", "w", "k", "e", "y", "e", "\"", ",", "\n"], ["}", ",", "\n"], ["{", "\n"], ["/", "/", " ", "D...
  end                                          # => :initialize

  def valid
    for i in 0..(char_matrix.size-1)                                            # => 0..17
      for j in 0..(char_matrix[i].size-1)                                     # => 0..1
          char = char_matrix[i][j]                                            # => "{"
          next if SKIP.include?(char)                                         # => false
          if char == "{"                                                      # => true
            if HashValidator.new(i,j,char_matrix,"main").valid                # => true
              puts "You have given a valid ANON"                              # => nil
              return
            else
              raise UnexpectedTokenError.new(i,j,"ANON should start with {")
            end
          end
        end  
    end

  rescue UnexpectedTokenError => e
    puts "Invalid ANON: Error in line #{e.i+1} with message: #{e.message}"
    line = ""
    for j in 0..e.j
      line += char_matrix[e.i][j]
    end
    puts line + "<--"
  rescue StandardError => e
    puts "Code is broken somewhere..Let's fix it"
    puts e.backtrace
  end                                                                       # => :valid
end                                                                         # => :valid




AnonValidator.new.valid  # => nil

# >> You have given a valid ANON
