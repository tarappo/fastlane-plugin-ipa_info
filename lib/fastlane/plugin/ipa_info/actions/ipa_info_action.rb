require 'json'

module Fastlane
  module Actions
    class IpaInfoAction < Action
      def self.run(params)
        @file = params[:ipa_file]
        UI.user_error!('You have to set path an ipa file') unless @file

        # result
        info_result = Helper::IpaAnalyzeHelper.analyze(@file)

        # show build environment info
        rows = Helper::IpaInfoHelper.build_environment_information(ipa_info_result: info_result[:plist_info])
        summary_table = Helper::IpaInfoHelper.summary_table(title: "Build Environment", rows: rows)
        puts(summary_table)

        # show ipa info
        rows = Helper::IpaInfoHelper.ipa_information(ipa_info_result: info_result[:plist_info])
        summary_table = Helper::IpaInfoHelper.summary_table(title: "ipa Information", rows: rows)
        puts(summary_table)

        # show customize info extract Info.plist
        unless params[:add_extract_info_plist_params].empty?
          rows = Helper::IpaInfoHelper.customize_information(ipa_info_result: info_result[:plist_info], add_extract_info_plist_params: params[:add_extract_info_plist_params])
          summary_table = Helper::IpaInfoHelper.summary_table(title: "Info.plist Information", rows: rows)
          puts(summary_table)
        end

        # mobile provisioning info
        rows = Helper::IpaInfoHelper.mobileprovisioning_information(provision_info_result: info_result[:provisiong_info])
        summary_table = Helper::IpaInfoHelper.summary_table(title: "Mobile Provision", rows: rows)
        puts(summary_table)

        # certificate info
        rows = Helper::IpaInfoHelper.certificate_information(certificate_info_result: info_result[:certificate_info])
        summary_table = Helper::IpaInfoHelper.summary_table(title: "Certificate", rows: rows)
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
                                         end),
            FastlaneCore::ConfigItem.new(key: :add_extract_info_plist_params,
                                         env_name: 'ADD_EXTRACT_INFO_PLIST_PARAMS',
                                         description: 'extract customize params for Info.plist. ',
                                         default_value: [],
                                         is_string: false,
                                         optional: true)
        ]
      end

      def self.is_supported?(platform)
        [:ios].include?(platform)
      end
    end
  end
end
