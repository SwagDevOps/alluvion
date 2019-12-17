# frozen_string_literal: true

# constants ---------------------------------------------------------
describe Alluvion::Synchro, :'alluvion/synchro' do
  it { expect(described_class).to be_const_defined(:Sequence) }
end

describe Alluvion::Synchro, :'alluvion/synchro' do
  let(:subject) { described_class.new(sham!(:configs).complete) }

  [:up, :down].sort.each do |method_name|
    it { expect(subject).to respond_to(method_name).with(0).arguments }

    context ".#{method_name}" do
      it do
        # rubocop:disable Metrics/LineLength
        %r{^Can not connect to "[a-z]+://[a-z]+@[a-z]+.[a-z]+:[0-9]+"$}.tap do |msg|
          expect { subject.public_send(method_name) }.to raise_error(RuntimeError).with_message(msg)
        end
        # rubocop:enable Metrics/LineLength
      end
    end
  end
end
