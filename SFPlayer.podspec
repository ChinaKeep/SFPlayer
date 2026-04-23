Pod::Spec.new do |s|
  s.name             = 'SFPlayer'
  s.version          = '1.0.2'
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
  s.frameworks       = 'UIKit', 'AVFoundation'
  s.default_subspecs = 'Core', 'Container'

  s.subspec 'UI' do |ui|
    ui.source_files = [
      'SFPlayer/SFVideoPlayer/SFSlider.{h,m}',
      'SFPlayer/SFVideoPlayer/SFBottonBarView.{h,m}'
    ]
    ui.public_header_files = [
      'SFPlayer/SFVideoPlayer/SFSlider.h',
      'SFPlayer/SFVideoPlayer/SFBottonBarView.h'
    ]
  end

  s.subspec 'Core' do |core|
    core.dependency 'SFPlayer/UI'
    core.source_files = [
      'SFPlayer/SFVideoPlayer/SFPlayer.{h,m}',
      'SFPlayer/SFVideoPlayer/SFPlayerConfiguration.{h,m}',
      'SFPlayer/SFVideoPlayer/SFPlayerController.{h,m}',
      'SFPlayer/SFVideoPlayer/SFPlayerComponentProtocols.h',
      'SFPlayer/SFVideoPlayer/SFPlayerKit.h'
    ]
    core.public_header_files = [
      'SFPlayer/SFVideoPlayer/SFPlayer.h',
      'SFPlayer/SFVideoPlayer/SFPlayerConfiguration.h',
      'SFPlayer/SFVideoPlayer/SFPlayerController.h',
      'SFPlayer/SFVideoPlayer/SFPlayerComponentProtocols.h',
      'SFPlayer/SFVideoPlayer/SFPlayerKit.h'
    ]
    core.resources = ['SFPlayer/SFVideoPlayer/ImageResources.bundle']
  end

  s.subspec 'Container' do |container|
    container.dependency 'SFPlayer/Core'
    container.dependency 'SDWebImage', '>= 5.8'
    container.source_files = [
      'SFPlayer/SFVideoPlayer/SFVideoModel.{h,m}',
      'SFPlayer/SFVideoCell.{h,m}'
    ]
    container.public_header_files = [
      'SFPlayer/SFVideoPlayer/SFVideoModel.h',
      'SFPlayer/SFVideoCell.h'
    ]
  end

end
