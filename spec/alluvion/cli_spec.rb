# frozen_string_literal: true

autoload(:Thor, 'thor')

# constants ---------------------------------------------------------
describe Alluvion::Cli, :'alluvion/cli' do
  it { expect(described_class).to be_const_defined(:Command) }
  it { expect(described_class).to be_const_defined(:SynchroCommand) }
end

# class methods -----------------------------------------------------
describe Alluvion::Cli, :'alluvion/cli' do
  it { expect(described_class).to respond_to(:command?).with(1).arguments }
end

# instance methods --------------------------------------------------
describe Alluvion::Cli, :'alluvion/cli' do
  it { expect(subject).to respond_to(:call).with(1).arguments }
  it { expect(subject).to respond_to(:commands).with(0).arguments }
end

describe Alluvion::Cli, :'alluvion/cli' do
  context '#commands' do
    it { expect(subject.commands).to be_a(Array) }
  end
end

describe Alluvion::Cli, :'alluvion/cli' do
  # @formatter:off
  [
    [],
    %w[help synchro:up]
  ].each do |given_args| # @formatter:on
    let(:command) { subject.__send__(:command, given_args) }

    context "#command(#{given_args.inspect}).ancestors" do
      it { expect(command.ancestors).to include(Thor) }
      it { expect(command.ancestors).to include(Alluvion::Cli::Command) }
    end
  end
end
