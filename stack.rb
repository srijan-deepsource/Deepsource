require 'forwardable'

class Stack
  OverflowError  = Class.new StandardError
  UnderflowError = Class.new StandardError

  extend Forwardable

  def_delegators :@ary, :empty?, :size

  attr_reader :max_size

  def initialize(opts={})
    opts = {max_size: 1000, initial_content: []}.merge(opts)
    @ary = []
    @max_size = opts[:max_size]
    opts[:initial_content].each do |elem|
      push elem
    end
  end

  def push(item)
    fail OverflowError if size >= max_size
    @ary.push item
  end

  def pop
    fail UnderflowError if empty?
    @ary.pop
  end

  def peek
    fail UnderflowError if empty?
    @ary.last
  end
end