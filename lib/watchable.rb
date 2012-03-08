module Watchable
  def watchers
    @watchers ||= Hash.new { |h, k| h[k] = [] }
  end

  def fire event, *args
    watchers[event].each { |w| w && w.call(*args) }
    watchers[:all].each { |w| w && w.call(event, *args) }

    self
  end

  def on event, callable = Proc.new
    watchers[event] << callable

    self
  end

  def once event, callable = Proc.new
    wrapper = lambda do |*args|
      off event, wrapper
      callable.call *args
    end

    on event, wrapper
  end

  def off event, callable = nil, &block
    watcher = callable || block
    watcher ? watchers[event].delete(watcher) : watchers[event].clear

    self
  end
end
