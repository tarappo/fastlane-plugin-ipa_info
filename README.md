# ipa_info plugin

[![fastlane Plugin Badge](https://rawcdn.githack.com/fastlane/fastlane/master/fastlane/assets/plugin-badge.svg)](https://rubygems.org/gems/fastlane-plugin-ipa_info) [![CircleCI](https://circleci.com/gh/tarappo/fastlane-plugin-ipa_info.svg?style=svg)](https://circleci.com/gh/tarappo/fastlane-plugin-ipa_info)

## Getting Started

This project is a [_fastlane_](https://github.com/fastlane/fastlane) plugin. To get started with `fastlane-plugin-ipa_info`, add it to your project by running:

```bash
fastlane add_plugin ipa_info
```

## About ipa_info

show information of the info.plist file in the ipa file.

## Action

```
ipa_info(
  ipa_file: ${your_ipa_file_path}
)
```

```
+----------+------------------+----------+---------+
|                 ipa_info Options                 |
+----------+------------------+----------+---------+
| Key      | Description      | Env Var  | Default |
+----------+------------------+----------+---------+
| ipa_file | Path to your     | IPA_FILE |         |
|          | ipa file.        |          |         |
|          | Optional if you  |          |         |
|          | use the `gym`,   |          |         |
|          | `ipa` or         |          |         |
|          | `xcodebuild`     |          |         |
|          | action.          |          |         |
+----------+------------------+----------+---------+
```

### Example Result

```
+------------+--------+
|     Info.Plist      |
+------------+--------+
| Name       | Value  |
+------------+--------+
| Xcode      | 0941   |
| Build      | 9F2000 |
| MacOSBuild | 17F77  |
+------------+--------+
```

## Run tests for this plugin

To run both the tests, and code style validation, run

```
rake
```

To automatically fix many of the styling issues, use
```
rubocop -a
```

## Issues and Feedback

For any other issues and feedback about this plugin, please submit it to this repository.

## Troubleshooting

If you have trouble using plugins, check out the [Plugins Troubleshooting](https://docs.fastlane.tools/plugins/plugins-troubleshooting/) guide.

## Using _fastlane_ Plugins

For more information about how the `fastlane` plugin system works, check out the [Plugins documentation](https://docs.fastlane.tools/plugins/create-plugin/).

## About _fastlane_

_fastlane_ is the easiest way to automate beta deployments and releases for your iOS and Android apps. To learn more, check out [fastlane.tools](https://fastlane.tools).
