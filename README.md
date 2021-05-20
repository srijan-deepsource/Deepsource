Instructions:
1) Paste your ANON in anon.txt
2) Run anon_validator.rb

Validation Logic Used:
1) Followed the methodology used in https://www.json.org/json-en.html for a json object.
2) Break ANON into individual objects like comment, key, value, array, hash and compile the result upto the main ANON.
3) If each of the smaller components are valid in itself, then the main ANON is considered valid
4) Used stack to check the validity of each component.
