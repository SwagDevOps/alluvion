# frozen_string_literal: true

# class methdos -----------------------------------------------------
describe Alluvion::FileLock::Error, :'alluvion/file_lock/error' do
  it { expect(described_class).to respond_to(:new).with(1).arguments }
  # rubocop:disable Layout/LineLength
  it { expect(described_class).to respond_to(:new).with(1).arguments.and_keywords(:cause) }
  # rubocop:enable Layout/LineLength
end

# instance methdos --------------------------------------------------
describe Alluvion::FileLock::Error, :'alluvion/file_lock/error' do
  let(:cause) { RuntimeError.new('previous error') }
  let(:subject) { described_class.new('sample error', cause: cause) }

  it { expect(subject).to respond_to(:cause).with(0).arguments }
  it { expect(subject).to respond_to(:cause?).with(0).arguments }
end

describe Alluvion::FileLock::Error, :'alluvion/file_lock/error' do
  let(:subject) { described_class.new('sample error') }

  [:message, :to_s].each do |method|
    context "##{method}" do
      it { expect(subject.public_send(method)).to eq('sample error') }
    end
  end
end

[RuntimeError.new('previous error'), nil].each do |cause|
  describe Alluvion::FileLock::Error, :'alluvion/file_lock/error' do
    let(:subject) { described_class.new('sample error', cause: cause) }

    context '#cause' do
      it { expect(subject.cause).to eq(cause) }
    end

    context '#cause?' do
      it { expect(subject.cause?).to eq(!!cause) }
    end
  end
end
