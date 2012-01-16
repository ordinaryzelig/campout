require 'spec_helper'

describe Scourable do

  it '.source_type returns source type' do
    MovieTickets::Theater.source_type.must_equal(MovieTickets)
  end

  it '.type returns type' do
    MovieTickets::Theater.type.must_equal(Theater)
  end

  it '.db_yml_file_path returns correct path' do
    yml_path =    File.expand_path(MovieTickets::Theater.db_yml_file_path)
    manual_path = File.expand_path(Campout.root_dir + 'db/sources/movie_tickets/theaters.yml')
    yml_path.must_equal manual_path
  end

  it '.load_from_yaml loads yml, and returns theater objects with data' do
    theaters = MovieTickets::Theater.load_from_yaml
    theaters.first.name.must_equal 'AMC Quail Springs Mall 24'
  end

end
