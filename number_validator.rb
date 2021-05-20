require_relative "char_matrix.rb"
require "byebug"
class NumberValidator
  NUMBER_ENDING = [",", "]", "}"]
  attr_accessor :i, :j, :char_matrix
  def initialize(i,j,char_matrix)
    @i = i
    @j = j
    @char_matrix = char_matrix
  end
    
    def valid
      num = ""
      for column in j..(char_matrix[i].size-1)
        char = char_matrix[i][column]
        if NUMBER_ENDING.include?(char)
          if validate_number(num)
            return i,column
          else
            raise "Error at line #{i}: Number is invalid"
          end  
        else
          num += char
        end           
      end
      if validate_number(num)
        return next_char(i,column)
      end
        raise "Error at line #{i}: Number is invalid"
      else 
    end

    def validate_number(num)
      num.strip!
      Float(num) != nil
    rescue 
      false
    end

    def next_char(i,column)
       if char_matrix[i][column+1]
          return i, column+1
      elsif char_matrix[i+1] && char_matrix[i+1][0]
          return i+1, 0
      else
        raise "Error at line #{i}: ANON cannot end with a number"
      end
    end
 end