Pod::Spec.new do |s|

  s.name                  = 'StrapiSwift'
  s.version               = '1.0.0'
  s.ios.deployment_target = '12.4'
  s.swift_versions        = ['5.0', '5.1', '5.2']
  s.author                = 'Ricardo Rauber Pereira'
  s.license               = 'MIT'
  s.homepage              = 'http://ricardorauber.com'
  s.source                = { :git => 'https://github.com/ricardorauber/StrapiSwift.git', :tag => s.version }
  s.summary               = 'A Swift toolkit to connect with your Strapi backend'
  s.pod_target_xcconfig   = { 'ENABLE_TESTABILITY' => 'YES' }
  s.source_files          = 'Classes/**/*'

  s.dependency 'RestService', '1.0.1'
  s.dependency 'KeyValueStorage', '1.0.0'

  s.test_spec 'Tests' do |test_spec|
    test_spec.requires_app_host = true
    test_spec.source_files      = 'Tests/**/*'

    test_spec.dependency 'Nimble', '8.0.7'
    test_spec.dependency 'OHHTTPStubs/Swift', '9.0.0'
    test_spec.dependency 'Quick',  '2.2.0'
  end
end
