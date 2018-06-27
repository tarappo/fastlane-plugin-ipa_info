require 'fastlane_core/ui/ui'

module Fastlane
  UI = FastlaneCore::UI unless Fastlane.const_defined?("UI")

  module Helper
    class IpaInfoHelper
      def self.info_plist

      end
    end
  end
end
