[![Build Status](https://secure.travis-ci.org/jbarnette/watchable.png)](http://travis-ci.org/jbarnette/watchable)

# Watchable

A simple event/notification mixin, reluctantly extracted to a gem.
This is code I've had floating around for a few years now, but I've
also incorporated a few extras from node.js' [EventEmitter][ee],
[jQuery][jq], and [Backbone.Events][be].

[ee]: http://nodejs.org/api/events.html#events_class_events_eventemitter
[jq]: http://api.jquery.com/on
[be]: http://documentcloud.github.com/backbone/#Events

## Example

### Fixtures

```ruby
require "watchable"

class Frob
  include Watchable
end

class Callable
  def call *args
    p :called! => args
  end
end

```

### Watching and Firing

Events can have any number of watchers. Each watcher will be called
in order, and any args provided when the event is fired will be passed
along. Watchers will most commonly be blocks, but any object that
responds to `call` can be used instead.

```ruby
frob = Frob.new

frob.on :twiddle do |name|
  puts "#{name} twiddled the frob!"
end

frob.on :twiddle do |name|
  puts "(not that there's anything wrong with that)"
end

frob.on :twiddle, Callable.new
frob.fire :twiddle, "John"
```

#### Result

    John twiddled the frob!
    (not that there's anything wrong with that)
    { :called! => ["John"] }

### Watching Everything

Want to see every event? Register for `:all`. The first argument will
be the name of the fired event.

```ruby
frob = Frob.new

frob.on :all do |event, culprit|
  p :fired => [event, culprit]
end

frob.fire :foo, "John"
```

#### Result

    {:fired => [:foo, "John"]}

### Watching Once

Only want to be notified the first time something happens? `once` is
like `on`, but fickle.

```ruby
frob = Frob.new

frob.on :twiddle do
  p :twiddled!
end

frob.fire :twiddle
frob.fire :twiddle
```

#### Result

    :twiddled!

### Unwatching

Specific blocks or callable objects can be removed from an event's
watchers, or all the event's watchers can be removed.

```ruby
b    = lambda {}
frob = Frob.new

frob.on :twiddle, &b

frob.off :twiddle, b  # removes the 'b' watcher, same as frob.off :twiddle, &b
frob.off :twiddle     # removes all watchers for the 'twiddle' event
```

## Compatibility

Watchable is actively developed against MRI Ruby 1.8.7 as a least common
denominator, but is widely tested against other Ruby versions and
implementations. Check the [travis-ci][] page for details.

[travis-ci]: http://travis-ci.org/jbarnette/watchable

## License (MIT)

Copyright 2012 John Barnette (john@jbarnette.com)

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
