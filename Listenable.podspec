Pod::Spec.new do |s|

  s.name         = "Listenable"
  s.platform     = :ios, "9.0"
  s.requires_arc = true

  s.version      = "1.0.0"
  s.summary      = "Observable pattern in Swift made easy"
  s.description  = <<-DESC
                        Swift object that provides an observable platform for multiple listeners.
                     DESC

  s.homepage     = "https://github.com/MerrickSapsford/Listenable"
  s.license      = "MIT"
  s.author       = { "Merrick Sapsford" => "merrick@sapsford.tech" }
  s.social_media_url   = "http://twitter.com/MerrickSapsford"

  s.source       = { :git => "https://github.com/MerrickSapsford/Listenable.git", :tag => s.version.to_s }
  s.source_files  = "Sources/Listenable/**/*.{h,m,swift}"

end
