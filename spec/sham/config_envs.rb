# frozen_string_literal: true

autoload(:Etc, 'etc')

Sham.config(FactoryStruct, :config_envs) do |c|
  c.attributes do
    # @formatter:off
    {
      user: {
        'USER': Etc.getlogin,
        'HOME': Etc.getpwnam(Etc.getlogin).dir,
        'UID': Etc.getpwnam(Etc.getlogin).uid,
        'SECRET': SecureRandom.urlsafe_base64(42),
      }
    }
    # @formatter:on
  end
end
