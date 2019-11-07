# frozen_string_literal: true

describe Alluvion::URI, :'alluvion/uri' do
  let(:subject) { described_class.new('ssh://user@example.org:22') }

  it { expect(subject).to respond_to(:host).with(0).arguments }
  it { expect(subject).to respond_to(:hostname).with(0).arguments }

  %w[scheme user query fragment path port].sort.each do |method_name|
    it { expect(subject).to respond_to(method_name).with(0).arguments }
  end

  %w[host hostname].sort.each do |method_name|
    context ".#{method_name}" do
      it { expect(subject.public_send(method_name)).to be_a(String) }
      it { expect(subject.public_send(method_name)).to be_a(Alluvion::Host) }
    end
  end
end
