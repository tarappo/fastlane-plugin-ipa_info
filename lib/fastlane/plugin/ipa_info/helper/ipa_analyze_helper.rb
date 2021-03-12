require 'tempfile'
require 'tmpdir'
require 'fileutils'
require 'plist'
require 'open3'
require 'fastlane_core/ui/ui'
require "securerandom"

module Fastlane
  module Helper
    class IpaAnalyzeHelper
      def self.analyze(ipa_path)
        return {
            provisiong_info: self.analyze_file_with_unzip(ipa_path, "embedded.mobileprovision"),
            plist_info: self.analyze_file_with_unzip(ipa_path, "Info.plist"),
            certificate_info: analyze_file_with_unzip(ipa_path, "")
        }
      end

      # Info plist
      def self.analyze_info_plist(tempfile)
        result = {}

        begin
          UI.user_error!("Failed to convert binary Plist to XML") unless system("plutil -convert xml1 '#{tempfile}'")

          plist = Plist.parse_xml(tempfile)
          plist.each do |key, value|
            parse_value = value.class == Hash || value.class == Array ? value : value.to_s

            result[key] = parse_value
          end
        rescue StandardError => e
          UI.user_error!(e.message)
        ensure
          FileUtils.rm_r(tempfile)
        end

        result
      end

      # mobileprovisioning
      def self.analyze_mobileprovisioning(tempfile)
        result = {}

        begin
          mobileprovisioning = Plist.parse_xml(`security cms -D -i #{tempfile}`)
          mobileprovisioning.each do |key, value|
            next if key == 'DeveloperCertificates'

            parse_value = value.class == Hash || value.class == Array ? value : value.to_s

            result[key] = parse_value
          end
        rescue StandardError => e
          UI.user_error!(e.message)
        ensure
          FileUtils.rm_r(tempfile)
        end

        result
      end

      # certificate
      def self.codesigned(temp_file_path)
        result = {}

        cmd = "codesign -dv #{temp_file_path}"
        _stdout, stderr, _status = Open3.capture3(cmd)
        codesigned_flag = stderr.include?("Signed Time")
        result["CodeSigned"] = codesigned_flag

        return result
      end

      # unzip ipa file and analyze file
      def self.analyze_file_with_unzip(ipa_path, target_file_name)
        tempdir = Dir.pwd + "/tmp-#{SecureRandom.hex(10)}"
        target_file_path = find_app_folder_path_in_ipa(ipa_path) + "/#{target_file_name}"
        temp_file_path = "#{tempdir}/#{target_file_name}"

        begin
          _, error, = Open3.capture3("unzip -o -d #{tempdir} #{ipa_path}")
          UI.user_error!(error) unless error.empty?

          copy_cmd = "#{tempdir}/#{target_file_path} #{temp_file_path}"

          case target_file_name
          when "Info.plist" then
            self.copy_file(copy_cmd)
            return self.analyze_info_plist(temp_file_path)
          when "embedded.mobileprovision" then
            self.copy_file(copy_cmd)
            return self.analyze_mobileprovisioning(temp_file_path)
          when "" then
            return self.codesigned(target_file_path)
          end
        rescue StandardError => e
          FileUtils.rm_r(tempdir)
          UI.user_error!(e.message)
        ensure
          FileUtils.rm_r(tempdir)
        end

        return nil
      end

      # copy
      def self.copy_file(cmd)
        cmd = "cp #{cmd}"
        _, error, = Open3.capture3(cmd)
        UI.user_error!(error) unless error.empty?
      end

      # return app folder path
      def self.find_app_folder_path_in_ipa(ipa_path)
        return "Payload/*.app"
      end

      private_class_method :find_app_folder_path_in_ipa
    end
  end
end
