require "ipa_analyzer"

module Fastlane
  module Actions
    class IpaInfoAction < Action
      def self.run(params)
        @file = params[:ipa_file]
        UI.user_error!('You have to set path an ipa file') unless @file

        begin
          ipa_info = IpaAnalyzer::Analyzer.new(@file)
          ipa_info.open!
          result = ipa_info.collect_info_plist_info[:content]
          ipa_info.close
        rescue e
          UI.user_error!(e.message)
        end

        rows = []
        # show original info
        [%w[DTXcode Xcode],
         %w[DTXcodeBuild XcodeBuild]].each do |key, name|
          rows << [name, result[key]]
        end

        # add os name and version
        [%w[BuildMachineOSBuild MacOS]].each do |key, name|
          mac_os_build = result[key]
          mac_os_version = Helper::IpaInfoHelper.macos_build_to_macos_version(build: mac_os_build)
          mac_os_name = Helper::IpaInfoHelper.macos_version_to_os_name(version: mac_os_version)
          rows << [name, "#{mac_os_name} #{mac_os_version} (#{mac_os_build})"]
        end


        summary_table = Terminal::Table.new(
            title: "Info.Plist",
            headings: ["Name", "Value"],
            rows: FastlaneCore::PrintTable.transform_output(rows)
        ).to_s
        puts(summary_table)
      end

      def self.description
        "Show information of an ipa file."
      end

      def self.authors
        ["tarappo"]
      end

      def self.return_value
      end

      def self.details
        "Show information of an ipa file."
      end

      def self.available_options
        [
            FastlaneCore::ConfigItem.new(key: :ipa_file,
                                         env_name: 'IPA_FILE',
                                         description: 'Path to your ipa file. Optional if you use the `gym`, `ipa` or `xcodebuild` action. ',
                                         default_value: Actions.lane_context[SharedValues::IPA_OUTPUT_PATH] || Dir['*.ipa'].last,
                                         optional: true,
                                         verify_block: proc do |value|
                                           raise "Couldn't find ipa file".red unless File.exist?(value)
                                         end)
        ]
      end

      def self.is_supported?(platform)
        [:ios].include?(platform)
      end
    end
  end
end
