# frozen_string_literal: true

autoload(:SecureRandom, 'securerandom')

Sham.config(FactoryStruct, :configs) do |c|
  # noinspection RubyStringKeysInHashInspection
  c.attributes do
    {
      complete: lambda do
        # @formatter:off
        {
          'url' => 'ssh://user@example.org:22',
          'timeout' => 0.5,
          'todo' => {
            'extensions' => ['torrent'],
            'mime_types' => ['application/x-bittorrent'],
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
        # @formatter:off
      end.call
    }
  end
end
