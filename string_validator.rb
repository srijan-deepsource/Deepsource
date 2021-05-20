class StringValidator
  KEY_NEXT_RULE = {
    "\"" => ["\\", "\""],
    "\\" => ["\"", "\\"]
  }
  SKIP = [" ", "\n", "\t", "\s"]
  attr_accessor :i, :j, :char_matrix, :type, :stack
  def initialize(i,j,char_matrix,type="string")
    @i = i
    @j = j
    @char_matrix = char_matrix
    @type = type
    @stack = Stack.new
  end

    def valid
      if type == "key"
        valid_key
      else
        valid_string
      end
   end

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
      raise UnexpectedTokenError.new(i,column,"Key has to end with \" on the same line")
   end

   def valid_string
     char_matrix[i][j..j+2].join
     if char_matrix[i][j..j+2].join == "\"\"\""
       valid_triple_string
     else
      valid_double_string
     end
   end

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
     raise UnexpectedTokenError.new(row,column,"Invalid string format") 
    end

    def valid_triple_string
      @j = @j + 2
      for row in i..(char_matrix.size-1)
        if row != i
            @j = 0
        end
        for column in j..(char_matrix[row].size-1)
            char = char_matrix[row][column]
            next if SKIP.include?(char)
             if char == "\""
              return next_triple_char(row,column) if validate_triple_quote_char(row,column)
            elsif char == "\\"
              validate_escape_char(row,column)
            else
              validate_other_chars(row,column)
            end
        end
     end
     raise UnexpectedTokenError.new(row,column,"Invalid string format")
    end

   def next_char(i,column)
     if char_matrix[i][column+1]
            return i, column+1
      elsif char_matrix[i+1] && char_matrix[i+1][0]
          return i+1, 0
      else
        raise UnexpectedTokenError.new(i,column,"ANON was closed incorrectly")
      end
   end

   def next_triple_char(i,column)
     if char_matrix[i][column+3]
            return i, column+3
      elsif char_matrix[i+1] && char_matrix[i+1][0]
          return i+1, 0
      else
        raise UnexpectedTokenError.new(i,column,"ANON was closed incorrectly")
      end
   end

   def validate_other_chars(i,column)
     raise UnexpectedTokenError.new(i,column,"Unexpected token here") if stack.peek == "\\"
   end

   def validate_escape_char(i,column)
      last_entry = stack.peek
      raise UnexpectedTokenError.new(i,column,"Unexpected escape character here") unless KEY_NEXT_RULE["\\"]&.include?(last_entry)
      if last_entry == "\\"
        stack.pop
      else   
        stack.push("\\")
      end
   end

   def validate_triple_quote_char(i,column)
      if stack.empty?
          stack.push("\"")
          return false
        else
          last_entry = stack.peek
          raise UnexpectedTokenError.new(i,column,"Unexpected double quote here") unless KEY_NEXT_RULE["\""]&.include?(last_entry)
          stack.pop if last_entry == "\\"
          if last_entry == "\""
            return true if char_matrix[i][column..column+2].join == "\"\"\""
            raise UnexpectedTokenError.new(i,column,"String was not closed properly")
          end
      end
   end

    def validate_quote_char(i,column)
      if stack.empty?
          stack.push("\"")
          return false
        else
          last_entry = stack.peek
          raise UnexpectedTokenError.new(i,column,"Unexpected double quote here") unless KEY_NEXT_RULE["\""]&.include?(last_entry)
          stack.pop if last_entry == "\\"
          return true if last_entry == "\""
      end
   end
 end