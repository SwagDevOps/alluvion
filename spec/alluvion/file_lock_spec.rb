# frozen_string_literal: true

autoload(:Pathname, 'pathname')

# rubocop:disable Layout/LineLength
describe Alluvion::FileLock, :'alluvion/file_lock' do
  let(:subject) do
    sham!(:configs).complete['locks']['todo'].yield_self do |file|
      described_class.new(file)
    end
  end

  it { expect(subject).to be_a(Pathname) }
  it { expect(subject).to respond_to(:unlock).with(0).arguments }

  it { expect(subject.method(:call).original_name).to eq(:lock!) }
  [:lock!, :call].each do |method_name|
    context "##{method_name}" do
      it { expect(subject).to respond_to(method_name).with(0).arguments }
    end
  end

  context '.unlock' do
    it { expect(subject.unlock).to be_a(described_class) }
  end
end

# Examples for locking -----------------------------------------------
describe Alluvion::FileLock, :'alluvion/file_lock', :'alluvion/file_lock#call' do
  let(:subject) do
    sham!(:configs).complete['locks']['todo'].yield_self do |file|
      described_class.new(file)
    end
  end

  [:lock!, :call].each do |method_name|
    context "##{method_name}" do
      after(:each) { subject.unlock }

      sham!(:generators).counter.call(10).each do |v|
        it { expect(subject.public_send(method_name, &-> { v })).to be(v) }
      end

      sham!(:generators).randomizer.call(10).each do |v|
        it { expect(subject.public_send(method_name, &-> { v })).to be(v) }
      end
    end
  end
end

# rubocop:disable Metrics/BlockLength
describe Alluvion::FileLock, :'alluvion/file_lock', :'alluvion/file_lock#parallel' do
  let(:lock_name) { 'todo' }
  let(:lock_file) { sham!(:configs).complete['locks'][lock_name] }
  let(:subject) { described_class.new(lock_file) }

  let(:locker) do
    lambda do |subject, &block|
      # @formatter:off
      described_class.new(subject.to_path).tap do |main|
        SafeThread.new { main.call }.tap { sleep(0.05) }.tap { subject.call(&block) }.join
      rescue StandardError => e
        main.unlock
        raise e
      end
      # @formatter:on
    end
  end

  20.times do
    { call: 0.01 }.each do |method, duration|
      context "##{method}" do
        it 'in parallel run' do
          "can not acquire lock (#{lock_name})".tap do |expected_message|
            expect do
              locker.call(subject) { subject.public_send(method, &-> { sleep(duration) }) }
            end.to raise_error(Alluvion::FileLock::Error).with_message(expected_message)
          end
        end
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
# rubocop:enable Layout/LineLength
