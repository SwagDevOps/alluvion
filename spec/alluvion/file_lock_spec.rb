# frozen_string_literal: true

autoload(:FileUtils, 'fileutils')
autoload(:Pathname, 'pathname')

describe Alluvion::FileLock, :'alluvion/file_lock' do
  subject do
    sham!(:configs).complete['locks']['up'].yield_self do |fp|
      described_class.new(fp)
    end
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

    after(:each) { FileUtils.rm_f(file) }
    before(:each) { FileUtils.rm_f(file) }
  end

  [:lock!, :call].each do |method_name|
    context "##{method_name}" do
      (1..10).each do |v|
        it do
          expect(subject.lock! { v }).to be(v)
        end
      end
    end
  end

  { lock!: 1.5, call: 1.5 }.each do |method_name, duration|
    context "##{method_name}" do
      # rubocop:disable Metrics/LineLength
      it do
        -> { parallel(2) { subject.public_send(method_name, &-> { sleep(duration) }) } }.tap do |callable|
          expect { callable.call }.to raise_error(Alluvion::FileLock::LockError).with_message('Already locked (up)')
        end
      end
      # rubocop:enable Metrics/LineLength
    end
  end
end
