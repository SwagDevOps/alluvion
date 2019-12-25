# frozen_string_literal: true

autoload(:FileUtils, 'fileutils')
autoload(:Pathname, 'pathname')

describe Alluvion::FileLock, :'alluvion/file_lock' do
  sham!(:configs).complete['locks']['up'].yield_self do |file|
    subject { described_class.new(file, timeout: 0.15) }
  end

  before(:each) { sleep(0.5) }
  after(:each) { sleep(0.5) }

  it { expect(subject).to be_a(Pathname) }
  it { expect(subject).to respond_to(:unlock).with(0).arguments }
  it { expect(subject.method(:call).original_name).to eq(:lock!) }
  specify do
    expect { |b| subject.public_send(:call, &b) }.to yield_with_no_args
  end
end

# Examples for locking -----------------------------------------------
describe Alluvion::FileLock, :'alluvion/file_lock' do
  sham!(:configs).complete['locks']['up'].tap do |file|
    subject { described_class.new(file, timeout: 0.15) }
  end

  before(:each) { sleep(0.5) }
  after(:each) { sleep(0.5) }

  [:lock!, :call].each do |method_name|
    context "##{method_name}" do
      (1..10).each do |v|
        it { expect(subject.public_send(method_name, &-> { v })).to be(v) }
      end
    end
  end
end

# rubocop:disable Layout/LineLength
describe Alluvion::FileLock, :'alluvion/file_lock', :'alluvion/file_lock#parallel' do
  sham!(:configs).complete['locks']['up'].tap do |file|
    subject { described_class.new(file, timeout: 0.01) }
  end

  after(:each) { sleep(0.5) }

  4.times do
    { call: 0.01 }.each do |method_name, duration|
      context "##{method_name}" do
        it 'in parallel run' do
          lambda do
            parallel(64) { subject.public_send(method_name, &-> { sleep(duration) }) }
          end.tap do |callable|
            expect { callable.call }.to raise_error(Alluvion::FileLock::Error).with_message('Can not acquire lock (up)')
          end
        end
      end
    end
  end
end
# rubocop:enable Layout/LineLength
