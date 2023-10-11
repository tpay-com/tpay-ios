module Fastlane
    module Actions
      class UpdatePodspecSourceAction < Action
        def self.run(params)
          remote_binary_zip_url = params[:remote_binary_zip_url]
          podspec_file_path = params[:podspec_file_path]

          sh("sed -i '' 's|s.source =.*|s.source = { :http => \"#{remote_binary_zip_url}\", :flatten => true }|g' #{podspec_file_path}")
        end
  
        #####################################################
        # @!group Documentation
        #####################################################
  
        def self.description
          "Updates podspec source"
        end
  
        def self.available_options
          [
            FastlaneCore::ConfigItem.new(key: :remote_binary_zip_url,
                                         description: 'Url to the remote zip file',
                                         optional: false,
                                         is_string: true),
  
            FastlaneCore::ConfigItem.new(key: :podspec_file_path,
                                         description: 'Path to the podspec file',
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
  