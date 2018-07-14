require 'fastlane_core/ui/ui'

module Fastlane
  module Helper
    class IpaInfoHelper
      def self.macos_build_to_macos_version(build:)
        # reference https://support.apple.com/ja-jp/HT201260
        case build
        # macOS High Sierra
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
        # macOS Sierra
        when "16G29", "16G1036", "16G1114", "16G1212" then
          "10.12.6"
        when "16F73" then
          "10.12.5"
        when "16E195" then
          "10.12.4"
        when "16D32" then
          "10.12.3"
        when "16C67" then
          "10.12.2"
        when "16B2555", "16B2557" then
          "10.12.1"
        when "16A323" then
          "10.12.1"
        end
      end

      def self.macos_version_to_os_name(version:)
        minor_version = version.split(".")[1].to_i
        # reference https://support.apple.com/ja-jp/HT201260
        case minor_version
        when 13
          "macOS High Sierra"
        when 12
          "macOS Sierra"
        end
      end

    end
  end
end
