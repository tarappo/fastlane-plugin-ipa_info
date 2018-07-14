require 'fastlane_core/ui/ui'

module Fastlane
  module Helper
    class IpaInfoHelper
      def self.macos_build_to_macos_version(build:)
        # reference https://support.apple.com/ja-jp/HT201260
        case build
        when "17F77" then
          "10.13.5"
        when "17E199", "17E201" then
          "10.13.4"
        when "17D47", "17D102", "17D2047", "17D2102" then
          "10.13.3"
        when "17C88", "17C89", "17C205", "17C2205" then
          "10.13.2"
        when "17B48", "17B1002", "17B1003" then
          "10.13.1"
        when "17A365", "17A405" then
          "10.13"
        end

      end
    end
  end
end
