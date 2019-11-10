# frozen_string_literal: true

describe Alluvion::File, :'alluvion/file' do
  sham!(:samples).files.each do |fp, mime_type|
    context '.mime_type' do
      let(:subject) { described_class.new(fp) }

      it { expect(subject.mime_type).to eq(mime_type) }
    end
  end
end
