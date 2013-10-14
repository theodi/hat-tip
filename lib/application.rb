require 'sinatra'
require 'sinatra/base'
require 'sinatra/content_for'
require 'sinatra/static_assets'
require 'sinatra/url_for'

class HatTipApp < Sinatra::Base
  
  helpers do
    include Sinatra::ContentFor
    register Sinatra::StaticAssets     
  end
  
  #Configure application level options
  configure do |app|
    set :static, true    
    set :views, File.dirname(__FILE__) + "/../site/views"
    set :public_dir, File.dirname(__FILE__) + "/../site/public"
  end
  
  get "/" do
    erb :index
  end  
  
  get "/about" do
    erb :about
  end
      
end