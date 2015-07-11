ENV['RACK_ENV'] ||= 'development'
 
require 'bundler'

Bundler.require :default, ENV['RACK_ENV'].to_sym

class App < Sinatra::Base
 
  set :root, File.dirname(__FILE__)
 
  get '/' do
    send_file File.expand_path('index.html', settings.public_folder)
  end
 
end

