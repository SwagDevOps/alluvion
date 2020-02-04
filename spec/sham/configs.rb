# frozen_string_literal: true

autoload(:SecureRandom, 'securerandom')
autoload(:Etc, 'etc')

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
      'todo' => SPEC_DIR.join('temp/lock/todo.lock'),
      'done' => SPEC_DIR.join('temp/lock/done.lock'),
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
  },
  user: {
    'user' => {
      'HOME' => '<%= @HOME %>',
      'UID' => '<%= @UID %>',
      'USER' => '<%= @USER %>',
      'SECRET' => '<%= @SECRET %>',
    }
  }
}.yield_self do |config|
  Sham.config(FactoryStruct, :configs) do |c|
    c.attributes do
      {
        complete: config[:complete],
        user: config[:user],
      }
    end
  end
end
# @formatter:on
