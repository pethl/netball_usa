# spec/models/sample_word_spec.rb
require 'rails_helper'

RSpec.describe SampleWord, type: :model do
  describe "basic factory" do
    it "is valid with default attributes" do
      expect(build(:sample_word)).to be_valid
    end
  end
end

