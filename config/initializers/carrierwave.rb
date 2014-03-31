module CarrierWave
  module Uploader
    module Cache
      def cache!(new_file = sanitized_file)
        if new_file.is_a?(String) && new_file.index('/uploads/') == 0
          new_file = File.open(File.join(Rails.root, 'public', new_file)) rescue new_file
        end

        new_file = CarrierWave::SanitizedFile.new(new_file)

        unless new_file.empty?
          raise CarrierWave::FormNotMultipart if new_file.is_path? && ensure_multipart_form

          with_callbacks(:cache, new_file) do
            self.cache_id = CarrierWave.generate_cache_id unless cache_id

            @filename = new_file.filename
            self.original_filename = new_file.filename

            if move_to_cache
              @file = new_file.move_to(cache_path, permissions, directory_permissions)
            else
              @file = new_file.copy_to(cache_path, permissions, directory_permissions)
            end
          end
        end
      end
    end
  end
end

CarrierWave.configure do |config|
  config.asset_host = CONFIG[:site]
end

CarrierWave::SanitizedFile.sanitize_regexp = /[^[:word:]\.\-\+]/
