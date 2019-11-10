# frozen_string_literal: true

autoload(:SecureRandom, 'securerandom')

# @formatter:off
# noinspection RubyStringKeysInHashInspection
{
  complete: {
    'url' => 'ssh://user@example.org:22',
    'timeout' => 0.5,
    'todo' => {
      'extensions' => ['torrent'],
      'mime_types' => ['application/x-bittorrent'],
    },
    'locks' => {
      'up' => SPEC_DIR.join('temp/lock/up.lock'),
      'down' => SPEC_DIR.join('temp/lock/down.lock'),
    },
    'paths' => {
      'local' => {
        'done' => '/data/complete',
        'todo' => SAMPLES_PATH.join('files'),
      },
      'remote' => {
        'done' => '/var/user/complete',
        'todo' => '/var/user/todo',
      }
    }
  }
}.yield_self do |config|
  Sham.config(FactoryStruct, :configs) do |c|
    c.attributes do
      {
        complete: config[:complete]
      }
    end
  end
end
# @formatter:on
