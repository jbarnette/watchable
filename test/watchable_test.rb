require "minitest/autorun"
require "mocha/setup"
require "watchable"

describe Watchable do
  before do
    @obj = Object.new
    @obj.extend Watchable
  end

  it "has an empty list of watchers by default" do
    assert @obj.watchers.empty?
  end

  it "returns an empty array of watchers for any event" do
    assert_equal [], @obj.watchers[:foo]
  end

  describe :fire do
    it "calls each watcher with optional args" do
      @obj.on :foo, mock { expects(:call).with :bar, :baz }
      @obj.fire :foo, :bar, :baz
    end

    it "calls multiple watchers in order" do
      fires = sequence "fires"

      @obj.on :foo, mock { expects(:call).in_sequence fires }
      @obj.on :foo, mock { expects(:call).in_sequence fires }

      @obj.fire :foo
    end

    it "returns the watchable" do
      assert_same @obj, @obj.fire(:foo)
    end
  end

  describe :off do
    it "can unregister a block" do
      b = lambda {}

      @obj.on :foo, &b
      @obj.off :foo, &b

      assert @obj.watchers[:foo].empty?
    end

    it "can unregister an object" do
      b = lambda {}

      @obj.on :foo, &b
      @obj.off :foo, &b

      assert @obj.watchers[:foo].empty?
    end

    it "can unregister all watchers for an event" do
      @obj.on(:foo) {}
      @obj.on(:foo) {}

      assert_equal 2, @obj.watchers[:foo].size

      @obj.off :foo
      assert @obj.watchers[:foo].empty?
    end

    it "returns the watchable" do
      assert_same @obj, @obj.off(:foo)
    end
  end

  describe :on do
    it "can register a block" do
      b = lambda {}

      @obj.on :foo, &b
      assert_equal [b], @obj.watchers[:foo]
    end

    it "can register an object" do
      b = lambda {}

      @obj.on :foo, b
      assert_equal [b], @obj.watchers[:foo]
    end

    it "can register for all events" do
      @obj.on :all, mock { expects(:call).with :foo, :bar }
      @obj.fire :foo, :bar
    end

    it "returns the watchable" do
      assert_same @obj, @obj.on(:foo) {}
    end
  end

  describe :once do
    it "registers a watcher that's only called on the first fire" do
      @obj.once :foo, mock { expects :call }

      @obj.fire :foo
      @obj.fire :foo
    end

    it "returns the watchable" do
      assert_same @obj, @obj.once(:foo) {}
    end
  end
end
