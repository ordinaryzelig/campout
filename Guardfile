# A sample Guardfile
# More info at https://github.com/guard/guard#readme

# Restarting Rack is slow.
# Use this guard to compile HAML into HTML so we can see changes quicker.
# Changes are not reflected in Rack app, but compiles HTML file, which can be viewed in browser.
# Result will not contain images.
# Do not forget to remove the .html file. Tilt will complain otherwise.
guard 'haml', input: 'views', output: 'views' do
  watch(/^.+(\.html\.haml)/)
end
