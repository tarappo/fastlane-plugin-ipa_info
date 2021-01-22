# ipa_info plugin

[![fastlane Plugin Badge](https://rawcdn.githack.com/fastlane/fastlane/master/fastlane/assets/plugin-badge.svg)](https://rubygems.org/gems/fastlane-plugin-ipa_info) [![CircleCI](https://circleci.com/gh/tarappo/fastlane-plugin-ipa_info.svg?style=svg)](https://circleci.com/gh/tarappo/fastlane-plugin-ipa_info)

## Getting Started

This project is a [_fastlane_](https://github.com/fastlane/fastlane) plugin. To get started with `fastlane-plugin-ipa_info`, add it to your project by running:

```bash
fastlane add_plugin ipa_info
```

## About ipa_info
show the Provisioning Profile and Certificate information in the ipa file.

## Action

```
ipa_info(
  ipa_file: ${your_ipa_file_path}
)
```

```
lane :build do
  gym
  ipa_info  
end
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
+------------+-----------------------------------+
|               Build Environment                |
+------------+-----------------------------------+
| Name       | Value                             |
+------------+-----------------------------------+
| Xcode      | 0941                              |
| XcodeBuild | 9F2000                            |
| MacOS      | macOS High Sierra 10.13.5 (17F77) |
+------------+-----------------------------------+

+--------------+-------+
|   ipa Information    |
+--------------+-------+
| Name         | Value |
+--------------+-------+
| BundleName   | sample|
| Version      | 1.2.0 |
| BuildVersion | 37    |
+--------------+-------+

+-------------------------+---------------------------+
|                  Mobile Provision                   |
+-------------------------+---------------------------+
| Name                    | Value                     |
+-------------------------+---------------------------+
| TeamName                | Your Team Name            |
| ProvisioningProfileName | Your Prifle Name          |
| ExpirationDate          | 2019-03-08T00:11:53+00:00 |
| DeadLine                | 230 day                   |
+-------------------------+---------------------------+

+------------+-------+
|    Certificate     |
+------------+-------+
| Name       | Value |
+------------+-------+
| CodeSigned | true  |
+------------+-------+
```

### Environment
All values are set in environment variables.

 - FL_XCODE
 - FL_XCODEBUILD
 - FL_MACOS
 - FL_BUNDLENAME
 - FL_VERSION
 - FL_BUILDVERSION
 - FL_TEAMNAME
 - FL_PROVISIONINGPROFILENAME
 - FL_COUNT_DAY
 - FL_CODESIGNED


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
