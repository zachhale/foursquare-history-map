require File.join(File.dirname(__FILE__), 'lib/helpers')

require 'rubygems'
require 'open-uri'
require_or_prompt 'termios'
require_or_prompt 'json'

checkins = File.exists?('history.json') ? JSON.parse(File.read('history.json')) : []
since_id = checkins.last ? checkins.last['id'] : 0

username = ask 'enter email: '
password = ask 'enter password: ', :secret => true

get = proc do
  JSON.parse(open("http://api.foursquare.com/v1/history.json?l=250&sinceid=#{since_id}",
    :http_basic_authentication => [username, password]
  ).read)['checkins']
end

until (new_checkins = get.call).empty?
  since_id = (checkins += new_checkins).last['id']
  File.open("#{ENV['HOME']}/Desktop/history.json", 'w+') { |f| f.puts checkins.to_json }
  puts "#{checkins.size} checkins saved"
end

puts "done!"
