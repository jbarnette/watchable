# Watchable

A simple event/notification mixin, reluctantly extracted to a gem.
This is code I've had floating around for a few years now, but I've
also incorporated a few extras from node.js' [EventEmitter][ee],
[jQuery][jq], and [Backbone.Events][be].

[ee]: http://nodejs.org/api/events.html#events_class_events_eventemitter
[jq]: http://api.jquery.com/on
[be]: http://documentcloud.github.com/backbone/#Events

## Examples

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

Want to see every event fired by an object? Register for `:all`. The
first argument will be the name of the fired event.

```ruby
frob = Frob.new

frob.on :all do |event, culprit|
  p :fired => [event, culprit]
end

frob.fire :foo, "John"
```

#### Result

    {:fired => [:foo, "John"]}

### Watching Every Instance of a Class

To see all events fired by instances of a class, register for events
on the class constant. The first argument will be the name of the
event, and the second the instance that fired it.

```ruby
Frob.on :foo do |event, instance, culprit|
  p :fired => [event, instance, culprit]
end

frob = Frob.new
frob.fire :foo, "John"
```

#### Result

    {:fired => [:foo, #<Frob:0x007f9828e9e608>, "John"]}

### Watching Once

Only want to be notified the first time something happens? `once` is
like `on`, but fickle.

```ruby
frob = Frob.new

frob.once :twiddle do
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
