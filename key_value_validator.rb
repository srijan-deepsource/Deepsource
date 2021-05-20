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
                raise UnexpectedTokenError.new(row,column,"Hash key should be followed by :") unless char == ":"
                stack.push(":")
            elsif stack.peek == ":"
                return ValueValidator.new(row, column, char_matrix).valid
            end
        end
     end
     raise UnexpectedTokenError.new(row,column,"Key value pair is in wrong format")
    end
end