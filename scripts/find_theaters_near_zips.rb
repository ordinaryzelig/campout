zips = File.open(__FILE__).read.split('__END__')[2].split.map(&:chomp)
zips.each do |zip|
  next if zip[0] == '#'
  print "#{zip}: "
  theaters = TicketSources.find_theaters_near(zip)
  puts theaters.size
  sleep(1)
end

__END__
#01077
#01867
#05495
#06040
#07020
#07675
#08030
#08854
#10023
#10993
#10994
#11501
#12144
#12553
#14086
#15104
#15367
#17201
#17703
#18431
#18603
#19103
#19301
#19711
#19943
#21014
#21206
#21396
#22192
#23233
#30092
#31210
#32570
#32601
#32779
#32837
#33179
#37075
#37214
#39047
#40229
#43017
#43081
#44667
#45246
#46204
#46254
#46368
#48040
#48124
#48602
#49093
#55107
#55124
#60419
#60510
#60611
#60614
#60647
#63128
#71111
#73132
#73134
#74112
#74137
#75044
#75098
#75554
#76092
#77024
#77375
#77479
#78660
#78704
#80003
#80021
#80222
#85234
#85284
#87122
#90045
#90202
#91104
#91381
#91505
#91608
#91706
#91723
#91744
#91767
#92026
#92121
#92126
#92503
#94501
#94568
#95210
#95825
#97030
#97229
#98072
#98109