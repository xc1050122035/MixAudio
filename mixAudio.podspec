Pod::Spec.new do |s|
  s.name     = 'mixAudio'
  s.version = "1.0.0"
  s.license  = 'MIT'
  s.summary  = 'mix audio'
  s.homepage = 'https://github.com/xc1050122035/MixAudio'
  s.social_media_url = 'http://weibo.com/in66com'
  s.authors  = { 'yangguang' => 'yangguang@in66.com' }
               s.source   = { :git => 'https://github.com/xc1050122035/MixAudio.git',:tag => '1.0.0'}
  s.requires_arc = true

  s.platform     = :ios
  s.platform     = :ios, "7.0"
  s.ios.deployment_target = '7.0'

  s.source_files = 'class/**/*.{h,m}'
end