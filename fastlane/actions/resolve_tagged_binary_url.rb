module Fastlane
    module Actions
      class ResolveTaggedBinaryUrlAction < Action
        def self.run(params)
            sh("sed 's|untagged-.*\/|#{params[:version]}\/|' <<< #{params[:draft_asset_url]} | tr -d '\n'")
        end
  
        #####################################################
        # @!group Documentation
        #####################################################
  
        def self.description
          "Computes a subsequent asset url after publishing a draft release."
        end
  
        def self.available_options
          [
            FastlaneCore::ConfigItem.new(key: :draft_asset_url,
                                         description: 'Draft asset url',
                                         optional: false,
                                         is_string: true),
  
            FastlaneCore::ConfigItem.new(key: :version,
                                         description: 'Release version',
                                         optional: false,
                                         is_string: true)
          ]
        end

        def self.return_value
            :string        
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