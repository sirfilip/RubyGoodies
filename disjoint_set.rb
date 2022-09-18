require 'json'
require 'minitest/autorun'

class DisjointSet
  def initialize(n)
    @n = n
    @sizes = {}
    @state = Array.new(n) { -1 }
  end

  def find(a)
    return nil if @state[a] == -1
    return a if @state[a] == a
    find(@state[a])
  end

  def size(a)
    @sizes[find(a)].to_i
  end

  def union(a, b)
    if find(a).nil? && find(b).nil?
      @state[a] = a
      @state[b] = a
      @sizes[a] = 2
      return
    end

    if find(a).nil?
      @state[a] = find(b)
      @sizes[find(b)] += 1
      return
    end

    if find(b).nil?
      @state[b] = find(a)
      @sizes[find(a)] += 1
      return
    end

    return if find(a) == find(b)

    if size(a) >= size(b)
      @sizes[find(a)] += @sizes[find(b)]
      @sizes.delete(find(b))
      @state[find(b)] = find(a)
      return
    end

    @sizes[find(b)] += @sizes[find(a)]
    @sizes.delete(find(a))
    @state[find(a)] = find(b)
    nil
  end

  def to_json(*args)
    {
      JSON.create_id => self.class.name,
      :n => @n,
      :state => @state.to_json,
      :sizes => @sizes.to_json
    }.to_json(*args)
  end

  def self.json_create(object)
    puts object.inspect
    ds = new(object['n'])
    ds.instance_variable_set('@state', object['state'])
    ds.instance_variable_set('@sizes', object['sizes'])
    ds
  end
end


describe DisjointSet do
  it 'finds the correct root' do
    @ds = DisjointSet.new(6)
    @ds.union(1, 2)
    @ds.union(2, 3)
    @ds.union(4, 5)
    assert_equal 1, @ds.find(1)
    assert_equal 1, @ds.find(2)
    assert_equal 1, @ds.find(3)
    assert_equal 4, @ds.find(4)
    assert_equal 4, @ds.find(5)
  end

  it 'finds the correct sizes' do
    @ds = DisjointSet.new(6)
    @ds.union(1, 2)
    @ds.union(2, 3)
    @ds.union(4, 5)
    assert_equal 3, @ds.size(1)
    assert_equal 3, @ds.size(2)
    assert_equal 2, @ds.size(4)
  end

  it 'returns nil if element does not belong to any set' do
    @ds = DisjointSet.new(6)
    assert_nil @ds.find(1)
  end

  it 'merges two sets if there is intersection' do
    @ds = DisjointSet.new(6)
    @ds.union(1, 2)
    @ds.union(2, 3)
    @ds.union(4, 5)
    @ds.union(3, 4)
    assert_equal 1, @ds.find(5)
    assert_equal 5, @ds.size(5)
  end

  it 'skips if the union is already present' do
    @ds = DisjointSet.new(6)
    @ds.union(1, 2)
    @ds.union(2, 3)
    state = @ds.to_json
    @ds.union(3, 2)
    assert_equal state, @ds.to_json
  end
end
