# frozen_string_literal: true

autoload(:Pathname, 'pathname')
autoload(:YAML, 'yaml')

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
      end.call.to_h,
      configs: lambda do
        # Get sample configs
        # indexed by filenamewith path and read (parsed) content
        Dir.glob(SAMPLES_PATH.join('configs', '*')).map do |file|
          [Pathname.new(file).basename('.*').to_s, nil].tap do |res|
            {
              file: Pathname.new(file),
              read: YAML.safe_load(Pathname.new(file).read)
            }.tap { |struct| res[1] = FactoryStruct.new(struct) }
          end
        end
      end.call.to_h
    }
    # @formatter:on
  end
end
