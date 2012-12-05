# coding:utf-8

require 'sinatra'
require 'haml'
require 'omniauth'
require 'omniauth-facebook'
require 'rest-graph'

enable :sessions, :logging

$FACEBOOK_APP_ID = '----'
$FACEBOOK_SECRET = '----'

use OmniAuth::Builder do
  provider :facebook, $FACEBOOK_APP_ID, $FACEBOOK_SECRET, {:scope => 'publish_actions'}
end

get '/' do
  haml :welcome, :layout => true
end

get '/auth/:provider/callback' do
  @auth = request.env['omniauth.auth']
  if @auth['credentials'] then
    session[:token] = @auth['credentials']['token']
    redirect '/pictures'
  end
  haml :callback, :layout => true
end

get '/logout' do
  session[:token] = nil
  redirect '/'
end

get '/pictures' do
  haml :pictures, :layout => true
end

get '/picture/:id' do
  @id = params[:id]
  case @id
    when "2" then
      @image_url = 'http://distilleryimage7.instagram.com/fd9122fedbc211e1b93522000a1c8870_7.jpg'
    when "3" then
      @image_url = 'http://distilleryimage2.s3.amazonaws.com/0ecd4032d21a11e1a3461231381315e1_7.jpg'
    when "4" then
      @image_url = 'http://distilleryimage6.s3.amazonaws.com/09e5941cd15111e1b62322000a1e8a75_7.jpg'
    when "5" then
      @image_url = 'http://distilleryimage7.s3.amazonaws.com/cbbd0ece8b7111e19dc71231380fe523_7.jpg'
    else
      @image_url = 'http://distilleryimage5.s3.amazonaws.com/3dd8c566cae211e1b10e123138105d6b_7.jpg'
  end
  haml :picture, :layout => false
end

get '/post/picture/:id' do
  id = params[:id]
  rg = RestGraph.new(
    :access_token => session[:token],
    :app_id => $FACEBOOK_APP_ID,
    :secret => $FACEBOOK_SECRET
  )
  @response = rg.post('me/fbapi-testapp:take',
    :picture => "http://fbapi-testapp.herokuapp.com/picture/#{id}"
  )
  haml :viral, :layout => true
end

get '/:name' do
  @name = params[:name]
  haml :greet, :layout => true
end

