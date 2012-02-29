module Geocodable

  def geocode
    attr_accessor :latitude
    attr_accessor :longitude
    geocoded_by :address
  end

end

ActiveRecord::Base.extend(Geocoder::Model::ActiveRecord)
ActiveRecord::Base.extend Geocodable

module Geocoder

  # Keep yielding until done.
  # If OverQueryLimitError raised, sleep for 1 second and try again.
  def self.loop_on_query_limit_exception
    until @done
      begin
        yield
        @done = true
      rescue Geocoder::OverQueryLimitError
        puts 'sleeping 1 second...'
        sleep(1)
      end
    end
    # Reset for next call.
    @done = false
    true
  end

end
