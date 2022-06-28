require 'minitest/autorun'

class Solution
  def initialize(dict)
    @dict = dict
    @backtrack = {}
    @words = []
    @index = 0
  end

  def call(string)
    i = 1
    loop do
      if @index + i > string.length
        return true if i == 1

        word = @words.pop
        @backtrack[word] = @words.length
        @index = @index - word.length
        return false if @index == 0 # back at the beginnng no further backtrack makes sense
        i = 1
      end
      word = string[@index...@index+i]
      if @dict.key?(word) && !backtracked?(word)
        @words << word
        @index = @index + i
        i = 1
        next
      end
      i += 1
    end
  end

  private

  def backtracked?(word)
    return false if @backtrack.length == 0
    @backtrack[word] == @words.length
  end
end

describe Solution do
  {
    "without backtracking" => {
      focus: true,
      given: "iamawesome",
      want: true
    },
    "with simple backtracking" => {
      focus: true,
      given: "iamawesomebananaamawesome",
      want: true
    },
    "with backtracked words" => {
      focus: true,
      given: "iamawesomebananaamawesomeban",
      want: true,
    },
    "simple failure" => {
      focus: true,
      given: "ina",
      want: false,
    },
    "not in dict" => {
      focus: true,
      given: "iamawesomebananaamawesomebanx",
      want: false,
    },
  }.each do |name, test|
    it name do
      skip unless test[:focus]
      dict = {"i" => true, "am" => true, "awesome" => true, "ban" => true, "banana" => true}
      solution = Solution.new(dict)
      assert_equal test[:want], solution.(test[:given])
    end
  end
end
