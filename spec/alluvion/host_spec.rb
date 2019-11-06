# frozen_string_literal: true

describe Alluvion::Host, :'alluvion/host' do
  let(:subject) { described_class.new('example.org') }

  # rubocop:disable Metrics/LineLength
  it { expect(subject).to respond_to(:port_open?).with(1).arguments }
  it { expect(subject).to respond_to(:port_open?).with(1).arguments.with_keywords(:timeout) }
  # rubocop:enable Metrics/LineLength

  # @formatter:off
  {
    80 => true,
    8080 => false,
  }.each do |port, v|
    context ".port_open?(#{port.inspect})" do
      it { expect(subject.port_open?(port, timeout: 0.15)).to be(v) }
    end
  end
  # @formatter:on
end
