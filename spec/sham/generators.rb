# frozen_string_literal: true

autoload(:SecureRandom, 'securerandom')

Sham.config(FactoryStruct, :generators) do |c|
  # rubocop:disable Layout/LineLength
  c.attributes do
    # @formatter:off
    {
      counter: ->(count) { (1..count).to_a },
      randomizer: ->(count, size: 12) { (1..count).map { SecureRandom.urlsafe_base64(size) } }
    }
    # @formatter:on
  end
  # rubocop:enable Layout/LineLength
end
