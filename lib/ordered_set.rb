require 'rubygems'
require 'deep_clonable'
require 'forwardable'

class OrderedSet
  VERSION = "0.9.0"

  include Enumerable
  extend  Forwardable

  deep_clonable

  def initialize(items = [])
    @order    = []
    @position = {}
    replace(items)
  end

  def_delegators :@order, :each, :join, :[], :first, :last, :slice, :size, :length, :empty?
  alias limit slice
  
  def replace(items)
    clear
    items.each do |item|
      self << item
    end
    self
  end
  
  def clear
    @order.clear
    @position.clear
  end

  def include?(item)
    @position.has_key?(item)
  end
    
  def <<(item)
    return if include?(item)
    @position[item] = @order.size
    @order << item
  end

  clone_method :+, :add!
  def add!(items)
    items.each do |item|
      self << item
    end
    self
  end
  alias concat add!

  def unshift!(items)
    need_reindex = false
    items.each do |item|
      next if include?(item)
      @order.unshift(item)
      need_reindex = true # Need to recalculate the positions.
    end
    reindex if need_reindex
    self
  end
  
  def unshift(item)
    unshift!([item])
  end

  clone_method :-, :subtract!
  def subtract!(items)
    @order.replace(self.to_a - items.to_a)
    reindex
    self
  end

  clone_method :&, :intersect!
  def intersect!(items)
    @order.replace(self.to_a & items.to_a)
    reindex
    self
  end

  def reorder!(items)
    new_order = (items.to_a & self.to_a) + self.to_a
    @order.replace(new_order.uniq)
    reindex
    self
  end

  def reverse_reorder!(items)
    return self if items.empty?
    reverse!.reorder!(items).reverse!
  end
  
  def to_ary
    @order.dup
  end
  
  def index(item)
    @position[item]
  end
  
  def delete(item)
    @order.delete(item) do
      return block_given? ? yield : nil
    end
    reindex 
    item
  end

  def delete_at(index, &block)
    delete(self[index], &block)
  end

  [:sort_by, :sort, :reverse, :collect, :map, :compact, :reject].each do |method_name|
    eval %{
      def #{method_name}!(*args, &block)
        new_order = @order.send(:#{method_name}, *args, &block)
        replace(new_order)
        self
      end
    }
  end
  
  def select!
    reject! {|item| not yield(item)}
  end

  # Array#slice! is somewhat inconsistent with the other bang methods, 
  # and this emulates that. For the more consistent behavior use limit!
  def slice!(*args)
    removed_slice = @order.slice!(*args)
    reindex
    removed_slice
  end

  clone_method :limit
  def limit!(limit, offset = 0)
    new_order = @order.slice(offset, limit) || []
    replace(new_order)
    self
  end

private

  def reindex
    @position.clear
    @order.each_with_index do |item, index|
      @position[item] = index
    end
  end
  
end

module Enumerable
  def to_ordered_set
    self.kind_of?(OrderedSet) ? self : OrderedSet.new(self)
  end
end
