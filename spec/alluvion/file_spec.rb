# frozen_string_literal: true

# instance methdos --------------------------------------------------
describe Alluvion::File, :'alluvion/file' do
  let(:subject) { described_class.new(__FILE__) }

  it { expect(subject).to respond_to(:ctime).with(0).arguments }
  it { expect(subject).to respond_to(:mtime).with(0).arguments }

  it { expect(subject).to respond_to(:mime).with(0).arguments }
  it { expect(subject).to respond_to(:mime_type).with(0).arguments }
end

describe Alluvion::File, :'alluvion/file' do
  sham!(:samples).files.each do |fp, mime_type|
    context '.mime_type' do
      let(:subject) { described_class.new(fp) }

      it { expect(subject.mime_type).to eq(mime_type) }
    end
  end
end

# mtime + ctime examples --------------------------------------------
describe Alluvion::File, :'alluvion/file' do
  let(:subject) { described_class.new(__FILE__) }

  [:mtime, :ctime].each do |method|
    context "##{method}" do
      it { expect(subject.public_send(method)).to be_a(Time) }

      it do
        Pathname.new(__FILE__).stat.public_send(method).tap do |expected|
          expect(subject.public_send(method)).to eq(expected)
        end
      end
    end
  end
end
