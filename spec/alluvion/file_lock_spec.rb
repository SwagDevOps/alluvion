# frozen_string_literal: true

autoload(:FileUtils, 'fileutils')
autoload(:Pathname, 'pathname')

# rubocop:disable Layout/LineLength
describe Alluvion::FileLock, :'alluvion/file_lock' do
  after(:each) { subject.unlock }

  let(:subject) do
    sham!(:configs).complete['locks']['up'].yield_self do |file|
      described_class.new(file)
    end
  end

  it { expect(subject).to be_a(Pathname) }
  it { expect(subject).to respond_to(:unlock).with(0).arguments }
  it { expect(subject.method(:call).original_name).to eq(:lock!) }

  context '.call' do
    specify do
      expect { |b| subject.public_send(:call, &b) }.to yield_with_no_args
    end
  end

  context '.unlock' do
    it { expect(subject.unlock).to be_a(described_class) }
  end
end

# Examples for locking -----------------------------------------------
describe Alluvion::FileLock, :'alluvion/file_lock', :'alluvion/file_lock#call' do
  after(:each) { subject.unlock }

  let(:subject) do
    sham!(:configs).complete['locks']['up'].yield_self do |file|
      described_class.new(file)
    end
  end

  [:lock!, :call].each do |method_name|
    context "##{method_name}" do
      (1..10).each do |v|
        it { expect(subject.public_send(method_name, &-> { v })).to be(v) }
      end
    end
  end
end

describe Alluvion::FileLock, :'alluvion/file_lock', :'alluvion/file_lock#parallel' do
  after(:each) { subject.unlock }

  let(:subject) do
    sham!(:configs).complete['locks']['up'].yield_self { |file| described_class.new(file) }
  end

  let(:locker) do
    lambda do |lock, &block|
      SafeThread.new { described_class.new(lock).call }.tap do
        sleep(0.01)
        lock.call(&block)
      end.join
    end
  end

  4.times do
    { call: 0.15 }.each do |method_name, duration|
      context "##{method_name}" do
        it 'in parallel run' do
          expect do
            locker.call(subject) do
              subject.public_send(method_name, &-> { sleep(duration) })
            end
          end.to raise_error(Alluvion::FileLock::Error).with_message('can not acquire lock (up)')
        end
      end
    end
  end
end
# rubocop:enable Layout/LineLength
