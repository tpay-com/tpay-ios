module Fastlane
    module Actions
      class PrecompileModuleAction < Action
        def self.run(params)
          output_dir = params[:output_dir]
          scheme_name = params[:scheme_name]
          module_name = params[:module_name]
          build_dir = ".build"
  
          sh("rm -rf #{output_dir}")
          sh("rm -rf #{build_dir}")
          sh("mkdir #{output_dir}")
  
          Fastlane::Actions::PrecompileXcodeprojModuleAction.run(
            scheme_name: scheme_name,
            module_name: module_name,
            output_dir_path: output_dir
          )

          sh("cp -r #{build_dir}/#{module_name}-ios.xcarchive/dSYMs/#{module_name}.framework.dSYM #{output_dir}/#{module_name}-ios.framework.dSYM")
          sh("cp -r #{build_dir}/#{module_name}-ios.xcarchive/dSYMs/#{module_name}.framework.dSYM #{output_dir}/#{module_name}-ios_sim.framework.dSYM")
        end
  
        private
  
        #####################################################
        # @!group Documentation
        #####################################################
  
        def self.description
          "Precompiles module to xcframework at a given output path"
        end
  
        def self.available_options
          [
            FastlaneCore::ConfigItem.new(key: :output_dir,
                                         description: 'Path to output directory',
                                         optional: false,
                                         is_string: true),
  
            FastlaneCore::ConfigItem.new(key: :scheme_name,
                                         description: 'Name of the scheme to be built (for xcode projects only)',
                                         optional: true,
                                         is_string: true),
  
            FastlaneCore::ConfigItem.new(key: :module_name,
                                         description: 'Name of the module if different from scheme name (for xcode projects only)',
                                         optional: true,
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
  