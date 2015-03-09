# encoding: utf-8

require 'bundler'
Bundler.require
require './model'
require 'sinatra/base'
require 'sinatra/flash'
require 'sinatra/assetpack'
require "sinatra/reloader"
require 'sinatra-websocket'
require 'sinatra/contrib'
require "sinatra/cookies"
require 'will_paginate'
require 'will_paginate/data_mapper'
require 'json'
require 'geokit'
require 'mandrill'
require 'thin'

class Lennep < Sinatra::Base

  # -----------------------------------------------------------
  # Sinatra Settings
  # -----------------------------------------------------------

  set :root, File.dirname(__FILE__)
  set :environments, %w{development production}
  set :session_secret, '*&(^B234'
  set :public_folder, 'public'
  set :server, 'thin'
  set :sockets, []

  enable :sessions
  enable :method_override
  enable :logging

  register Sinatra::Flash
  register Sinatra::AssetPack
  register Sinatra::Contrib

  # -----------------------------------------------------------
  # Mandrill
  # -----------------------------------------------------------

  mandrill = Mandrill::API.new 'szZU6o0dhGUZ-e2dQEqdyg'

  # -----------------------------------------------------------
  # Faye Websocket
  # -----------------------------------------------------------

  Faye::WebSocket.load_adapter('thin')

  # -----------------------------------------------------------
  # Assets
  # -----------------------------------------------------------

  require 'sass'
  set :sass, { :load_paths => [ "#{Lennep.root}/assets/css" ] }

  assets do
    serve '/js',     from: 'assets/js'        # Default
    serve '/css',    from: 'assets/css'       # Default
    serve '/images', from: 'assets/images'    # Default
    serve '/fonts',  from: 'assets/fonts'     # Default

    js :application, [
      '/js/lib/jquery-2.1.3.js',
      '/js/vendor/jquery.cookie.js',
      '/js/specific/socket.js',
      '/js/specific/navigation.js',
      '/js/specific/edit.js',
      '/js/specific/flash.js',
      '/js/specific/fav_counter.js',
      '/js/specific/slider.js',
      '/js/app.js',
    ]

    js :venue, [
      '/js/specific/venue_show.js'
    ]

    js :map, [
      '/js/vendor/mapbox.js',
      '/js/specific/map.js',
      '/js/specific/venue.js'
    ]

    css :application, '/css/application.sass', [
      '/css/application.css'
    ]

    js_compression  :jsmin
    css_compression :sass 
  end

  # -----------------------------------------------------------
  # Authentication with Warden
  # -----------------------------------------------------------

  use Warden::Manager do |config|
    config.serialize_into_session{|user| user.id }
    config.serialize_from_session{|id| User.get(id) }
    config.scope_defaults :default,
      strategies: [:password],
      action: 'auth/unauthenticated'
    config.failure_app = self
  end

  Warden::Manager.before_failure do |env,opts|
    env['REQUEST_METHOD'] = 'POST'
  end

  Warden::Strategies.add(:password) do
    def valid?
      params['user'] && params['user']['username'] && params['user']['password']
    end

    def authenticate!
      user = User.first(username: params['user']['username'])

      if user.nil?
        fail!("The username you entered does not exist.")
      elsif user.authenticate(params['user']['password'])
        success!(user)
      else
        fail!("Could not log in")
      end
    end

    def admin?
      user = User.first(username: params['user']['username'])

      if user.nil?
        fail!("The username you entered does not exist.")
      elsif user.admin?
        success!(user)
      else
        fail!("Could not log in")
      end
    end
  end

  # -----------------------------------------------------------
  # Helpers
  # -----------------------------------------------------------

  helpers WillPaginate::Sinatra::Helpers
  helpers Gravatarify::Helper
  helpers Sinatra::Cookies

  helpers do
    def paginate(collection)
       options = {
         inner_window: 0,
         outer_window: 0,
         previous_label: '&laquo;',
         next_label: '&raquo;'
       }
      will_paginate collection, options
    end
    def truncate_words(text, length, end_string = ' ...')
      words = text.split()
      words = words[0..(length-1)].join(' ') + (words.length > length ? end_string : '')
    end
  end

  # -----------------------------------------------------------
  # Routes
  # -----------------------------------------------------------

  require_relative 'routes/auth'
  require_relative 'routes/blog'
  require_relative 'routes/index'
  require_relative 'routes/tour'
  require_relative 'routes/user'
  require_relative 'routes/venue'
  require_relative 'routes/category'
  require_relative 'routes/favs'

end