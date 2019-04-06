Pod::Spec.new do |s|
  s.name = 'HiResMirroring'
  s.version = '1.0.0'
  s.license = 'MIT'
  s.summary = 'A framework for mirroring iPad App screens to external display at High Resolution.'
  s.homepage = 'https://github.com/watanabetoshinori/HiResMirroring'
  s.author = "Watanabe Toshinori"
  s.source = { :git => 'https://github.com/watanabetoshinori/HiResMirroring.git', :tag => s.version }

  s.frameworks = 'IOKit'
  
  s.ios.deployment_target = '12.0'

  s.source_files = 'Source/**/*.{h,m,swift}'
  s.resources = 'Source/**/*.{xib,storyboard}'

end
