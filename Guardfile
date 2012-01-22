# A sample Guardfile
# More info at https://github.com/guard/guard#readme

# Restarting Rack is slow.
# Use this guard to compile HAML into HTML so we can see changes quicker.
guard 'haml', input: 'views', output: 'views' do
  watch(/^.+(\.html\.haml)/)
end
