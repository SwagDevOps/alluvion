# frozen_string_literal: true

autoload(:Pathname, 'pathname')

Sham.config(FactoryStruct, :samples) do |c|
  c.attributes do
    # @formatter:off
    {
      files: lambda do
        Dir.glob(SAMPLES_PATH.join('files', '*')).map do |file|
          [Pathname.new(file), 'application/x-bittorrent'].tap do |res|
            res[0].basename('.*').to_s.tap do |fname|
              res[1] = 'text/html' if fname == '404'
              res[1] = 'empty' if fname == 'empty'
            end
          end
        end
      end.call.to_h
    }
    # @formatter:on
  end
end
