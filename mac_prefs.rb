dep 'finder shows hidden files' do
  met? {
    !!(`defaults read com.apple.finder AppleShowAllFiles` =~ /TRUE/)
  }
  meet {
    shell('defaults write com.apple.finder AppleShowAllFiles TRUE')
  }
end

computer_name = 'Dancers Air'
bonjour_name = 'Dancers-Air'
hostname = 'dancers-air'

dep 'dancers airs computer name set' do
  met? { !!(`scutil --get ComputerName`.match(computer_name)) }
  meet { shell("scutil --set ComputerName '#{computer_name}'", :sudo => true) }
  after { `dscacheutil -flushcache` }
end

dep 'dancers airs bonjour name set' do
  met? { !!(`scutil --get LocalHostName`.match(bonjour_name)) }
  meet { shell("scutil --set LocalHostName '#{bonjour_name}'", :sudo => true) }
  after { `dscacheutil -flushcache` }
end

dep 'dancers airs hostname set' do
  met? { !!(`scutil --get HostName`.match(hostname)) }
  meet { shell("scutil --set HostName '#{hostname}'", :sudo => true) }
  after { `dscacheutil -flushcache` }
end

dep 'system software is up to date' do
  met? { !(shell('softwareupdate -l', :sudo => true, :spinner => true).include? 'Software Update found the following new or updated software') }
  meet { shell 'softwareupdate -i -a', :sudo => true, :spinner => true }
end
