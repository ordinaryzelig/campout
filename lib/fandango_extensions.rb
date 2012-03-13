module Fandango

  LOOPS_ALLOWED = 5
  SLEEP_SECONDS = 2

  class << self

    def loop_on_bad_response(&block)
      sleep_proc = proc do
        if Campout.env.test?
          0
        else
          puts 'sleeping 1 second...'
          SLEEP_SECONDS
        end
      end
      retryable(on: Fandango::BadResponse, sleep: sleep_proc, &block)
    end

  end

end
