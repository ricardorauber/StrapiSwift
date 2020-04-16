Pod::Spec.new do |s|
  s.name = 'Strapi-iOS'
  s.version = '0.1.1'
  s.license = 'MIT'
  s.summary = 'Swift package to connect with a Strapi service'
  s.homepage = 'https://github.com/ricardorauber/strapi-ios'
  s.authors = { 'Ricardo Rauber' => 'ricardorauber@gmail.com' }
  s.source = { :git => 'https://github.com/ricardorauber/strapi-ios.git', :tag => s.version }
  s.source_files = 'Strapi/**/*.swift'
  s.ios.deployment_target = '12.4'
  s.swift_versions = ['5.0', '5.1']
  s.deprecated = true
  s.deprecated_in_favor_of = 'StrapiSwift'
end
