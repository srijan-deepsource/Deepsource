class CharMatrix
  def initialize
    @anon_file = File.join(File.dirname(__FILE__), 'anon.txt')
    @char_matrix = []
  end

  def char_matrix
    File.open(@anon_file, 'r+').each_line do |line|
    row_matrix = []
      line.each_char do |char|
          row_matrix << char
      end
      @char_matrix <<  row_matrix
    end
    @char_matrix
  end
end