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

  LOOPS_ALLOWED = 20

  class << self

    # Keep yielding until done.
    # If OverQueryLimitError raised, sleep for 1 second and try again.
    def loop_on_query_limit_exception
      loops = 0
      done = false
      until done
        begin
          exit_value = yield
          done = true
        rescue Geocoder::OverQueryLimitError
          loops += 1
          raise if loops > LOOPS_ALLOWED
          pause
        end
      end
      exit_value
    end

    private

    def pause
      return if Campout.env.test?
      puts 'sleeping 1 second...'
      sleep(1)
    end

  end

end
