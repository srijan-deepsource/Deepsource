class UnexpectedTokenError < StandardError
  attr_reader :i, :j
  def initialize(i,j,msg="Unexpected Token")
    @i = i
    @j = j
    super(msg)
  end
end
