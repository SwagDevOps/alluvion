# frozen_string_literal: true

describe Alluvion::URI, :'alluvion/uri' do
  let(:subject) { described_class.new('ssh://user@example.org:22') }

  %w[scheme user query fragment path port].sort.each do |method_name|
    it { expect(subject).to respond_to(method_name).with(0).arguments }
  end

  %w[host hostname].sort.each do |method_name|
    it { expect(subject).to respond_to(method_name).with(0).arguments }

    context ".#{method_name}" do
      it { expect(subject.public_send(method_name)).to be_a(String) }
      it { expect(subject.public_send(method_name)).to be_a(Alluvion::Host) }
    end
  end
end

describe Alluvion::URI, :'alluvion/uri' do
  let(:subject) { described_class.new('ssh://user@example.org:22') }

  # @formatter:off
  {
    host: 'example.org',
    port: 22,
    path: '',
    user: 'user',
    scheme: 'ssh',
    query: nil,
    fragment: nil
  }.each do |k, v|
    context(".#{k}") do
      it { expect(subject.public_send(k)).to eq(v) }
    end
  end
  # @formatter:on
end

# example with missing method ---------------------------------------
describe Alluvion::URI, :'alluvion/uri' do
  let(:subject) { described_class.new('ssh://user@example.org:22') }

  # undefined method `undefined_method' for "#{uri}":Alluvion::URI
  'undefined_method'.tap do |method|
    context "##{method}" do
      it do
        expect { subject.public_send(method) }.to raise_error(::NoMethodError)
      end
    end
  end
end

# examples with "unparsable" URIs -----------------------------------
describe Alluvion::URI, :'alluvion/uri' do
  # @formatter:off
  {
    'ssh://example.org:22' => :user,
    'ssh://user@example.org' => :port,
    'ssh://user@:22' => :hostname,
  }.each do |uri, method| # @formatter:on
    context ".parse(#{uri.inspect})" do
      it do
        "can not determine `#{method}'".tap do |message|
          # rubocop:disable Layout/LineLength
          # noinspection RubyResolve
          expect { described_class.parse(uri.to_s) }.to raise_error(::URI::InvalidURIError).with_message(message)
          # rubocop:enable Layout/LineLength
        end
      end
    end
  end
end
