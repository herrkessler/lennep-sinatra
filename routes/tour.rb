class Lennep < Sinatra::Base

  # Blog
  # -----------------------------------------------------------

  get '/tour' do
    @sessionUser = env['warden'].user
    unless env['warden'].user == nil
      
    end
    slim :"tour/index"
  end
  
end