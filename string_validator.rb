require_relative "stack.rb"                          # => true
require_relative "char_matrix.rb"                    # => true
require "byebug"                                     # => true
class StringValidator
  KEY_NEXT_RULE = {
    "\"" => ["\\", "\""],                            # => ["\\", "\""]
    "\\" => ["\"", "\\"]                             # => ["\"", "\\"]
  }                                                  # => {"\""=>["\\", "\""], "\\"=>["\"", "\\"]}
  SKIP = [" ", "\n", "\t", "\s"]                     # => [" ", "\n", "\t", " "]
  attr_accessor :i, :j, :char_matrix, :type, :stack  # => nil
  def initialize(i,j,char_matrix,type="string")
    @i = i                                           # => 0
    @j = j                                           # => 0
    @char_matrix = char_matrix                       # => [["\"", "\"", "\"", "a", "b", "\n"], ["c", "m", "k", "f", "\n"], ["k", "f", "l", "k", "f", "'", "'", "'", "\n"], ["n", "f", "k", "j", "f", "k", "f", "\\", "\"", "\"", "\"", "\"", " "]]
    @type = type                                     # => "string"
    @stack = Stack.new                               # => #<Stack:0x00007fb4d1181248 @ary=[], @max_size=1000>
  end                                                # => :initialize

    def valid
      if type == "key"  # => false
        valid_key
      else
        valid_string    # => [3, 12]
      end               # => [3, 12]
   end                  # => :valid

   def valid_key
      for column in j..(char_matrix[i].size-1)
        char = char_matrix[i][column]
        next if SKIP.include?(char)
        if char == "\""
          return next_char(i,column) if validate_quote_char(i,column)
        elsif char == "\\"
          validate_escape_char(i,column)
        else
          validate_other_chars(i,column)
        end           
      end
      raise "Error at line #{i}: Key has to end with \" on the same line"
   end                                                                     # => :valid_key

   def valid_string
     char_matrix[i][j..j+2].join                 # => "\"\"\""
     if char_matrix[i][j..j+2].join == "\"\"\""  # => true
       valid_triple_string                       # => [3, 12]
     else
      valid_double_string
     end                                         # => [3, 12]
   end                                           # => :valid_string

  def valid_double_string
    for row in i..(char_matrix.size-1)
        if row != i
            @j = 0
        end
        for column in j..(char_matrix[row].size-1)
            char = char_matrix[row][column]
            next if SKIP.include?(char)
             if char == "\""
              return next_char(row,column) if validate_quote_char(row,column)
            elsif char == "\\"
              validate_escape_char(row,column)
            else
              validate_other_chars(row,column)
            end
        end
     end
     raise "Error at line #{char_matrix.size-1}: Invalid string format"
    end                                                                        # => :valid_double_string

    def valid_triple_string
      @j = @j + 2                                                                            # => 2
      for row in i..(char_matrix.size-1)                                                     # => 0..3
        if row != i                                                                          # => false, true, true, true
            @j = 0                                                                           # => 0, 0, 0
        end                                                                                  # => nil,  0,    0,    0
        for column in j..(char_matrix[row].size-1)                                           # => 2..5, 0..4, 0..8, 0..12
            char = char_matrix[row][column]                                                  # => "\"",  "a",   "b",   "\n", "c",   "m",   "k",   "f",   "\n", "k",   "f",   "l",   "k",   "f",   "'",   "'",   "'",   "\n", "n",   "f",   "k",   "j",   "f",   "k",   "f",   "\\",  "\"",  "\""
            next if SKIP.include?(char)                                                      # => false, false, false, true, false, false, false, false, true, false, false, false, false, false, false, false, false, true, false, false, false, false, false, false, false, false, false, false
             if char == "\""                                                                 # => true, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, true, true
              return next_triple_char(row,column) if validate_triple_quote_char(row,column)  # => false, nil, true
            elsif char == "\\"                                                               # => false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, true
              validate_escape_char(row,column)                                               # => ["\"", "\\"]
            else
              validate_other_chars(row,column)                                               # => nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil
            end
        end                                                                                  # => 2..5, 0..4, 0..8
     end
     raise "Error at line #{char_matrix.size-1}: Invalid string format"
    end                                                                                      # => :valid_triple_string

   def next_char(i,column)
     if char_matrix[i][column+1]
            return i, column+1
      elsif char_matrix[i+1] && char_matrix[i+1][0]
          return i+1, 0
      else
        raise "Error at line #{i}: ANON was closed incorrectly"
      end
   end                                                           # => :next_char

   def next_triple_char(i,column)
     if char_matrix[i][column+3]                                 # => " "
            return i, column+3                                   # => 12
      elsif char_matrix[i+1] && char_matrix[i+1][0]
          return i+1, 0
      else
        raise "Error at line #{i}: ANON was closed incorrectly"
      end
   end                                                           # => :next_triple_char

   def validate_other_chars(i,column)
     raise "Error at line #{i}: Unexpected token here" if stack.peek == "\\"  # => nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil
   end                                                                        # => :validate_other_chars

   def validate_escape_char(i,column)
      last_entry = stack.peek                                                                                        # => "\""
      raise "Error at line #{i}: Unexpected escape character here" unless KEY_NEXT_RULE["\\"]&.include?(last_entry)  # => nil
      if last_entry == "\\"                                                                                          # => false
        stack.pop
      else   
        stack.push("\\")                                                                                             # => ["\"", "\\"]
      end                                                                                                            # => ["\"", "\\"]
   end                                                                                                               # => :validate_escape_char

   def validate_triple_quote_char(i,column)
      if stack.empty?                                                                                                # => true, false, false
          stack.push("\"")                                                                                           # => ["\""]
          return false                                                                                               # => false
        else
          byebug                                                                                                     # => nil,   nil
          last_entry = stack.peek                                                                                    # => "\\",  "\""
          raise "Error at line #{i}: Unexpected double quote here" unless KEY_NEXT_RULE["\""]&.include?(last_entry)  # => nil,   nil
          stack.pop if last_entry == "\\"                                                                            # => "\\",  nil
          if last_entry == "\""                                                                                      # => false, true
            return true if char_matrix[i][column..column+2].join == "\"\"\""                                         # => true
            raise "Error at line #{i}: String was not closed properly"
          end                                                                                                        # => nil
      end
   end                                                                                                               # => :validate_triple_quote_char

    def validate_quote_char(i,column)
      if stack.empty?
          stack.push("\"")
          return false
        else
          last_entry = stack.peek
          raise "Error at line #{i}: Unexpected double quote here" unless KEY_NEXT_RULE["\""]&.include?(last_entry)
          stack.pop if last_entry == "\\"
          return true if last_entry == "\""
      end
   end                                                                                                               # => :validate_quote_char
 end                                                                                                                 # => :validate_quote_char # => [3, 12]

# >> [["\"", "\"", "\"", "a", "b", "\n"], ["c", "m", "k", "f", "\n"], ["k", "f", "l", "k", "f", "'", "'", "'", "\n"], ["n", "f", "k", "j", "f", "k", "f", "\\", "\"", "\"", "\"", "\"", " "]]
# >> [["\"", "\"", "\"", "a", "b", "\n"], ["c", "m", "k", "f", "\n"], ["k", "f", "l", "k", "f", "'", "'", "'", "\n"], ["n", "f", "k", "j", "f", "k", "f", "\\", "\"", "\"", "\"", "\"", " "]]
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