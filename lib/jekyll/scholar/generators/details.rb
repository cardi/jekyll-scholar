module Jekyll
  class Scholar

    class Details < Page
      include Scholar::Utilities

      def initialize(site, base, dir, entry)
        @site, @base, @dir, @entry = site, base, dir, entry

        @config = Scholar.defaults.merge(site.config['scholar'] || {})

        # Specify a temporary filename for now based upon the citation key. Jekyll
        # will modify this according to the URL template below
        @name = entry.key.to_s.gsub(/[:\s]+/, '_')
        @name << '.html'

        process(@name)
        read_yaml(File.join(base, '_layouts'), config['details_layout'])

        data.merge!(reference_data(entry))
        data['title'] = data['entry']['title'] if data['entry'].has_key?('title')
      end

      def url
        # Reuse the logic in the utilities module for deciding URLs
        details_path_for(@entry)
      end
    end

    class DetailsGenerator < Generator
      include Scholar::Utilities

      safe true
      priority :high

      attr_reader :config

      def generate(site)
        @site, @config = site, Scholar.defaults.merge(site.config['scholar'] || {})
        @cache ||= Jekyll::Cache.new("Jekyll::Scholar::DetailsGenerator")

        # Check for removed option and warn if it is set
        if @config.include? 'use_raw_bibtex_entry'
          Jekyll.logger.warn('Jekyll-scholar:',
                             'Option `use_raw_bibtex_entry` is no longer supported')
        end

        if generate_details?
          entries.each do |entry|
            details = Details.new(site, site.source, File.join('', details_path), entry)

            # on first run, cache miss
            # on subsequent runs, should cache hit
            printf "[jekyll-scholar/details.rb] %s in cache? %s\n", details.path, @cache.key?(details.path)
            if @cache.key?(details.path) != true
              @cache[details.path] = 1
            done

            # on first entry, cache miss
            # on subsequent entries (and runs), should cache hit
            if @cache.key?("test-key") != true
              printf "[jekyll-scholar/details.rb] 'test-key' not in cache\n"
              printf "[jekyll-scholar/details.rb] store 'test-key' in cache\n"
              @cache["test-key"] = "12345"
            else
              printf "[jekyll-scholar/details.rb] 'test-key' in cache, value is %s\n", @cache["test-key"]
            end

            details.render(site.layouts, site.site_payload)
            details.write(site.dest)

            site.pages << details
          end

        end
      end

    end


  end
end
