describe Fastlane::Actions::IpaInfoAction do
  describe '#run' do
    it "throws exception" do
      expect do
        Fastlane::FastFile.new.parse("lane :test_without_params do ipa_info end").runner.execute(:test_without_params)
      end.to raise_error(FastlaneCore::Interface::FastlaneError, 'You have to set path an ipa file')
    end
  end

  describe 'IpaInfoHelper' do
    it "build_environment_information" do
      info = {
          "DTXcode" => "1203",
          "DTXcodeBuild" => "10B61",
          "BuildMachineOSBuild" => "20D80"
      }
      actual_info = Fastlane::Helper::IpaInfoHelper.build_environment_information(ipa_info_result: info)

      expected_info = [["Xcode", "1203"], ["XcodeBuild", "10B61"], ["MacOS", "macOS Big Sur 11.2.2 (20D80)"]]
      expect(actual_info).to eq(expected_info)
    end

    it "ipa_information" do
      info = {
          "CFBundleName" => "Sample",
          "CFBundleShortVersionString" => "1.0.0",
          "CFBundleVersion" => "123"
      }
      actual_info = Fastlane::Helper::IpaInfoHelper.ipa_information(ipa_info_result: info)

      expected_info = [["BundleName", "Sample"], ["Version", "1.0.0"], ["BuildVersion", "123"]]
      expect(actual_info).to eq(expected_info)
    end

    it "ipa_information using add_extract_info_plist_params" do
      info = {
          "CFBundleName" => "Sample",
          "CFBundleShortVersionString" => "1.0.0",
          "CFBundleVersion" => "123",
          "CFSampleKey" => "SampleData"
      }
      params = [%w[CFSampleKey SampleKey], %w[CFNothingKey NothingData]]
      actual_info = Fastlane::Helper::IpaInfoHelper.customize_information(ipa_info_result: info, add_extract_info_plist_params: params)

      expected_info = [["SampleKey", "SampleData"]]
      expect(actual_info).to eq(expected_info)
    end
  end
end
