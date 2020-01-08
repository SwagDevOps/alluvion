# frozen_string_literal: true

# class methods -----------------------------------------------------
describe Alluvion::Cli::SynchroCommand, :'alluvion/cli/synchro_command' do
  it { expect(described_class).to respond_to(:new).with(0).arguments }

  context '.ancestors' do
    it { expect(described_class.ancestors).to include(Alluvion::Cli::Command) }
  end

  [0, 1, 2].each do |n|
    it { expect(described_class).to respond_to(:start).with(n).arguments }
  end
end

# instance methods --------------------------------------------------
describe Alluvion::Cli::SynchroCommand, :'alluvion/cli/synchro_command' do
  [:up, :down].each do |command|
    it { expect(subject).to respond_to(command).with(0).arguments }
  end
end
