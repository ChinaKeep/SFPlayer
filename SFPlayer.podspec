Pod::Spec.new do |s|
  s.name             = 'SFPlayer'
  s.version          = '1.0.0'
  s.summary          = 'A lightweight custom video player based on AVFoundation.'
  s.description      = <<-DESC
SFPlayer is a simple and customizable video player component for iOS projects.
  DESC
  s.homepage         = 'https://github.com/ChinaKeep/SFPlayer'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Keep' => 'keep@example.com' }
  s.source           = { :git => 'https://github.com/ChinaKeep/SFPlayer.git', :tag => s.version.to_s }

  s.platform         = :ios, '12.0'
  s.requires_arc     = true

  # Package only the reusable player module, excluding demo app code.
  s.source_files         = 'SFPlayer/SFVideoPlayer/**/*.{h,m}'
  s.public_header_files  = 'SFPlayer/SFVideoPlayer/SFPlayer.h'
  s.resources            = ['SFPlayer/SFVideoPlayer/ImageResources.bundle']

  s.frameworks = 'UIKit', 'AVFoundation'
end
