module Constants
	SKIP_CHARS = [" ", "\n", "\t", "\s"]
	VALIDATOR_CLASS_RULE = {
  	"/" => "CommentValidator",
  	"\"" => "KeyValueValidator",
  	"{" => "HashValidator"
  	}
end	
