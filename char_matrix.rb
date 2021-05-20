class CharMatrix
  def initialize
    @anon_file = File.join(File.dirname(__FILE__), 'anon.txt')  # => "/Users/rajeevvishnu/Desktop/Deepsource/anon.txt"
    @char_matrix = []                                           # => []
  end                                                           # => :initialize

  def char_matrix
    File.open(@anon_file, 'r+').each_line do |line|  # => #<File:/Users/rajeevvishnu/Desktop/Deepsource/anon.txt>
    row_matrix = []                                  # => [],    [],                   [],                     []
      line.each_char do |char|                       # => "{\n", "\t// I'm ignored\n", "\"KEY\": \"VALUE\"\n", "}"
          row_matrix << char                         # => ["{"], ["{", "\n"], ["\t"], ["\t", "/"], ["\t", "/", "/"], ["\t", "/", "/", " "], ["\t", "/", "/", " ", "I"], ["\t", "/", "/", " ", "I", "'"], ["\t", "/", "/", " ", "I", "'", "m"], ["\t", "/", "/", " ", "I", "'", "m", " "], ["\t", "/", "/", " ", "I", "'", "m", " ", "i"], ["\t", "/", "/", " ", "I", "'", "m", " ", "i", "g"], ["\t", "/", "/", " ", "I", "'", "m", " ", "i", "g", "n"], ["\t", "/", "/", " ", "I", "'", "m", " ", "i", "g", "n",...
      end                                            # => "{\n",         "\t// I'm ignored\n",                                                                              "\"KEY\": \"VALUE\"\n",                                                                                                                                                              "}"
      @char_matrix <<  row_matrix                    # => [["{", "\n"]], [["{", "\n"], ["\t", "/", "/", " ", "I", "'", "m", " ", "i", "g", "n", "o", "r", "e", "d", "\n"]], [["{", "\n"], ["\t", "/", "/", " ", "I", "'", "m", " ", "i", "g", "n", "o", "r", "e", "d", "\n"], ["\"", "K", "E", "Y", "\"", ":", " ", "\"", "V", "A", "L", "U", "E", "\"", "\n"]], [["{", "\n"], ["\t", "/", "/", " ", "I", "'", "m", " ", "i", "g", "n", "o", "r", "e", "d", "\n"], ["\"", "K", "E", "Y", "\"", ":", " ", "\"", "V...
    end                                              # => #<File:/Users/rajeevvishnu/Desktop/Deepsource/anon.txt>
    p @char_matrix                                   # => [["{", "\n"], ["\t", "/", "/", " ", "I", "'", "m", " ", "i", "g", "n", "o", "r", "e", "d", "\n"], ["\"", "K", "E", "Y", "\"", ":", " ", "\"", "V", "A", "L", "U", "E", "\"", "\n"], ["}"]]
  end                                                # => :char_matrix
end                                                  # => :char_matrix

CharMatrix.new.char_matrix  # => [["{", "\n"], ["\t", "/", "/", " ", "I", "'", "m", " ", "i", "g", "n", "o", "r", "e", "d", "\n"], ["\"", "K", "E", "Y", "\"", ":", " ", "\"", "V", "A", "L", "U", "E", "\"", "\n"], ["}"]]

# >> [["{", "\n"], ["\t", "/", "/", " ", "I", "'", "m", " ", "i", "g", "n", "o", "r", "e", "d", "\n"], ["\"", "K", "E", "Y", "\"", ":", " ", "\"", "V", "A", "L", "U", "E", "\"", "\n"], ["}"]]