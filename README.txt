= OrderedSet

OrderSet is an class for storing sets of objects. Unlike a Set, it maintains the order of
the objects, but unlike an Array, each object can only exist once, and checking for
inclusion takes constant time.

== INSTALL:

  sudo gem install ordered_set

== USAGE:

  s = [1,3,2,3,4,3].to_ordered_set
  s.to_a
  # => [1,3,2,4]

  t = OrderedSet.new([6,7,5,6,5])
  t.to_a
  # => [6,7,5]

  (s + t).to_a
  # => [1,3,2,4,6,7,5]

  s << 5
  s.to_a
  # => [1,3,2,4,5]

  s.delete(1)
  s.to_a
  # => [3,2,4,5]

== REQUIREMENTS:

 * deep_clonable

== LICENSE:

(The MIT License)

Copyright (c) 2008 FIX

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
