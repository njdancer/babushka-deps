dep 'rails development environment' do
  requires 'TextMate.app'
  requires 'IR_Black.tmTheme'
  requires 'IR_Black.terminal'
end

dep 'rails.gem' do
  provides 'rails'
end

dep 'IR_Black.tmTheme' do
  met? { File.exist? File.expand_path '~/Library/Application Support/TextMate/Themes/IR_Black.tmTheme' }
  before { shell 'mkdir -p ~/Library/Application\ Support/TextMate/Themes' }
  meet {
    Babushka::Resource.extract('http://www.infinitered.com/settings/IR_Black.tmTheme.zip') do
      shell 'cp IR_Black.tmTheme ~/Library/Application\ Support/TextMate/Themes/'
    end
  }
end

dep 'IR_Black.terminal' do
  met? { shell("defaults read com.apple.terminal").split('IR_Black').length > 2 }
  meet {
    Babushka::Resource.extract('http://blog.toddwerth.com/entry_files/13/IR_Black.terminal.zip') do
      log 'Set this to the default theme if desired and exit terminal to continue.'
      shell 'open IR_Black.terminal --wait-apps --new --fresh'
    end
  }
end
