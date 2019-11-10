# frozen_string_literal: true

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
    context ".[](#{k.inspect})" do
      it { expect(subject[k]).to eq(v.values[0]) }
      it { expect(subject[k]).to be_a(v.keys[0]) }
    end
  end
end
