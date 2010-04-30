

require 'rubygems'
require 'hpricot'
require 'open-uri'

url = 'http://www.sfweekly.com/content/printVersion/1956736'

doc = Hpricot open url

doc.search('p b').each do |place|
  p place.parent.search('b')
end
