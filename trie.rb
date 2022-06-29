require 'minitest/autorun'

class Trie
  attr_reader :value

  def initialize(value = nil)
    @value = value
    @nodes = {}
  end

  def add(word)
    if word == ''
      @nodes[:stop] = nil
      return
    end
    chars = word.split('')
    char = chars.shift
    node = if @nodes.key?(char)
             @nodes[char]
           else
             @nodes[char] = self.class.new(char)
             @nodes[char]
           end
    node.add(chars.join(''))
  end

  def lookup(word)
    return @nodes.key?(:stop) if word == ''

    chars = word.split('')
    char = chars.shift
    if @nodes.key?(char)
      @nodes[char].lookup(chars.join(''))
    else
      false
    end
  end
end

describe Trie do
  dict = ['test', 'testing', 'a', 'atom', 'else' ]
  {
    'test' => true,
    'testing' => true,
    'a' => true,
    'atom' => true,
    'else' => true,
    '' => false,
    'bogus' => false,
  }.each do |word, want|
    it "performs lookup for word: #{word}"do
      trie = Trie.new
      dict.each do |term|
        trie.add(term)
      end
      assert_equal want, trie.lookup(word)
    end
  end
end
