latest_version = `/usr/bin/curl -s http://www.adobe.com/software/flash/about/ | /usr/bin/grep -A2 "Macintosh - OS X" | /usr/bin/grep -A1 "Safari" | /usr/bin/sed -e 's/<[^>][^>]*>//g' -e '/^ *$/d' | /usr/bin/tail -n 1 | /usr/bin/awk '{print $1}'`.chomp!

dep 'up to date flash player' do
  met? {
    installed = File.exist? '/Library/Internet Plug-Ins/Flash Player.plugin'
    current_version = `/usr/bin/defaults read '/Library/Internet\ Plug-Ins/Flash\ Player.plugin/Contents/version' CFBundleShortVersionString`.chomp!
    installed && (current_version == latest_version)
  }
  meet {
    Babushka::Resource.extract("http://fpdownload.macromedia.com/get/flashplayer/pdc/#{latest_version}/install_flash_player_osx.dmg") do
      shell "/usr/sbin/installer -pkg 'Install\ Adobe\ Flash\ Player.app/Contents/Resources/Adobe\ Flash\ Player.pkg' -target /", :sudo => true
    end
  }
end

dep 'ClickToPlugin.safariextz' do
  source 'https://github.com/downloads/hoyois/safariextensions/ClickToPlugin-2.5.4.safariextz'
end

dep 'Media Center.safariextz' do
  source 'https://github.com/downloads/hoyois/safariextensions/MediaCenter-1.1.safariextz'
end

meta :safariextz, :for => :osx do
  accepts_value_for :source
  
  template {
    def path
      '~/Library/Safari/Extensions' / name
    end
    puts path
    met? { File.exist? path }
    meet {
      Babushka::Resource.get(source) do |path|
        shell "open '#{path}' --wait-apps --new --fresh"
      end
    }
  }
end
