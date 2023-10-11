module Fastlane
    module Actions
      class CleanOutputsAction < Action
        def self.run(params)
          output_dir = params[:output_dir]
          build_dir = ".build"
  
          sh("rm -rf #{output_dir}")
          sh("rm -rf #{build_dir}")
        end
  
        private
  
        #####################################################
        # @!group Documentation
        #####################################################
  
        def self.description
          "Cleans precompile action outputs"
        end
  
        def self.available_options
          [
            FastlaneCore::ConfigItem.new(key: :output_dir,
                                         description: 'Path to output directory',
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
  