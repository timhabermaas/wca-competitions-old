require "spec_helper"

class Foo < WCA::Base
end

describe WCA::Base do
  describe "caching", :caching => true do
    before :each do
      Rails.cache.clear
    end

    it "doesn't make two HTTP requests for Foo.find" do
      Foo.should_receive(:find_without_cache).with(1).and_return Foo.new(:id => 1, :name => "bar")
      Foo.find(1)

      Foo.should_not_receive(:find_without_cache)
      Foo.find(1).name.should == "bar"
    end

    it "doesn't make an HTTP request if the first response was nil" do
      Foo.should_receive(:find_without_cache).with(1).and_return nil
      Foo.find(1)

      Foo.should_not_receive(:find_without_cache)
      Foo.find(1).should == nil
    end
  end
end
