# frozen_string_literal: true

# constants ---------------------------------------------------------
describe Alluvion::Synchro::Sequence, :'alluvion/synchro/sequence' do
  it { expect(described_class).to be_const_defined(:Command) }
  it { expect(described_class).to be_const_defined(:Factory) }
end
