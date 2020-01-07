# frozen_string_literal: true

# class methods -----------------------------------------------------
describe Alluvion::ConfigFile, :'alluvion/config_file' do
  [0, 1].each do |n|
    it { expect(described_class).to respond_to(:new).with(n).arguments }
  end

  it { expect(described_class).to respond_to(:file).with(0).arguments }
  context '.file' do
    it { expect(described_class.file).to be_a(Pathname) }
  end
end

# instance methods --------------------------------------------------
describe Alluvion::ConfigFile, :'alluvion/config_file' do
  it { expect(subject).to respond_to(:parse).with(0).arguments }
end

describe Alluvion::ConfigFile, :'alluvion/config_file' do
  let(:file) { sham!(:samples).configs.fetch('complete').file }
  subject { described_class.new(file) }

  context '#parse' do
    it { expect(subject.parse).to be_a(Hash) }
  end
end
