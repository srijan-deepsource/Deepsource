class BooleanValidator
  attr_accessor :i, :j, :char_matrix
  def initialize(i,j,char_matrix)
    @i = i
    @j = j
    @char_matrix = char_matrix
  end
    
    def valid
      if char_matrix[i][j] == "t"
        return next_char(i,j+3) if char_matrix[i][j..j+3].join == "true"
      elsif char_matrix[i][j] == "f"
        return next_char(i,j+4) if char_matrix[i][j..j+4].join == "false"
      end
      raise UnexpectedTokenError.new(i,j,"Boolean is invalid")
    end

    def next_char(i,column)
       if char_matrix[i][column+1]
          return i, column+1
      elsif char_matrix[i+1] && char_matrix[i+1][0]
          return i+1, 0
      else
        raise UnexpectedTokenError.new(i,column,"ANON cannot end with a boolean")
      end
    end
 end