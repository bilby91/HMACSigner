Pod::Spec.new do |s|
  s.name             = "HMACSigner"
  s.version          = "0.1.0"
  s.summary          = "HMACSigner signs your requests using HMAC + SHA1. It was adesigned to work with ApiAuth."
  s.homepage         = "https://github.com/bilby91/HMACSigner"
  s.license          = 'MIT'
  s.author           = { "Martin Fernandez" => "me@bilby91.com" }
  s.source           = { :git => "https://github.com/bilby91/HMACSigner.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/bilby91'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes'
  s.public_header_files = 'Pod/Classes/**/*.h'
end
