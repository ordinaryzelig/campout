require 'camping' # Why isn't Bundler requiring this?

Camping.goes :Campout

module Campout::Controllers

  class Index
    def get
      render :index
    end
  end

  #class Testmail
    #def get
      #@message = Pony.mail(
        #to: 'jared@redningja.com',
        #from: 'pony@redningja.com',
        #subject: 'test',
        #body: 'this is a test',
      #)
      #render :testmail
    #end
  #end

  class Movietickets < R '/movietickets/(.*)'
    def get(date)
      @date = Chronic.parse(date).to_date
      @movies = MovieTickets::Theater.all.each_with_object({}) do |theater, hash|
        hash[theater] = MovieTickets.scour(theater: theater, date: @date).uniq(&:title)
      end
      render :movietickets
    end
  end

end

module Campout::Views

  def testmail
    p @message.body
  end

  def movietickets
    h1 @date
    @movies.each do |theater, movies|
      h2 theater.name
      ul do
        movies.each do |movie|
          li movie.title
        end
      end
    end
  end

end
