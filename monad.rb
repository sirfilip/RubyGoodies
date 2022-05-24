module Monad
  class MonadicError < StandardError; end

  Option = Struct.new(:value) do
    def maybe(&block)
      if value.nil?
        Option.new(nil)
      else
        block.call(value).tap do |res|
          raise MonadicError.new("want Option got: #{res}") unless res.is_a?(Option)
        end
      end
    end

    def to_s
      if value
        "Some(#{value})"
      else
        "None"
      end
    end
  end

  def Some(val)
    Option.new(val)
  end

  None = Option.new(nil)

  Result = Struct.new(:value, :error) do
    def then(&block)
      if error 
        Result.new(nil, error)
      else
        block.call(value).tap do |res|
          raise MonadicError.new("want Result got: #{res}") unless res.is_a?(Result)
        end
      end
    end

    def else(&block)
      if error
        block.call(error)
      end
    end

    def to_s
      if error 
        "Failure(#{error})"
      else
        "Ok(#{value})"
      end
    end
  end

  def Failure(error)
    Result.new(nil, error)
  end

  def Ok(value)
    Result.new(value, nil)
  end
end


if __FILE__ == $0
  require 'minitest/autorun'

  include Monad

  describe Option do
    it 'allows chaning with nil value' do
      v = None.maybe do |val|
        Some(val)
      end.maybe do |val|
        Some(val)
      end.maybe do |val|
        Some(val)
      end.value
      assert v.nil?
    end

    it 'returns the correct value' do
      v = Some(5).maybe do |val|
        Some(val + 5)
      end.maybe do |val|
        Some(val + 5)
      end.maybe do |val|
        Some(val + 5)
      end.value
      assert_equal 20, v
    end

    it 'makes sure that maybe returns an Option' do
      begin
        Some(5).maybe do |val|
          42
        end
      rescue MonadicError => e
        assert_equal "want Option got: 42", e.message
      else
        fail
      end
    end

    it 'returns the correct string representation' do
      assert_equal 'None', None.to_s
      assert_equal 'Some(5)', Some(5).to_s
    end
  end

  describe Result do
    it 'returns the first error' do
      r = Ok(1).then do |val|
        Failure('error')
      end.then do |val|
        Ok(val + 1)
      end
      assert_equal r.error, 'error'
      assert_nil r.value
    end

    it 'provides else' do
      r = Ok(1).then do |val|
        Failure('error')
      end.then do |val|
        Ok(val + 1)
      end.else do |err|
        assert_equal err, 'error'
        return
      end
      fail
    end

    it 'returns the correct result' do
      r = Ok(1).then do |val|
        Ok(val + 1)
      end.then do |val|
        Ok(val + 1)
      end
      assert_nil r.error
      assert_equal r.value, 3
    end

    it 'makes sure that then returns a Result' do
      begin
        Ok(5).then do |val|
          42
        end
      rescue MonadicError => e
        assert_equal "want Result got: 42", e.message
      else
        fail
      end
    end
  end
end
