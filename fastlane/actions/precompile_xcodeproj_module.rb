module Fastlane
    module Actions
      class PrecompileXcodeprojModuleAction < Action
        def self.run(params)
          scheme_name = params[:scheme_name]
          output_dir_path = params[:output_dir_path]
          module_name = scheme_name
          unless params[:module_name].nil?
            module_name = params[:module_name]
          end
  
          archive_iphoneos(module_name, scheme_name)
          archive_iphonesimulator(module_name, scheme_name)
          create_xcframework(module_name, output_dir_path)
        end
  
        private
  
        def self.archive_iphoneos(module_name, scheme_name)
          Fastlane::Actions::XcarchiveAction.run(
            scheme: scheme_name,
            archive_path: ".build/#{module_name}-ios.xcarchive",
            xcargs: "-destination 'generic/platform=iOS' -sdk 'iphoneos'",
            build_settings: build_settings_hash
          )
        end
  
        def self.archive_iphonesimulator(module_name, scheme_name)
          Fastlane::Actions::XcarchiveAction.run(
            scheme: scheme_name,
            archive_path: ".build/#{module_name}-ios_sim.xcarchive",
            xcargs: "-destination 'generic/platform=iOS Simulator' -sdk 'iphonesimulator'",
            build_settings: build_settings_hash
          )
        end
  
        def self.create_xcframework(module_name, output_dir_path)
          Fastlane::Actions::CreateXcframeworkAction.run(
            frameworks: [ios_framework_build_path(module_name), ios_sim_framework_build_path(module_name)],
            output: "#{output_dir_path}/#{module_name}.xcframework"
          )
        end
  
        def self.build_settings_hash 
          { 
            :SKIP_INSTALL => 'NO',
            :BUILD_LIBRARIES_FOR_DISTRIBUTION => 'YES'
          }
        end
  
        def self.ios_framework_build_path(module_name)
          ".build/#{module_name}-ios.xcarchive/Products/Library/Frameworks/#{module_name}.framework"
        end
  
        def self.ios_sim_framework_build_path(module_name)
          ".build/#{module_name}-ios_sim.xcarchive/Products/Library/Frameworks/#{module_name}.framework"
        end
  
        #####################################################
        # @!group Documentation
        #####################################################
  
        def self.description
          "Creates xcframework from xcode project"
        end
  
        def self.available_options
          [
            FastlaneCore::ConfigItem.new(key: :scheme_name,
                                         description: 'Name of the scheme to be built',
                                         optional: false,
                                         is_string: true),
  
            FastlaneCore::ConfigItem.new(key: :module_name,
                                         description: 'Name of the module (if different from scheme name)',
                                         optional: true,
                                         is_string: true),
  
            FastlaneCore::ConfigItem.new(key: :output_dir_path,
                                         description: 'Xcframework output directory path',
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
  