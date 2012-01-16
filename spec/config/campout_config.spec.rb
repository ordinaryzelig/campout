require 'spec_helper'

describe Campout do

  it '.root_dir returns correct Pathname' do
    root_pathname =   File.expand_path(Campout.root_dir)
    manual_pathname = File.expand_path(File.dirname(__FILE__) + '/../..')
    root_pathname.must_equal manual_pathname
  end

end
