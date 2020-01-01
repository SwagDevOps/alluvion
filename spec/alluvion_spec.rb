# frozen_string_literal: true

# constants ---------------------------------------------------------
describe Alluvion, :alluvion do
  it { expect(described_class).to be_const_defined(:VERSION) }
  it { expect(described_class).to be_const_defined(:Cli) }
  it { expect(described_class).to be_const_defined(:Config) }
  it { expect(described_class).to be_const_defined(:File) }
  it { expect(described_class).to be_const_defined(:FileLock) }
  it { expect(described_class).to be_const_defined(:Host) }
  it { expect(described_class).to be_const_defined(:Shell) }
  it { expect(described_class).to be_const_defined(:Synchro) }
  it { expect(described_class).to be_const_defined(:URI) }
end
