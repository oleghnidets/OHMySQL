# Be sure to run `pod lib lint OHMySQL.podspec' to ensure this is a
# valid spec before submitting.

Pod::Spec.new do |spec|
  spec.name             = 'OHMySQL'
  spec.version          = '3.2.0'

  spec.summary          = 'The Objective-C wrapper for mysqlclient (MySQL C API)'
  spec.description      = <<-DESC
You can connect to your remote MySQL database using OHMySQL API. It allows you doing queries in easy and object-oriented way. Common queries such as SELECT, INSERT, DELETE, JOIN are wrapped by Objective-C code and you don't need to dive into MySQL C API.
                       DESC

  spec.documentation_url = 'https://oleghnidets.github.io/OHMySQL/documentation/ohmysql/'
  spec.homepage          = 'https://github.com/oleghnidets/OHMySQL'
  spec.license           = 'MIT'
  spec.authors           = { 'Oleg Hnidets' => 'oleg.oleksan@gmail.com' }

  spec.source           = { :git => 'https://github.com/oleghnidets/OHMySQL.git', :tag => spec.version.to_s }
  spec.ios.deployment_target = '14.0'
  spec.osx.deployment_target = '11.0'
  spec.watchos.deployment_target = '8.0'
  spec.tvos.deployment_target = '15.0'
  spec.requires_arc     = true 
  spec.source_files     = 'OHMySQL/Sources/**/*.{h,m}'
  spec.frameworks       = 'Foundation'
  spec.compiler_flags = '-Wno-incomplete-umbrella'
  spec.vendored_frameworks = 'OHMySQL/lib/MySQL.xcframework'
  spec.library = 'c++'
end
