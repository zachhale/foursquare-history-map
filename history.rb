require 'rubygems'
require 'open-uri'
require 'json'

checkins = File.exists?('history.json') ? JSON.parse(File.read('history.json')) : []
since_id = checkins.last ? checkins.last['id'] : 0

puts "Save Your History"

print "Enter Username: "
username = $stdin.gets.chomp
print "Enter Password: "
password = $stdin.gets.chomp

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
