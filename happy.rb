#!/usr/bin/ruby

require 'rubygems'
require 'hpricot'
require 'open-uri'

url = 'http://www.sfweekly.com/content/printVersion/1956736'

doc = Hpricot open url

doc.search('p b').each do |place|
  name = place.parent.search('b').inner_text
  location = place.parent.search('i').first.inner_text[/[^(]+/].strip
  phone = place.parent.search('i').first.inner_text[/\d{3}-\d{4}/].strip
  link = place.parent.search('i a').first[:href] rescue nil
  happyhours = place.parent.search('i a')[1][:href] #rescue nil
  description = nil
  puts "#{name},#{location},#{phone},#{link},#{happyhours},#{description}"
end

class Place
  attr_accessor :name, :location, :phone, :link, :happyhours, :description
  def initialize
    #  raise "not hash" unless hash.respond_to?(:each_key)
    #  hash.each do |k,v|
      #  self.instance_variable_set("@#{k}", v)
      #  self.class.send(:define_method, k, proc{self.instance_variable_get("@#{k}")}) 
      #  self.class.send(:define_method, "#{k}=", proc { |v|
        #  self.instance_variable_set("@#{k}", v)
      #  })
    #  end
  end
end
