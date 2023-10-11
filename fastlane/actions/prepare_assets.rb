module Fastlane
    module Actions
      class PrepareAssetsAction < Action
        def self.run(params)
					precompiled_dir_path = params[:precompiled_dir_path]
          license_file_path = params[:license_file_path]
					output_dir_path = params[:output_dir_path]

					sh("cp #{license_file_path} #{precompiled_dir_path}")
					Fastlane::Actions::ZipAction.run(
            path: precompiled_dir_path,
            output_path: output_dir_path
					)
        end
  
        #####################################################
        # @!group Documentation
        #####################################################
  
        def self.description
          "Prepares a zip with assets to be pushed as a GitHub release"
        end
  
        def self.available_options
          [
            FastlaneCore::ConfigItem.new(key: :precompiled_dir_path,
                                         description: 'Path to the Precompiled directory to be released',
                                         optional: false,
                                         is_string: true),

            FastlaneCore::ConfigItem.new(key: :license_file_path,
                                         description: 'Path to the LICENSE file to be attached',
                                         optional: false,
                                         is_string: true),
            
						FastlaneCore::ConfigItem.new(key: :output_dir_path,
                                         description: 'Path to the output zip archive',
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
  