Pod::Spec.new do |s|

  s.name         = "Listenable"
  s.platform     = :ios, "9.0"
  s.requires_arc = true

  s.version      = "0.0.1"
  s.summary      = "TODO"
  s.description  = <<-DESC
                        TODO
                     DESC

  s.homepage     = "https://github.com/MerrickSapsford/Pageboy"
  #s.screenshots  = "https://raw.githubusercontent.com/MerrickSapsford/MSSTabbedPageViewController/develop/Resource/MSSTabbedPageViewController.gif"
  s.license      = "MIT"
  s.author       = { "Merrick Sapsford" => "merrick@sapsford.tech" }
  s.social_media_url   = "http://twitter.com/MerrickSapsford"

  s.source       = { :git => "https://github.com/MerrickSapsford/Listenable.git", :tag => s.version.to_s }
  s.source_files  = "./Source/Listenable/**/*.{h,m,swift}"

end
