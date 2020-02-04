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

# .build() minimal examples (with directions) ---------------------------------
[:done, :todo].each do |direction|
  describe Alluvion::Synchro::Sequence, :'alluvion/synchro/sequence' do
    context ".build(#{direction.inspect}, config)" do
      sham!(:configs).complete.tap do |config|
        subject { described_class.build(direction, config) }
      end

      it { expect(subject).to be_a(Array) }
      it { expect(subject).to be_a(Alluvion::Synchro::Sequence) }
    end
  end
end

describe Alluvion::Synchro::Sequence, :'alluvion/synchro/sequence' do
  context '.build(:wrong, config)' do
    it do
      # rubocop:disable Layout/LineLength
      expect do
        sham!(:configs).complete.tap do |config|
          described_class.build(:wrong, config)
        end
      end.to raise_error(Alluvion::Synchro::Sequence::NotFoundError, "sequence not found: #{:wrong.inspect}")
      # rubocop:enable Layout/LineLength
    end
  end
end
