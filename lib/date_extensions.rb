class Date

  # MovieTickets.com sometimes uses number of days instead of exact date.
  # 0 = today or past
  # 1 = 1 day from today, etc.
  def to_ShowDate
    days_to_release = (self - Date.current).to_i
    days_to_release = 0 if days_to_release < 0
    days_to_release
  end

end
