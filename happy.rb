#!/usr/bin/ruby

require 'rubygems'
require 'hpricot'
require 'open-uri'
require 'geokit'
require 'nokogiri'

class Place
  #  attr_accessor :name, :location, :phone, :link, :happyhours, :description
  def initialize(hash)
    raise "not hash" unless hash.respond_to?(:each_key)
    hash.each do |k,v|
      self.instance_variable_set("@#{k}", v)
      self.class.send(:define_method, k, proc{self.instance_variable_get("@#{k}")}) 
      self.class.send(:define_method, "#{k}=", proc { |v|
        self.instance_variable_set("@#{k}", v)
      })
    end
  end
end

url = 'http://www.sfweekly.com/content/printVersion/1956736'

doc = Hpricot open url

places = []

doc.search('p b').each do |place|
  name = place.parent.search('b').inner_text
  location = place.parent.search('i').first.inner_text[/[^(]+/].strip
  phone = place.parent.search('i').first.inner_text[/\d{3}-\d{4}/].strip
  link = place.parent.search('i a').first[:href] rescue nil
  ll = Geokit::Geocoders::YahooGeocoder.geocode("#{location}, San Francisco, CA").ll
  lat, lon = ll.split(',')[0],ll.split(',')[1]
  #  happhours 
  #  place.parent.search('i').each do |happyhour|
    #  happyhour.inner_text[/\d[:&-]/]
  #  en
  happyhours, description = nil
  #  puts "#{name},#{location},#{phone},#{link},#{happyhours},#{ll}"
  places << Place.new( {:name => name, :ll => ll, :lat => lat, :lon => lon} )
end

#  p places
#
builder = Nokogiri::XML::Builder.new do |xml|
  xml.kml('xmlns' => 'http://www.opengis.net/kml/2.2') {
    xml.Folder {
      places.each do |place|
        xml.Placemark {
          xml.name_ place.name
          xml.Point {
            xml.coordinates_ "#{place.lon},#{place.lat}"
          }
        }
      end
    }
  }
end

puts builder.to_xml

