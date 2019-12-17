# frozen_string_literal: true

# constants + class methods ---------------------------------------------------
describe Alluvion::Synchro::Sequence, :'alluvion/synchro/sequence' do
  it { expect(described_class).to be_const_defined(:Command) }
  it { expect(described_class).to be_const_defined(:Factory) }

  it { expect(described_class).to respond_to(:build).with(2).arguments }
end
