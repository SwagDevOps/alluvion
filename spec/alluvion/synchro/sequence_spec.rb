# frozen_string_literal: true

# constants + class methods ---------------------------------------------------
describe Alluvion::Synchro::Sequence, :'alluvion/synchro/sequence' do
  it { expect(described_class).to be_const_defined(:Command) }
  it { expect(described_class).to be_const_defined(:Factory) }

  it { expect(described_class).to respond_to(:build).with(2).arguments }
end

describe Alluvion::Synchro::Sequence, :'alluvion/synchro/sequence' do
  sham!(:configs).complete.tap do |config|
    subject { described_class.build(:up, config) }
  end

  context '.build(:up, config)' do
    it { expect(subject).to be_a(Array) }
    it { expect(subject).to be_a(Alluvion::Synchro::Sequence) }
  end
end
