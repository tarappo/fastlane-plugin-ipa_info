require 'fastlane_core/ui/ui'

module Fastlane
  UI = FastlaneCore::UI unless Fastlane.const_defined?("UI")

  module Helper
    class IpaInfoHelper
      # class methods that you define here become available in your action
      # as `Helper::IpaInfoHelper.your_method`
      #
      def self.show_message
        UI.message("Hello from the ipa_info plugin helper!")
      end
    end
  end
end
