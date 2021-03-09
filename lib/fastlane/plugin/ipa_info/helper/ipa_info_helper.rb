require 'fastlane_core/ui/ui'
require 'mac_ios_info'

module Fastlane
  module Helper
    class IpaInfoHelper
      # build environment
      def self.build_environment_information(ipa_info_result:)
        rows = []
        list = [%w[DTXcode Xcode],
                %w[DTXcodeBuild XcodeBuild]]

        list.each do |key, name|
          ENV["FL_#{name.upcase}"] = ipa_info_result[key]
          rows << [name, ipa_info_result[key]]
        end

        # add os name and version
        [%w[BuildMachineOSBuild MacOS]].each do |key, name|
          mac_os_build = ipa_info_result[key]

          mac_os_version = MacIosInfo.macos_build_to_macos_version(build_number: mac_os_build)
          mac_os_name = MacIosInfo.macos_version_to_os_name(version: mac_os_version)
          rows << [name, "#{mac_os_name} #{mac_os_version} (#{mac_os_build})"]
        end

        rows
      end

      # ipa info
      def self.ipa_information(ipa_info_result:)
        rows = []
        list = [%w[CFBundleName BundleName],
                %w[CFBundleShortVersionString Version],
                %w[CFBundleVersion BuildVersion]]

        list.each do |key, name|
          next if key.nil?
          next if ipa_info_result[key].nil?
          ENV["FL_#{name.upcase}"] = ipa_info_result[key]

          rows << [name, ipa_info_result[key]]
        end

        rows
      end

      # customize info
      # @param add_extract_info_plist_params Info.plist key and display name
      # example: [[ "CFBundleIdentifier", "BundleIdentifier" ]]
      def self.customize_information(ipa_info_result:, add_extract_info_plist_params: nil)
        rows = []

        add_extract_info_plist_params.each do |key, name|
          next if key.nil?
          next if ipa_info_result[key].nil?
          ENV["FL_#{name.upcase}"] = ipa_info_result[key]

          rows << [name, ipa_info_result[key]]
        end

        rows
      end

      # certificate info
      def self.certificate_information(certificate_info_result:)
        rows = []
        [%w[CodeSigned CodeSigned]].each do |key, name|
          ENV["FL_#{name.upcase}"] = certificate_info_result[key].to_s

          rows << [name, certificate_info_result[key].to_s]
        end

        rows
      end

      # mobileprovisioning info
      def self.mobileprovisioning_information(provision_info_result:)
        rows = []
        [%w[TeamName TeamName],
         %w[Name ProvisioningProfileName]].each do |key, name|
          ENV["FL_#{name.upcase}"] = provision_info_result[key]
          rows << [name, provision_info_result[key]]
        end

        # change expire date
        [%w[ExpirationDate ExpirationDate]].each do |key, name|
          today = Date.today()
          expire_date = Date.parse(provision_info_result[key].to_s)
          count_day = (expire_date - today).numerator

          ENV["FL_#{name.upcase}"] = provision_info_result[key]
          ENV["FL_COUNT_DAY"] = count_day.to_s

          rows << [name, provision_info_result[key]]
          rows << ["DeadLine", "#{count_day} day"]
        end

        rows
      end

      # create summary table
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
