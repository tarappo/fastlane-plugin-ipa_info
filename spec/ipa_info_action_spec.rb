describe Fastlane::Actions::IpaInfoAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The ipa_info plugin is working!")

      Fastlane::Actions::IpaInfoAction.run(nil)
    end
  end
end
