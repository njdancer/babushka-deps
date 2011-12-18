# dep 'App Store signed in' do
#   met? { !(`/usr/bin/defaults read com.apple.storeagent AppleID`.include? 'does not exist') }
#   meet {
#       script = %{tell application "App Store" to activate
#       tell application "System Events"
#         tell process "App Store"
#           tell menu bar 1
#             tell menu bar item "Store"
#               tell menu "Store"
#                 click menu item "Sign In…"
#               end tell
#             end tell
#           end tell
# 
#           delay 1
#           keystroke "nick@dancr.me  password"
# 
#           tell sheet 1 of window 1
#             click button "Sign In"
#           end tell
#         end tell
#       end tell}
#     `osascript -e '#{script}'`
#   }
# end
# 
# dep 'Pages.app' do
#   met? { File.exist? '/Application/Pages.app' }
#   meet {
#     script = %{
#       tell application "App Store" to activate
#       tell application "System Events"
#         tell process "App Store"
#           tell group 7 of tool bar 1 of window "App Store"
#             set focused of text field 1 to true
#             keystroke "Pages"
#             keystroke return
#           end tell
#         
#           delay 5
#           tell group 1 of group 4 of list 1 of group 2 of UI element 1 of scroll area 1 of window "App Store"
#             click button "InstallInstall"
#           end tell
#         end tell
#       end tell}
#       `osascript -e '#{script}'`
#   }
# end
