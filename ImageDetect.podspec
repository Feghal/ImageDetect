#
# Be sure to run `pod lib lint ImageDetect.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ImageDetect'
  s.version          = '1.1.0'
  s.summary          = 'With ImageDetect you can easily detect and crop faces, texts or barcodes in your image.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
ImageDetect is a library developed on Swift. With ImageDetect you can easily detect and crop faces, texts or barcodes in your image with iOS 11 Vision api.
                       DESC

  s.homepage         = 'https://github.com/Feghal/ImageDetect'
  s.summary          = 'Crop faces, inside of your image, with Vision Api'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Arthur Sahakyan' => 'feghaldev@gmail.com' }
  s.source           = { :git => 'https://github.com/Feghal/ImageDetect.git', :tag => s.version.to_s }

  s.source_files = 'ImageDetect/Classes/**/*'

  s.ios.deployment_target = '11.0'
  s.frameworks = 'UIKit', 'Vision'
end
