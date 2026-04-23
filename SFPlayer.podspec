Pod::Spec.new do |s|
  s.name             = 'SFPlayer'
  s.version          = '1.0.3'
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
  s.module_name      = 'SFPlayer'
  s.frameworks       = 'UIKit', 'AVFoundation'
  s.default_subspecs = 'Core', 'Container'

  s.subspec 'UI' do |ui|
    ui.source_files = [
      'Sources/UI/SFSlider.{h,m}',
      'Sources/UI/SFBottonBarView.{h,m}'
    ]
    ui.public_header_files = [
      'Sources/UI/SFSlider.h',
      'Sources/UI/SFBottonBarView.h'
    ]
  end

  s.subspec 'Core' do |core|
    core.dependency 'SFPlayer/UI'
    core.source_files = [
      'Sources/Core/SFPlayer.{h,m}',
      'Sources/Core/SFPlayerConfiguration.{h,m}',
      'Sources/Core/SFPlayerController.{h,m}',
      'Sources/Core/SFPlayerComponentProtocols.h',
      'Sources/Core/SFPlayerKit.h'
    ]
    core.public_header_files = [
      'Sources/Core/SFPlayer.h',
      'Sources/Core/SFPlayerConfiguration.h',
      'Sources/Core/SFPlayerController.h',
      'Sources/Core/SFPlayerComponentProtocols.h',
      'Sources/Core/SFPlayerKit.h'
    ]
    core.resources = ['Sources/Resources/ImageResources.bundle']
  end

  s.subspec 'Container' do |container|
    container.dependency 'SFPlayer/Core'
    container.dependency 'SDWebImage', '>= 5.8'
    container.source_files = [
      'Sources/Container/SFVideoModel.{h,m}',
      'Sources/Container/SFVideoCell.{h,m}'
    ]
    container.resources = ['Sources/Container/SFVideoCell.xib']
    container.public_header_files = [
      'Sources/Container/SFVideoModel.h',
      'Sources/Container/SFVideoCell.h'
    ]
  end

end
