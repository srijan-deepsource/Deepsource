require_relative "hash_validator.rb"                                # => true
SKIP = [" ", "\n", "\t", "\s"]                                      # => [" ", "\n", "\t", " "]
char_matrix = []                                                    # => []
f = File.open(File.join(File.dirname(__FILE__), 'anon.txt'), 'r+')  # => #<File:/Users/rajeevvishnu/Desktop/Deepsource/anon.txt>
f.each_line do |line|                                               # => #<File:/Users/rajeevvishnu/Desktop/Deepsource/anon.txt>
row_matrix = []                                                     # => [],    [],                 [],                     []
line.each_char do |char|                                            # => "{\n", "// I'm ignored\n", "\"KEY\": \"VALUE\"\n", "}\n"
    row_matrix << char                                              # => ["{"], ["{", "\n"], ["/"], ["/", "/"], ["/", "/", " "], ["/", "/", " ", "I"], ["/", "/", " ", "I", "'"], ["/", "/", " ", "I", "'", "m"], ["/", "/", " ", "I", "'", "m", " "], ["/", "/", " ", "I", "'", "m", " ", "i"], ["/", "/", " ", "I", "'", "m", " ", "i", "g"], ["/", "/", " ", "I", "'", "m", " ", "i", "g", "n"], ["/", "/", " ", "I", "'", "m", " ", "i", "g", "n", "o"], ["/", "/", " ", "I", "'", "m", " ", "i", "g", "n", "...
end                                                                 # => "{\n",         "// I'm ignored\n",                                                                          "\"KEY\": \"VALUE\"\n",                                                                                                                                                        "}\n"
  char_matrix <<  row_matrix                                        # => [["{", "\n"]], [["{", "\n"], ["/", "/", " ", "I", "'", "m", " ", "i", "g", "n", "o", "r", "e", "d", "\n"]], [["{", "\n"], ["/", "/", " ", "I", "'", "m", " ", "i", "g", "n", "o", "r", "e", "d", "\n"], ["\"", "K", "E", "Y", "\"", ":", " ", "\"", "V", "A", "L", "U", "E", "\"", "\n"]], [["{", "\n"], ["/", "/", " ", "I", "'", "m", " ", "i", "g", "n", "o", "r", "e", "d", "\n"], ["\"", "K", "E", "Y", "\"", ":", " ", "\"", "V", ...
end                                                                 # => #<File:/Users/rajeevvishnu/Desktop/Deepsource/anon.txt>

p char_matrix  # => [["{", "\n"], ["/", "/", " ", "I", "'", "m", " ", "i", "g", "n", "o", "r", "e", "d", "\n"], ["\"", "K", "E", "Y", "\"", ":", " ", "\"", "V", "A", "L", "U", "E", "\"", "\n"], ["}", "\n"]]

for i in 0..(char_matrix.size-1)                                       # => 0..3
    for j in 0..(char_matrix[i].size-1)                                # => 0..1
        char = char_matrix[i][j]                                       # => "{"
        next if SKIP.include?(char)                                    # => false
        char                                                           # => "{"
        if char == "{"                                                 # => true
            char_matrix                                                # => [["{", "\n"], ["/", "/", " ", "I", "'", "m", " ", "i", "g", "n", "o", "r", "e", "d", "\n"], ["\"", "K", "E", "Y", "\"", ":", " ", "\"", "V", "A", "L", "U", "E", "\"", "\n"], ["}", "\n"]]
            next_i, next_j = HashValidator.new(i,j,char_matrix).valid  # ~> ArgumentError: comparison of Integer with nil failed
        # else
        #   raise "ANON should start with {"                          # ~> RuntimeError: ANON should start with {
        end
    end
end

# >> [["{", "\n"], ["/", "/", " ", "I", "'", "m", " ", "i", "g", "n", "o", "r", "e", "d", "\n"], ["\"", "K", "E", "Y", "\"", ":", " ", "\"", "V", "A", "L", "U", "E", "\"", "\n"], ["}", "\n"]]

# ~> ArgumentError
# ~> comparison of Integer with nil failed
# ~>
# ~> /Users/rajeevvishnu/Desktop/Deepsource/hash_validator.rb:42:in `<'
# ~> /Users/rajeevvishnu/Desktop/Deepsource/hash_validator.rb:42:in `block (2 levels) in valid'
# ~> /Users/rajeevvishnu/Desktop/Deepsource/hash_validator.rb:38:in `each'
# ~> /Users/rajeevvishnu/Desktop/Deepsource/hash_validator.rb:38:in `block in valid'
# ~> /Users/rajeevvishnu/Desktop/Deepsource/hash_validator.rb:34:in `each'
# ~> /Users/rajeevvishnu/Desktop/Deepsource/hash_validator.rb:34:in `valid'
# ~> /Users/rajeevvishnu/Desktop/Deepsource/validator.rb:22:in `block (2 levels) in <main>'
# ~> /Users/rajeevvishnu/Desktop/Deepsource/validator.rb:16:in `each'
# ~> /Users/rajeevvishnu/Desktop/Deepsource/validator.rb:16:in `block in <main>'
# ~> /Users/rajeevvishnu/Desktop/Deepsource/validator.rb:15:in `each'
# ~> /Users/rajeevvishnu/Desktop/Deepsource/validator.rb:15:in `<main>'



