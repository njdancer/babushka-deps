dep 'Parallels Desktop.app' do
  source 'http://www.parallels.com/products/desktop/download/dr/'
end

dep 'Skype.app' do
  source 'http://skype.com/go/getskype-macosx'
end

dep 'Dropbox.app' do
  source 'http://cdn.dropbox.com/Dropbox%201.2.49.dmg'
end

dep '1Password.app' do
  source 'https://d13itkw33a7sus.cloudfront.net/dist/1P/mac/1Password-3.8.12.zip'
end

dep 'TextMate.app' do
  requires 'textmate helper'
  source 'http://download.macromates.com/TextMate_1.5.10.zip'
end

dep 'textmate helper' do
  met? { which 'mate' }
  meet { shell "ln -sf '#{app_dir('TextMate.app') / 'Contents/SharedSupport/Support/bin/mate'}' /usr/local/bin/mate" }
end

dep 'JewelryBox.app' do
  source L { "http://jewelrybox.unfiniti.com/download/JewelryBox_v#{version}.tar.bz2" }
  latest_version { '1.4.1' }
  current_version { |path| bundle_version(path, 'CFBundleVersion') }
end

dep 'Transmission.app' do
 source 'http://download.transmissionbt.com/files/Transmission-2.13.dmg'
end
