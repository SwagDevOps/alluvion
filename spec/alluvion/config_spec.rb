# frozen_string_literal: true

describe Alluvion::Config, :'alluvion/config' do
  it { expect(described_class).to respond_to(:read).with(1).arguments }
end

describe Alluvion::Config, :'alluvion/config' do
  let(:subject) do
    sham!(:configs).complete.yield_self do |h|
      described_class.new(h)
    end
  end

  lambda do
    # noinspection RubyStringKeysInHashInspection
    sham!(:configs).complete.yield_self do |h|
      # @formatter:off
      {
        'url' => { String => h['url'] },
        'timeout' => { Float => h['timeout'] },
        'paths.local' => { Hash => h['paths']['local'] },
        'paths.local.done' => { String => h['paths']['local']['done'] },
      }
      # @formatter:on
    end
  end.call.each do |k, v|
    context "#[](#{k.inspect})" do
      it { expect(subject[k]).to eq(v.values[0]) }
      it { expect(subject[k]).to be_a(v.keys[0]) }
    end
  end
end

# rubocop:disable Metrics/BlockLength
describe Alluvion::Config, :'alluvion/config' do
  sham!(:samples).configs.fetch('complete').tap do |sample|
    subject { described_class.read(sample.file) }

    it { expect(subject).to be_a(Alluvion::Config) }

    sample.read.each do |k, v|
      context "#[#{k.inspect}]" do
        it { expect(subject[k]).to eq(v) }
      end
    end

    # noinspection RubyStringKeysInHashInspection
    # @formatter:off
    {
      'url' => String,
      'timeout' => Float,
      'locks' => Hash,
      'locks.todo' => String,
      'locks.done' => String,
      'paths.local' => Hash,
      'paths.local.todo' => String,
      'paths.local.done' => String,
      'paths.remote' => Hash,
      'paths.remote.todo' => String,
      'paths.remote.done' => String,
    }.each do |k, type|
      # @formatter:on
      context "#[#{k.inspect}]" do
        it { expect(subject[k]).to be_a(type) }
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength

# retrieve env from config ------------------------------------------
describe Alluvion::Config, :'alluvion/config' do
  sham!(:config_envs).user.tap do |env|
    let(:config) { sham!(:configs).user }
    subject { described_class.new(config, env: env) }

    env.each do |k, v|
      # esnure consistency ------------------------------------------
      context ".env[#{k.inspect}]" do
        it do
          expect(subject.env[k]).to_not eq(nil)
          expect(subject.env[k]).to eq(v)
        end
      end

      # ensure template evaluation ----------------------------------
      "user.#{k}".tap do |key|
        context ".[#{key.inspect}]" do
          it { expect(subject[key]).to eq(v) }
        end
      end
    end
  end
end
