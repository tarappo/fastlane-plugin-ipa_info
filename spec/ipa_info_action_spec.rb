describe Fastlane::Actions::IpaInfoAction do
  describe '#run' do
    it "throws exception" do
      expect do
        Fastlane::FastFile.new.parse("lane :test do ipa_info end").runner.execute(:test)
      end.to raise_error(FastlaneCore::Interface::FastlaneError, 'You have to set path an ipa file')
    end
  end
end
