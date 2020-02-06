# frozen_string_literal: true

require 'tmpdir'
autoload(:Pathname, 'pathname')

# constants ---------------------------------------------------------
describe Alluvion::Synchro, :'alluvion/synchro' do
  it { expect(described_class).to be_const_defined(:Sequence) }
end

# insrance methods --------------------------------------------------
describe Alluvion::Synchro, :'alluvion/synchro' do
  let(:subject) { described_class.new(sham!(:configs).complete) }

  it { expect(subject).to respond_to(:call).with(1).arguments }
end

describe Alluvion::Synchro, :'alluvion/synchro' do
  let(:subject) { described_class.new(sham!(:configs).complete) }

  [:done, :todo].each do |direction|
    context "#call(#{direction.inspect})" do
      it do
        # rubocop:disable Metrics/LineLength
        %r{^can not connect to "[a-z]+://[a-z]+@[a-z]+.[a-z]+:[0-9]+"$}.tap do |msg|
          expect { subject.call(direction) }.to raise_error(RuntimeError).with_message(msg)
        end
        # rubocop:enable Metrics/LineLength
      end
    end
  end
end

# lock_files ------------------------------------------------------------------
describe Alluvion::Synchro, :'alluvion/synchro' do
  let(:subject) { described_class.new(sham!(:configs).complete) }

  context '#lock_files' do
    it { expect(subject.__send__(:lock_files)).to be_a(Hash) }
  end

  [:done, :todo].each do |direction|
    context "#lock_files[#{direction.inspect}]" do
      # rubocop:disable Layout/LineLength
      let(:expected) { Pathname(Dir.tmpdir).join("alluvion.#{Process.uid}.#{direction}.lock") }
      # rubocop:enable Layout/LineLength

      it { expect(subject.__send__(:lock_files)[direction]).to be_a(Pathname) }
      it { expect(subject.__send__(:lock_files)[direction]).to eq(expected) }
    end
  end
end
