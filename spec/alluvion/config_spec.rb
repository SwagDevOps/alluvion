# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
describe Alluvion::Config, :'alluvion/config' do
  let(:subject) do
    # @formatter:off
    # noinspection RubyStringKeysInHashInspection
    {
      'url' => 'ssh://user@example.org:22',
      'paths' => {
        'local' => {
          'done' => '/data/complete',
          'todo' => '/data/todo',
        },
        'remote' => {
          'done' => '/var/user/complete',
          'todo' => '/var/user/todo',
        }
      }

    }.tap { |config| return described_class.new(config) }
    # @formatter:on
  end

  # @formatter:off
  # noinspection RubyStringKeysInHashInspection
  {
    'paths.local' => {
      'done' => '/data/complete',
      'todo' => '/data/todo'
    },
    'paths.local.done' => '/data/complete',
  }.each do |k, v|
    context ".[](#{k.inspect})" do
      it { expect(subject[k]).to eq(v) }
    end
  end
  # @formatter:on
end
# rubocop:enable Metrics/BlockLength
