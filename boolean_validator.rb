require_relative "char_matrix.rb"     # => true
require "byebug"                      # => true
class BooleanValidator
  attr_accessor :i, :j, :char_matrix  # => nil
  def initialize(i,j,char_matrix)
    @i = i                            # => 0
    @j = j                            # => 0
    @char_matrix = char_matrix        # => [["f", "a", "l", "s", "e", " "]]
  end                                 # => :initialize
    
    def valid
      if char_matrix[i][j] == "t"                                          # => false
        return next_char(i,j+3) if char_matrix[i][j..j+3].join == "true"
      elsif char_matrix[i][j] == "f"                                       # => true
        return next_char(i,j+4) if char_matrix[i][j..j+4].join == "false"  # => true
      end
      raise "Error at line #{i}: Boolean is invalid"
    end                                                                    # => :valid

    def next_char(i,column)                                                        # => nil
       if char_matrix[i][column+1]                                  # => " "
          return i, column+1                                        # => 5
      elsif char_matrix[i+1] && char_matrix[i+1][0]
          return i+1, 0
      else
        raise "Error at line #{i}: ANON cannot end with a boolean"
      end
    end                                                             # => :next_char
 end                                                                # => :next_char  # => [0, 5]

# >> [["f", "a", "l", "s", "e", " "]]
# >> [["f", "a", "l", "s", "e", " "]]
# >> 
# >> [56, 65] in /Users/rajeevvishnu/.rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/seeing_is_believing-4.0.1/lib/seeing_is_believing/event_stream/producer.rb
# >>    56:       end
# >>    57: 
# >>    58:       StackErrors = [SystemStackError]
# >>    59:       StackErrors << Java::JavaLang::StackOverflowError if defined?(RUBY_PLATFORM) && RUBY_PLATFORM == 'java'
# >>    60:       def record_result(type, line_number, value)
# >> => 61:         counts = recorded_results[line_number] ||= Hash.new(0)
# >>    62:         count  = counts[type]
# >>    63:         recorded_results[line_number][type] = count.next
# >>    64:         if count < max_line_captures
# >>    65:           begin
# >> (byebug) 