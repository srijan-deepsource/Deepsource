require_relative "stack.rb"                 # => true
require_relative "value_validator.rb"
require_relative "string_validator.rb"      # ~> RuntimeError: Error at line 1: ANON was closed incorrectly
class KeyValueValidator
  SKIP = [" ", "\n", "\t", "\s"]
  attr_reader :i, :j, :char_matrix, :stack
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
            

            if stack.empty?
              next_row, next_column = StringValidator.new(row, column, char_matrix, "key").valid
              stack.push("\"")
              skip_char = true
            elsif stack.peek == "\""
                raise "Error at line #{row}: Hash key should be followed by :" unless char == ":"
                stack.push(":")
            elsif stack.peek == ":"
                return ValueValidator.new(row, column, char_matrix, "key").valid
            end
        end
     end
     raise "Error at line #{char_matrix.size-1}: Key value pair is in wrong format"
    end
end
# StringValidator.new(0,0,char_matrix).valid

# >> [["\"", "\"", "\"", "a", "b", "\n"], ["c", "\\", "\"", "\"", "\"", "\""]]
# >> [["\"", "\"", "\"", "a", "b", "\n"], ["c", "\\", "\"", "\"", "\"", "\""]]
# >> 
# >> [127, 136] in /Users/rajeevvishnu/Desktop/Deepsource/string_validator.rb
# >>    127:       if stack.empty?                                                                                                # => true, false, false
# >>    128:           stack.push("\"")                                                                                           # => ["\""]
# >>    129:           return false                                                                                               # => false
# >>    130:         else
# >>    131:           byebug                                                                                                     # => nil,   nil
# >> => 132:           last_entry = stack.peek                                                                                    # => "\\",  "\""
# >>    133:           raise "Error at line #{i}: Unexpected double quote here" unless KEY_NEXT_RULE["\""]&.include?(last_entry)  # => nil,   nil
# >>    134:           stack.pop if last_entry == "\\"                                                                            # => "\\",  nil
# >>    135:           if last_entry == "\""                                                                                      # => false, true
# >>    136:             return true if char_matrix[i][column..column+2].join == "\"\"\""                                         # => true
# >> (byebug) 
# >> [127, 136] in /Users/rajeevvishnu/Desktop/Deepsource/string_validator.rb
# >>    127:       if stack.empty?                                                                                                # => true, false, false
# >>    128:           stack.push("\"")                                                                                           # => ["\""]
# >>    129:           return false                                                                                               # => false
# >>    130:         else
# >>    131:           byebug                                                                                                     # => nil,   nil
# >> => 132:           last_entry = stack.peek                                                                                    # => "\\",  "\""
# >>    133:           raise "Error at line #{i}: Unexpected double quote here" unless KEY_NEXT_RULE["\""]&.include?(last_entry)  # => nil,   nil
# >>    134:           stack.pop if last_entry == "\\"                                                                            # => "\\",  nil
# >>    135:           if last_entry == "\""                                                                                      # => false, true
# >>    136:             return true if char_matrix[i][column..column+2].join == "\"\"\""                                         # => true
# >> (byebug) 

# ~> RuntimeError
# ~> Error at line 1: ANON was closed incorrectly
# ~>
# ~> /Users/rajeevvishnu/Desktop/Deepsource/string_validator.rb:108:in `next_triple_char'
# ~> /Users/rajeevvishnu/Desktop/Deepsource/string_validator.rb:81:in `block (2 levels) in valid_triple_string'
# ~> /Users/rajeevvishnu/Desktop/Deepsource/string_validator.rb:77:in `each'
# ~> /Users/rajeevvishnu/Desktop/Deepsource/string_validator.rb:77:in `block in valid_triple_string'
# ~> /Users/rajeevvishnu/Desktop/Deepsource/string_validator.rb:73:in `each'
# ~> /Users/rajeevvishnu/Desktop/Deepsource/string_validator.rb:73:in `valid_triple_string'
# ~> /Users/rajeevvishnu/Desktop/Deepsource/string_validator.rb:45:in `valid_string'
# ~> /Users/rajeevvishnu/Desktop/Deepsource/string_validator.rb:23:in `valid'
# ~> /Users/rajeevvishnu/Desktop/Deepsource/string_validator.rb:156:in `<top (required)>'
# ~> /Users/rajeevvishnu/Desktop/Deepsource/key_value_validator.rb:3:in `require_relative'
# ~> /Users/rajeevvishnu/Desktop/Deepsource/key_value_validator.rb:3:in `<top (required)>'
# ~> /Users/rajeevvishnu/Desktop/Deepsource/hash_validator.rb:3:in `require_relative'
# ~> /Users/rajeevvishnu/Desktop/Deepsource/hash_validator.rb:3:in `<top (required)>'
# ~> /Users/rajeevvishnu/Desktop/Deepsource/value_validator.rb:1:in `require_relative'
# ~> /Users/rajeevvishnu/Desktop/Deepsource/value_validator.rb:1:in `<top (required)>'
# ~> /Users/rajeevvishnu/Desktop/Deepsource/key_value_validator.rb:2:in `require_relative'
# ~> /Users/rajeevvishnu/Desktop/Deepsource/key_value_validator.rb:2:in `<main>'