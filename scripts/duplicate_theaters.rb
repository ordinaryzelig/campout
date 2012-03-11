Theater.includes(&:theater_sources).order(:created_at).all.group_by(&:coordinates).each do |coords, theaters|
  next if theaters.size < 2
  keeper = theaters.pop
  theaters.each do |theater|
    theater.theater_sources.each do |ts|
      ts.theater = keeper
      ts.save!
    end
    theater.destroy
  end
end
