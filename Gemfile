source('https://rubygems.org')

gemspec

plugins_path = File.join(File.dirname(__FILE__), 'fastlane', 'Pluginfile')
eval_gemfile(plugins_path) if File.exist?(plugins_path)


gem "ipa_analyzer", :git => "git@github.com:bitrise-io/ipa_analyzer.git"
