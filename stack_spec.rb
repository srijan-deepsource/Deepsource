require_relative("stack")
require 'minitest/autorun'

  describe Stack do
    describe 'initialization' do
      it 'is empty by default' do
        Stack.new.must_be_empty
      end

      it 'has default max_size of 1000' do
        Stack.new.max_size.must_equal 1000
      end

      it 'allows setting max_size manually' do
        [10, 100, 123, 4562, 42].each do |size|
          Stack.new(max_size: size).max_size.must_equal size
        end
      end

      it 'is still empty when created with custom size' do
        Stack.new(max_size: 3456).must_be_empty
      end

      it 'allows setting initial content' do
        stack = Stack.new(initial_content: [1, 2, 3])
        stack.pop.must_equal 3
        stack.pop.must_equal 2
        stack.pop.must_equal 1
      end

      it 'raises Stack::OverflowError when too much elements given' do
        -> { Stack.new(max_size: 3, initial_content: [1, 2, 3, 4]) }
          .must_raise Stack::OverflowError
      end
    end

    describe '#push' do
      it 'adds element on the top of the stack' do
        stack = Stack.new
        stack.push 1
        stack.peek.must_equal 1
      end

      it 'raises Stack::OverflowError when reaches max stack size' do
        stack = Stack.new(max_size: 5)
        -> { 6.times { |i| stack.push i} }
          .must_raise Stack::OverflowError
      end
    end

    describe '#pop' do
      it 'removes element from the top of the stack' do
        stack = Stack.new
        stack.push :a
        stack.push :b
        stack.size.must_equal 2
        stack.pop
        stack.size.must_equal 1
        stack.pop
        stack.size.must_equal 0
      end

      it 'returns removed element' do
        stack = Stack.new
        stack.push 1
        stack.push 2
        stack.pop.must_equal 2
        stack.pop.must_equal 1
      end

      it 'raises Stack::UnderflowError when applied to empty stack' do
        -> { Stack.new.pop }.must_raise Stack::UnderflowError
      end
    end

    describe '#peek' do
      it 'returns element on the top of the stack' do
        Stack.new(initial_content: [1, 2, 3]).peek.must_equal 3
      end

      it 'does not modify the stack' do
        stack = Stack.new
        stack.push 0
        stack.peek.must_equal 0
        stack.push 1
        stack.peek.must_equal 1
        stack.pop
        stack.peek.must_equal 0
      end

      it 'raises Stack::UnderflowError when applied to empty stack' do
        -> { Stack.new.peek }.must_raise Stack::UnderflowError
      end
    end
  end