# frozen_string_literal: true

# class methods -----------------------------------------------------
describe Alluvion::Template, :'alluvion/template' do
  it { expect(described_class).to respond_to(:new).with(1).arguments }
end

# instance methods --------------------------------------------------
describe Alluvion::Template, :'alluvion/template' do
  subject { described_class.new('str') }

  it { expect(subject.method(:call).original_name).to eq(:render) }

  [0, 1].each do |n|
    it { expect(subject).to respond_to(:call).with(n).arguments }
  end
end
