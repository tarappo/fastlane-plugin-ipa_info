require 'tempfile'
require 'tmpdir'
require 'fileutils'
require 'plist'
require 'open3'
require 'fastlane_core/ui/ui'

module Fastlane
  module Helper
    class IpaAnalyzeHelper
      def self.analyze(ipa_path)
        app_folder_path = find_app_folder_path_in_ipa(ipa_path)
        plist_data = self.fetch_file_with_unzip(ipa_path, "#{app_folder_path}/Info.plist")
        mobileprovisioning_data = self.fetch_file_with_unzip(ipa_path, "#{app_folder_path}/embedded.mobileprovision")

        return {
            provisiong_info: self.analyze_mobileprovisioning(mobileprovisioning_data),
            plist_info: self.analyze_info_plist(plist_data),
            certificate_info: self.codesigned(ipa_path, app_folder_path)
        }
      end

      # Info plist
      def self.analyze_info_plist(data)
        tempfile = Tempfile.new(::File.basename("info_plist"))
        result = {}

        begin
          File.open(tempfile.path, 'w') do |output|
            output.puts(data)
          end
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

        result
      end

      # mobileprovisioning
      def self.analyze_mobileprovisioning(data)
        tempfile = Tempfile.new(::File.basename("mobile_provisioning"))
        result = {}

        begin
          File.open(tempfile.path, 'w') do |output|
            output.puts(data)
          end
          mobileprovisioning = Plist.parse_xml(`security cms -D -i #{tempfile.path}`)
          mobileprovisioning.each do |key, value|
            next if key == 'DeveloperCertificates'

            parse_value = value.class == Hash || value.class == Array ? value : value.to_s

            result[key] = parse_value
          end
        rescue StandardError => e
          UI.user_error!(e.message)
        ensure
          tempfile.close && tempfile.unlink
        end

        result
      end

      # certificate
      def self.codesigned(ipa_path, app_folder_path)
        tempdir = Dir.pwd + "/tmp"
        result = {}

        begin
          _, error, = Open3.capture3("unzip -d #{tempdir} #{ipa_path}")
          UI.user_error!(error) unless error.empty?

          cmd = "codesign -dv #{tempdir}/#{app_folder_path}"
          _stdout, stderr, _status = Open3.capture3(cmd)
          codesigned_flag = stderr.include?("Signed Time")
          result["CodeSigned"] = codesigned_flag
        rescue StandardError => e
          UI.user_error!(e.message)
        ensure
          FileUtils.rm_r(tempdir)
        end

        return result
      end

      # extract file
      def self.fetch_file_with_unzip(path, target_file)
        list, error, = Open3.capture3("unzip", "-Z", "-1", path)
        UI.user_error!(error) unless error.empty?

        return nil if list.empty?
        entry = list.chomp.split("\n").find do |e|
          File.fnmatch(target_file, e, File::FNM_PATHNAME)
        end

        data, error, = Open3.capture3("unzip", "-p", path, entry)
        UI.user_error!(error) unless error.empty?
        UI.user_error!("not exits data for #{target_file}") if data.empty?

        data
      end

      # return app folder path
      def self.find_app_folder_path_in_ipa(ipa_path)
        return "Payload/#{File.basename(ipa_path, File.extname(ipa_path))}.app"
      end

      private_class_method :find_app_folder_path_in_ipa
    end
  end
end
