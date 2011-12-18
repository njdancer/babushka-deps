dep 'Perian.prefPane' do
  met? { File.exist? '/Library/PreferencePanes/Perian.prefPane' }
  meet {
    Babushka::Resource.extract("http://perian.cachefly.net/Perian_1.2.3.dmg") do
      log 'Installing Perian. Please finish necessary configuration and installation within System Preferences and close to return focus to Babushka.'
      shell "open Perian.prefPane --wait-apps --new --fresh"
    end
  }
end
