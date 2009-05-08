require File.dirname(__FILE__) + '/test_helper'

class OrderedSetTest < Test::Unit::TestCase
  
  should 'create an ordered_set' do
    assert [1,3,2,3,1,:foo].to_ordered_set.is_a?(OrderedSet)
    assert OrderedSet.new([1,3,2,3,1,:foo]).is_a?(OrderedSet)
  end
  
  should 'be enumerable' do
    assert_equal [nil,1], [nil,1,1,nil].to_ordered_set.collect {|i| i}
    assert_equal [1,3,2,:foo], [1,3,2,3,1,:foo].to_ordered_set.collect {|i| i}
    assert_equal [-1,-3,-12], [1,3,12,3,1].to_ordered_set.collect {|i| -i}
    assert_equal [1], [1,1,0,1,0,0,0,1].to_ordered_set.select {|i| i != 0}
  end
  
  should 'replace the set contents' do
    set = [].to_ordered_set
    set.replace([5,0,5])
    
    assert_equal [5,0], set.to_a
    assert_consistent set  
  end
  
  should 'join elements in set' do
    set = ["five","O","five"].to_ordered_set
    assert_equal 'five-O', set.join('-')
    set << 5
    assert_equal 'five-O-5', set.join('-')
    assert_consistent set
  end
  
  should 'add sets' do
    set = [1,3,4].to_ordered_set + [2,3,5].to_ordered_set
    
    assert_equal [1,3,4,2,5], set.to_a
    assert_consistent set
  end

  should 'subtract sets' do
    set = [5,1,3,4].to_ordered_set - [2,3,5].to_ordered_set
    
    assert_equal [1,4], set.to_a
    assert_consistent set
  end

  should 'intersect sets' do
    set = [5,1,3,4].to_ordered_set & [2,3,5].to_ordered_set
    
    assert_equal [5,3], set.to_a
    assert_consistent set
  end

  should 'reorder set' do
    set = [5,1,3,4].to_ordered_set
    set.reorder!([2,3,5].to_ordered_set)
    
    assert_equal [3,5,1,4], set.to_a
    assert_consistent set
  end

  should 'clear set' do
    set  = [1,2,3].to_ordered_set
    
    set.clear
    assert set.empty?
  end

  should 'clone set' do
    set  = [1,2,3].to_ordered_set
    copy = set.clone
    
    copy.clear
    assert_equal [],      copy.to_a
    assert_equal [1,2,3], set.to_a
  end
  
  should 'include? all elements' do
    set = [1,3,2,3,1,:foo,nil].to_ordered_set
    
    assert set.include?(1)
    assert set.include?(3)
    assert set.include?(:foo)
    assert set.include?(nil)
    assert_consistent set
  end
  
  should 'have the correct size and length' do
    set = [1,1,1,1,2,2,1,2,3,4,2,1,0].to_ordered_set
    assert_equal 5, set.size
    assert_equal 5, set.length
    assert_consistent set
  end
  
  should 'be empty' do
    set = [].to_ordered_set
    assert set.empty?

    set = [1].to_ordered_set
    assert !set.empty?
  end

  should 'check for any elements' do
    set = [].to_ordered_set
    assert !set.any?

    set = [1].to_ordered_set
    assert set.any?
  end
  
  should 'support index operator' do
    set = [1,2,2,3,4,1,0].to_ordered_set
    
    assert_equal 1, set[0]
    assert_equal 4, set[3]
    assert_equal nil, set[100]
    assert_equal [2,3], set[1,2]
    assert_equal [3,4,0], set[2..4]
    assert_consistent set
  end

  should 'get a slice from a set' do
    set = [1,2,2,3,4,1,0].to_ordered_set
    
    assert_equal 1, set.slice(0)
    assert_equal 4, set.slice(3)
    assert_equal nil, set.slice(100)
    assert_equal [2,3], set.slice(1,2)
    assert_equal [3,4,0], set.slice(2..4)
    assert_consistent set
  end

  should 'lookup index of element' do
    set = [1,2,2,3,4,1,0].to_ordered_set

    assert_equal 1, set.index(2)
    assert_equal 4, set.index(0)
    assert_consistent set
  end
  
  should 'append elements' do
    set = [1,2,2,3,4,1,0].to_ordered_set
    
    set << 1
    assert_equal 5, set.size
    assert set.include?(1)
    assert_equal [1,2,3,4,0], set.to_a
    assert_consistent set
    
    set << 100
    assert_equal 6, set.size
    assert set.include?(100)
    assert_equal [1,2,3,4,0,100], set.to_a
    assert_consistent set
  end

  should 'unshift elements' do
    set = [1,2,2,3,4,1,0].to_ordered_set
    
    set.unshift(1)
    assert_equal 5, set.size
    assert set.include?(1)
    assert_equal [1,2,3,4,0], set.to_a
    assert_consistent set
    
    set.unshift(100)
    assert_equal 6, set.size
    assert set.include?(100)
    assert_equal [100,1,2,3,4,0], set.to_a
    assert_consistent set
  end

  
  should 'delete elements' do
    set = [1,2,2,3,4,1,nil].to_ordered_set
    
    assert_equal 1, set.delete(1)
    assert_equal [2,3,4,nil], set.to_a
    assert_equal 4, set.size
    assert !set.include?(1)
    assert_consistent set

    assert_equal nil, set.delete(nil)
    assert_equal [2,3,4], set.to_a
    assert_equal 3, set.size
    assert !set.include?(nil)
    assert_consistent set
    
    assert_equal false, set.delete(100) { false }
    assert_equal [2,3,4], set.to_a
    assert_equal 3, set.size
    assert !set.include?(100)
    assert_consistent set
  end
  
  should 'delete elements at specified position'  do
    set = [1,2,2,3,4,1,nil].to_ordered_set
    
    assert_equal 1, set.delete_at(0)
    assert_equal [2,3,4,nil], set.to_a
    assert_equal 4, set.size
    assert !set.include?(1)
    assert_consistent set

    assert_equal nil, set.delete_at(3)
    assert_equal [2,3,4], set.to_a
    assert_equal 3, set.size
    assert !set.include?(nil)
    assert_consistent set
    
    assert_equal false, set.delete(100) { false }
    assert_equal [2,3,4], set.to_a
    assert_equal 3, set.size
    assert !set.include?(100)
    assert_consistent set
  end
  
  should 'sort set' do
    set = [1,2,2,3,4,1,0].to_ordered_set
    
    set.sort!
    assert_equal [0,1,2,3,4], set.to_a
    assert_consistent set
  end
  
  should 'reverse set' do
    set = [0,1,2,2,3,4,1,0].to_ordered_set
    
    set.reverse!
    assert_equal [4,3,2,1,0], set.to_a
    assert_consistent set
  end
  
  should 'modify using collect!' do
    set = [0,1,2,2,3,4,1,0,5,6,8,9,11,32424].to_ordered_set
    
    set.collect! {|i| i % 3}
    assert_equal [0,1,2], set.to_a
    assert_consistent set
  end
  
  should 'modify using map!' do
    set = [0,1,2,2,3,4,1,0].to_ordered_set
    
    set.collect! {|i| i * 10}
    assert_equal [0,10,20,30,40], set.to_a
    assert_consistent set
  end

  should 'compact set' do
    set = [0,1,2,2,nil,3,nil,4,1,0].to_ordered_set
    
    set.compact!
    assert_equal [0,1,2,3,4], set.to_a
    assert_consistent set
  end
  
  should 'select elements from set' do
    set = [0,1,2,2,3,4,1,0].to_ordered_set
    
    set.select! {|i| i % 2 == 0}
    assert_equal [0,2,4], set.to_a
    assert_consistent set
  end

  should 'reject elements from set' do
    set = [0,1,2,2,3,4,1,0].to_ordered_set
    
    set.reject! {|i| i % 2 == 0}
    assert_equal [1,3], set.to_a
    assert_consistent set
  end

  should 'modify set with slice!' do
    set = [0,1,2,2,3,4,1,0].to_ordered_set
    
    assert_equal [1,2,3], set.slice!(1..3)
    assert_equal [0,4], set.to_a
    assert_consistent set
  end

  should 'limit set' do
    set = [0,1,2,2,3,4,1,0].to_ordered_set.limit!(3, 1)
    
    assert_equal [1,2,3], set.to_a
    assert_consistent set

    set = [0,1,2,2,3,4,1,0].to_ordered_set.limit!(2)
    
    assert_equal [0,1], set.to_a
    assert_consistent set
  end
  
  def assert_consistent(set)
    set.each do |item|
      assert set.include?(item)
    end
  end
    
end
