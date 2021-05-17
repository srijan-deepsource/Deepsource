require_relative "stack.rb"
class ArrayValidator
  SKIP = [" ", "\n", "\t", "\s"]
  attr_accessor :i, :j, :char_matrix
  def initialize(i,j,char_matrix)
  	@i = i
  	@j = j
  	@char_matrix = char_matrix
  end
  	def valid
  		#TODO
	  end
 end 