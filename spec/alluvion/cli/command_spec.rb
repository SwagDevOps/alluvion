# frozen_string_literal: true

# class methods -----------------------------------------------------
describe Alluvion::Cli::Command, :'alluvion/cli/command' do
  it { expect(described_class).to respond_to(:new).with(0).arguments }

  [0, 1, 2].each do |n|
    it { expect(described_class).to respond_to(:start).with(n).arguments }
  end
end
