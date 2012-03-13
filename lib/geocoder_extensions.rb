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
  SLEEP_SECONDS = 1

  class << self

    def loop_on_query_limit_exception(&block)
      sleep_proc = proc do
        if Campout.env.test?
          0
        else
          puts 'sleeping #{SLEEP_SECONDS} second...'
          SLEEP_SECONDS
        end
      end
      retryable(on: Geocoder::OverQueryLimitError, sleep: sleep_proc, &block)
    end

  end

end
