require "./spec_helper"

describe Crf do
  # TODO: Write tests

  it "::Dir works" do
    dir = Crf::Dir.new(".")
    p dir
    dirs = dir.glob

    p dirs
    dirs.size.should eq(3)
  end
end
