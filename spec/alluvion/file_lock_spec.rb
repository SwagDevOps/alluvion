# frozen_string_literal: true

autoload(:FileUtils, 'fileutils')
autoload(:Pathname, 'pathname')

describe Alluvion::FileLock, :'alluvion/file_lock' do
  sham!(:configs).complete['locks']['up'].yield_self do |file|
    subject { described_class.new(file) }
  end

  it { expect(subject).to be_a(Pathname) }
  it { expect(subject).to respond_to(:unlock).with(0).arguments }

  # rubocop:disable Metrics/LineLength
  it { expect(subject.method(:call).original_name).to eq(:lock!) }
  specify { expect { |b| subject.public_send(:call, &b) }.to yield_with_no_args }
  # rubocop:enable Metrics/LineLength
end

# Example for locking -----------------------------------------------
describe Alluvion::FileLock, :'alluvion/file_lock' do
  sham!(:configs).complete['locks']['up'].tap do |file|
    subject { described_class.new(file) }
  end

  [:lock!, :call].each do |method_name|
    context "##{method_name}" do
      (1..10).each do |v|
        it { expect(subject.public_send(method_name, &-> { v })).to be(v) }
      end
    end
  end

  4.times do
    { call: 0.75 }.each do |method_name, duration|
      context "##{method_name}" do
        # rubocop:disable Metrics/LineLength
        it 'in parallel run' do
          lambda do
            parallel(8) { subject.public_send(method_name, &-> { sleep(duration) }) }
          end.tap do |callable|
            expect { callable.call }.to raise_error(Alluvion::FileLock::LockError).with_message('Already locked (up)')
          end
          # wait for duration ---------------------------------------
          sleep(duration)
        end
        # rubocop:enable Metrics/LineLength
      end
    end
  end
end
