require 'tempfile'
require 'zip'
require 'zip/filesystem'
require 'plist'
require 'fastlane_core/ui/ui'

module Fastlane
  module Helper
    class IpaAnalyzeHelper
      def self.analyze(ipa_path)
        ipa_zipfile = Zip::File.open(ipa_path)
        app_folder_path = find_app_folder_path_in_ipa(ipa_path)
        ipa_zipfile.close

        # path
        mobileprovision_entry = ipa_zipfile.find_entry("#{app_folder_path}/embedded.mobileprovision")
        UI.user_error!("mobileprovision not found in #{ipa_path}") unless mobileprovision_entry
        info_plist_entry = ipa_zipfile.find_entry("#{app_folder_path}/Info.plist")
        UI.user_error!("Info.plist not found in #{ipa_path}") unless info_plist_entry

        return {
            :provisiong_info => self.analyze_mobileprovisioning(mobileprovision_entry, ipa_zipfile),
            :plist_info => self.analyze_info_plist(info_plist_entry, ipa_zipfile)
        }
      end

      # Info plist
      def self.analyze_info_plist(info_plist_entry, ipa_zipfile)
        result = {}

        tempfile = Tempfile.new(::File.basename(info_plist_entry.name))
        begin
          ipa_zipfile.extract(info_plist_entry, tempfile.path) { true }
          UI.user_error!("Failed to convert binary Plist to XML") unless system("plutil -convert xml1 '#{tempfile.path}'")

          plist = Plist.parse_xml(tempfile.path)

          plist.each do |key, value|
            parse_value = value.class == Hash || value.class == Array ? value : value.to_s

            result[key] = parse_value
          end
        rescue StandardError => e
          UI.user_error!(e.message)
        ensure
          tempfile.close && tempfile.unlink
        end
        return result
      end

      # mobileprovisioning
      def self.analyze_mobileprovisioning(mobileprovision_entry, ipa_zipfile)
        result = {}

        tempfile = Tempfile.new(::File.basename(mobileprovision_entry.name))
        begin
          ipa_zipfile.extract(mobileprovision_entry, tempfile.path) { true }
          plist = Plist.parse_xml(`security cms -D -i #{tempfile.path}`)

          plist.each do |key, value|
            next if key == 'DeveloperCertificates'

            parse_value = value.class == Hash || value.class == Array ? value : value.to_s

            result[key] = parse_value
          end
        rescue StandardError => e
          UI.user_error!(e.message)
        ensure
          tempfile.close && tempfile.unlink
        end
        return result
      end

      private
      # return app folder path
      def self.find_app_folder_path_in_ipa(ipa_path)
        return "Payload/#{File.basename(ipa_path, File.extname(ipa_path))}.app"
      end
    end
  end
end
