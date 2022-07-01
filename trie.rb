require 'minitest/autorun'

class Trie
  END_OF_WORD = :eow

  def initialize
    @index = {}
  end

  def add(word)
    h = @index
    chars = word.split('')
    chars.each do |char|
      h = if h.key?(char)
        h[char]
      else
        h[char] = {}
        h[char]
      end
    end
    h[END_OF_WORD] = nil
  end

  def lookup(word)
    h = @index
    chars = word.split('')
    chars.each do |char|
      h = h[char]
      return false if h.nil?
    end
    h.key?(END_OF_WORD)
  end

  def autocomplete(word, max_results: 5)
    h = @index
    chars = word.split('')
    chars.each do |char|
      h = h[char]
      return [] if h.nil?
    end
    results = []
    completions = {word => h}
    while completions.any?
      updated_completions = {}
      completions.each do |prefix, index|
        index.each do |char, index|
          if char == END_OF_WORD
            results << prefix
            max_results -= 1
            return results if max_results == 0
            next
          end
          updated_completions[prefix + char] = index
        end
        completions = updated_completions
      end
    end
    results
  end
end

describe Trie do
  dict = ['test', 'test', 'test', 'testing', 'a', 'atom', 'else', 'aa', 'ana', 'anas', 'anananas', 'ab']
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
    'a' => ["a", "aa", "ab", "ana", "atom"],
    '' => ["a", "aa", "ab", "ana", "test"],
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
