# Using XcodeGen to generate xcodeproj

When should you use it? If you are making changes to the structure of the files (adding or removing files) in the project make sure to run xcodegen to generate an updated Xcode Project (OHMySQL.xcodeproj) in the root directoy of the repo. This ensures that `Carthage` can fetch and use latests version.

1. Install [XcodeGen](https://github.com/yonaskolb/XcodeGen#installing)
2. Run `xcodegen generate` in the root of the project.
3. Commit updated `OHMySQL.xcodeproj`.

## More information

Check `project.yml` to see how XcodeGen generates the project.
