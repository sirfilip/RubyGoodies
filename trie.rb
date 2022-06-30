require 'minitest/autorun'

class Trie
  attr_reader :value

  def initialize(value = nil)
    @value = value
    @tries = {}
  end

  def add(word)
    if word == ''
      @tries[:stop] = nil
      return
    end
    chars = word.split('')
    char = chars.shift
    trie = if @tries.key?(char)
        @tries[char]
      else
        @tries[char] = self.class.new(char)
        @tries[char]
      end
    trie.add(chars.join(''))
  end

  def lookup(word)
    return @tries.key?(:stop) if word == ''

    chars = word.split('')
    char = chars.shift
    if @tries.key?(char)
      @tries[char].lookup(chars.join(''))
    else
      false
    end
  end

  def autocomplete(word, max_results: 5)
    suggestions = []
    return suggestions if max_results == 0

    chars = word.split('')
    char = chars.shift
    if word != ''
      return suggestions unless @tries[char]
      @tries[char].autocomplete(chars.join(''), max_results: max_results).each do |completion|
        suggestions << completion
        return suggestions if suggestions.length == max_results
      end
    else
      @tries.each do |char, trie|
        if char == :stop
          suggestions << value
          max_results -= 1
        else
          trie.autocomplete('', max_results: max_results).each do |completion|
            next if value.nil?
            suggestions << value + completion
          end
        end
      end
    end
    suggestions
  end
end

describe Trie do
  dict = ['test', 'testing', 'a', 'atom', 'else', 'aa', 'ana', 'anas', 'anananas']
  {
    'test' => true,
    'testing' => true,
    'a' => true,
    'aa' => true,
    'atom' => true,
    'else' => true,
    '' => false,
    'bogus' => false,
  }.each do |word, want|
    it "performs lookup for word: #{word}" do
      trie = Trie.new
      dict.each do |term|
        trie.add(term)
      end
      assert_equal want, trie.lookup(word)
    end
  end

  {
    't' => ['test', 'testing'],
    'a' => ['a', 'atom', 'aa', 'ana', 'anas'],
    '' => [],
    'bogus' => [],
  }.each do |term, want|
    it "autocompletes #{term}" do
      trie = Trie.new
      dict.each do |word|
        trie.add(word)
      end
      assert_equal want, trie.autocomplete(term)
    end
  end
end
