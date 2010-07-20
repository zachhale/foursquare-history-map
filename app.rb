require 'rubygems'
require 'sinatra/base'

class FoursquareHistory < Sinatra::Application
  get '/' do
    @history = File.read('history.json')
    erb :index
  end
  
  get '/favicon.ico' do
    '' # stupid
  end
end

FoursquareHistory.run! if __FILE__ == $0