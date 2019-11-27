# frozen_string_literal: true

autoload(:FileUtils, 'fileutils')
autoload(:Pathname, 'pathname')

describe Alluvion::FileLock, :'alluvion/file_lock' do
  sham!(:configs).complete['locks']['up'].yield_self do |file|
    subject { described_class.new(file) }
  end

  it { expect(subject).to be_a(Pathname) }
  it { expect(subject).to respond_to(:unlock).with(0).arguments }
  it { expect(subject.method(:call).original_name).to eq(:lock!) }
  specify do
    expect do |b|
      sleep(0.001) # minimal lock timeout
      subject.public_send(:call, &b)
    end.to yield_with_no_args
  end
end

# rubocop:disable Metrics/BlockLength
# Example for locking -----------------------------------------------
describe Alluvion::FileLock, :'alluvion/file_lock' do
  sham!(:configs).complete['locks']['up'].tap do |file|
    subject { described_class.new(file) }
  end

  [:lock!, :call].each do |method_name|
    context "##{method_name}" do
      (1..10).each do |v|
        it do
          sleep(0.001) # minimal lock timeout
          expect(subject.public_send(method_name, &-> { v })).to be(v)
        end
      end
    end
  end

  4.times do
    { call: 0.15 }.each do |method_name, duration|
      context "##{method_name}" do
        # rubocop:disable Metrics/LineLength
        it 'in parallel run' do
          lambda do
            parallel(64) { subject.public_send(method_name, &-> { sleep(duration) }) }
          end.tap do |callable|
            expect { callable.call }.to raise_error(Alluvion::FileLock::LockError).with_message('Already locked (up)')
          end
          # wait for duration ---------------------------------------
          sleep(duration + 0.001)
        end
        # rubocop:enable Metrics/LineLength
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
