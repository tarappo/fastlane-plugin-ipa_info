require 'fastlane_core/ui/ui'

module Fastlane
  module Helper
    class IpaInfoHelper
      # build environment
      def self.build_environment_information(ipa_info_result:)
        rows = []
        [%w[DTXcode Xcode],
         %w[DTXcodeBuild XcodeBuild]].each do |key, name|
          rows << [name, ipa_info_result[key]]
        end

        # add os name and version
        [%w[BuildMachineOSBuild MacOS]].each do |key, name|
          mac_os_build = ipa_info_result[key]
          mac_os_version = self.macos_build_to_macos_version(build: mac_os_build)
          mac_os_name = self.macos_version_to_os_name(version: mac_os_version)
          rows << [name, "#{mac_os_name} #{mac_os_version} (#{mac_os_build})"]
        end

        rows
      end

      # ipa info
      def self.ipa_information(ipa_info_result:)
        rows = []
        [%w[CFBundleName BundleName],
         %w[CFBundleShortVersionString Version],
         %w[CFBundleVersion BuildVersion]].each do |key, name|
          rows << [name, ipa_info_result[key]]
        end

        rows
      end

      def self.certificate_information(provision_info_result:)
        rows = []
        [%w[TeamName TeamName],
         %w[Name ProvisioningProfileName]].each do |key, name|
          rows << [name, provision_info_result[key]]
        end

        # change expire date
        [%w[ExpirationDate ExpirationDate]].each do |key, name|
          today = Date.today()
          expire_date = Date.parse(provision_info_result[key].to_s)
          count_day = (expire_date - today).numerator

          rows << [name, provision_info_result[key]]
          rows << ["DeadLine", "#{count_day} day"]
        end

        rows
      end

      # macOS build number to macOS version
      # @return macOS version(Sierra, High Sierra only)
      def self.macos_build_to_macos_version(build:)
        # reference https://support.apple.com/ja-jp/HT201260
        case build
          #macOS Mojave
        when "18E226" then
          "10.14.4"
        when "18D42", "18D109" then
          "10.14.3"
        when "18C54" then
          "10.14.2"
        when "18B75" then
          "10.14.1"
        when "18A391" then
          "10.14"
          # macOS High Sierra
        when "17G65", "17G6029" then
          "10.13.6"
        when "17F77" then
          "10.13.5"
        when "17E199", "17E201", "17E202" then
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
        else
          "UnKnown"
        end
      end

      def self.macos_version_to_os_name(version:)
        minor_version = version.split(".")[1].to_i
        # reference https://support.apple.com/ja-jp/HT201260
        case minor_version
        when 14
          "macOS Mojave"
        when 13
          "macOS High Sierra"
        when 12
          "macOS Sierra"
        else
          "UnKnown"
        end
      end

      def self.summary_table(title:, rows:)
        Terminal::Table.new(
          title: title,
          headings: ["Name", "Value"],
          rows: FastlaneCore::PrintTable.transform_output(rows)
        ).to_s
      end
    end
  end
end
