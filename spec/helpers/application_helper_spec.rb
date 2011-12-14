require 'spec_helper'

describe ApplicationHelper do
  describe "#m" do
    it "outputs headers" do
      helper.m("h1. Test").should == "<h1>Test</h1>"
    end

    it "wraps paragraphs in <p>" do
      helper.m("lorem\n\nipsum").should == "<p>lorem</p>\n<p>ipsum</p>"
    end
  end
end
