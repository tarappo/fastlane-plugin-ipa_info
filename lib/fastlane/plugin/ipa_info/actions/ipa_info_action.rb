require 'fastlane/action'
require_relative '../helper/ipa_info_helper'

module Fastlane
  module Actions
    class IpaInfoAction < Action
      def self.run(params)
        UI.message("The ipa_info plugin is working!")
      end

      def self.description
        "show ipa info"
      end

      def self.authors
        ["tarappo"]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.details
        "show ipa info"
      end

      def self.available_options
        [
          # FastlaneCore::ConfigItem.new(key: :your_option,
          #                         env_name: "IPA_INFO_YOUR_OPTION",
          #                      description: "A description of your option",
          #                         optional: false,
          #                             type: String)
        ]
      end

      def self.is_supported?(platform)
        [ :ios ].include?(platform)
      end
    end
  end
end
