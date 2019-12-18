# frozen_string_literal: true

# constants + class methods ---------------------------------------------------
describe Alluvion::Synchro::Sequence, :'alluvion/synchro/sequence' do
  it { expect(described_class).to be_const_defined(:Command) }
  it { expect(described_class).to be_const_defined(:Factory) }

  it { expect(described_class).to respond_to(:new).with(0).arguments }
  it { expect(described_class).to respond_to(:new).with(1).arguments }
  it { expect(described_class).to respond_to(:build).with(2).arguments }
end

# instance methods ------------------------------------------------------------
describe Alluvion::Synchro::Sequence, :'alluvion/synchro/sequence' do
  it { expect(subject).to respond_to(:call).with(0).arguments }
end

# .build() minimal example ----------------------------------------------------
describe Alluvion::Synchro::Sequence, :'alluvion/synchro/sequence' do
  context '.build(:up, config)' do
    sham!(:configs).complete.tap do |config|
      subject { described_class.build(:up, config) }
    end

    it { expect(subject).to be_a(Array) }
    it { expect(subject).to be_a(Alluvion::Synchro::Sequence) }
  end
end
