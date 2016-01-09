AtpStatistics::App.controllers :player do
  get :index do
    @players = Player.all
    erb :'player/index'
  end
end
