module Fastlane
    module Actions
      class UpdateSwiftPackageBinaryTargetAction < Action
        def self.run(params)
          local_binary_zip_path = params[:local_binary_zip_path]
          remote_binary_zip_url = params[:remote_binary_zip_url]
          package_file_path = params[:package_file_path]

          checksum = sh("swift package compute-checksum #{local_binary_zip_path} | tr -d '\n'")

          sh("sed -i '' 's|url:.*|url: \"#{remote_binary_zip_url}\",|g' #{package_file_path}")
          sh("sed -i '' 's|checksum:.*|checksum: \"#{checksum}\"|g' #{package_file_path}")
        end
  
        #####################################################
        # @!group Documentation
        #####################################################
  
        def self.description
          "Updates swift package binary target"
        end
  
        def self.available_options
          [
            FastlaneCore::ConfigItem.new(key: :local_binary_zip_path,
                                         description: 'Path to the local binary zip file',
                                         optional: false,
                                         is_string: true),

            FastlaneCore::ConfigItem.new(key: :remote_binary_zip_url,
                                         description: 'Url to the remote zip file',
                                         optional: false,
                                         is_string: true),
  
            FastlaneCore::ConfigItem.new(key: :package_file_path,
                                         description: 'Path to the package file',
                                         optional: false,
                                         is_string: true)
          ]
        end
  
        def self.authors
          ["Tpay"]
        end
  
        def self.is_supported?(platform)
          platform == :ios
        end
      end
    end
  end
  