class TrieNode
  attr_reader :children

  def initialize
    @children = {}
  end
end


class Trie
  def initialize
    @root = TrieNode.new
  end

  def search(word)
    !index(word).nil?
  end

  def insert(word)
    pointer = @root
    word.split('').each do |char|
      if pointer.children.key?(char)
        pointer = pointer.children.fetch(char)
      else
        newNode = TrieNode.new
        pointer.children[char] = newNode
        pointer = newNode
      end
    end
    pointer.children["*"] = nil
  end

  def autocomplete(word="", node=nil, words=[])
    pointer = node || if word == ""
      @root
    else
      index(word)
    end
    return words if pointer.nil?

    pointer.children.each do |char, node|
      if char == "*"
        words << word
      else
        autocomplete(word + char, node, words)
      end
    end
    words
  end

  private

  def index(word)
    pointer = @root

    word.split('').each do |char|
      if pointer.children.key?(char)
        pointer = pointer.children.fetch(char)
      else
        return nil
      end
    end
    return pointer
  end
end


def assert(cond)
  raise "Assertion Failure" unless cond
end

trie = Trie.new
trie.insert("cat")
trie.insert("car")
trie.insert("other")

assert trie.search("cat")
assert trie.search("car")
assert !trie.search("card")
assert trie.autocomplete("c") == ["cat", "car"]
assert trie.autocomplete == ["cat", "car", "other"]
assert trie.autocomplete("z") ==  []
