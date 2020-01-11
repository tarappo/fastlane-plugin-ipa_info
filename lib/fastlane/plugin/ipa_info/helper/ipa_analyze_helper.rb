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
        app_folder_path = find_app_folder_in_ipa(ipa_path, ipa_zipfile)
        ipa_zipfile.close

        mobileprovision_path = "#{app_folder_path}/embedded.mobileprovision"
        mobileprovision_entry = ipa_zipfile.find_entry(mobileprovision_path)
        info_plist_entry = ipa_zipfile.find_entry("#{app_folder_path}/Info.plist")

        UI.user_error!("Info.plist not found in #{ipa_path}") unless info_plist_entry

        return {
            :provisiong_info => self.analyze_mobileprovisioning(mobileprovision_entry, ipa_zipfile),
            :plist_info => self.analyze_info_plist(info_plist_entry, ipa_zipfile)
        }
      end

      def self.analyze_info_plist(info_plist_entry, ipa_zipfile)
        result = {
            path_in_ipa: info_plist_entry.to_s,
            content: {}
        }

        tempfile = Tempfile.new(::File.basename(info_plist_entry.name))
        begin
          ipa_zipfile.extract(info_plist_entry, tempfile.path) { true }
          # convert from binary Plist to XML Plist
          UI.user_error!("Failed to convert binary Plist to XML") unless system("plutil -convert xml1 '#{tempfile.path}'")

          plist = Plist.parse_xml(tempfile.path)

          plist.each do |key, value|
            parse_value = value.class == Hash || value.class == Array ? value : value.to_s

            result[:content][key] = parse_value
          end
        rescue StandardError => e
          puts e.message
          result = nil
        ensure
          tempfile.close && tempfile.unlink
        end
        puts(result)
        return result
      end

      def self.analyze_mobileprovisioning(mobileprovision_entry, ipa_zipfile)
        result = {
            path_in_ipa: mobileprovision_entry.to_s,
            content: {}
        }

        tempfile = Tempfile.new(::File.basename(mobileprovision_entry.name))
        begin
          ipa_zipfile.extract(mobileprovision_entry, tempfile.path) { true }
          plist = Plist.parse_xml(`security cms -D -i #{tempfile.path}`)

          plist.each do |key, value|
            next if key == 'DeveloperCertificates'

            parse_value = value.class == Hash || value.class == Array ? value : value.to_s

            result[:content][key] = parse_value
          end
        rescue StandardError => e
          puts e.message
          result = nil
        ensure
          tempfile.close && tempfile.unlink
        end
        return result
      end

      private
      #
      # Find the .app folder which contains both the "embedded.mobileprovision"
      # and "Info.plist" files.
      def self.find_app_folder_in_ipa(ipa_path, ipa_zipfile)
        app_folder_in_ipa = "Payload/#{File.basename(ipa_path, File.extname(ipa_path))}.app"
        info_plist_entry = ipa_zipfile.find_entry("#{app_folder_in_ipa}/Info.plist")

        return app_folder_in_ipa if !info_plist_entry.nil?

        ipa_zipfile.dir.entries('Payload').each do |dir_entry|
          next unless dir_entry =~ /.app$/

          app_folder_in_ipa = "Payload/#{dir_entry}"
          info_plist_entry = ipa_zipfile.find_entry("#{app_folder_in_ipa}/Info.plist")

          break if !info_plist_entry.nil?
        end

        UI.user_error!('No app folder found in the ipa file') if !info_plist_entry.nil?

        return app_folder_in_ipa
      end
    end
  end
end
