AtpStatistics::App.controllers :main do
  get :index do
    @players = Player.all
    erb :'main/index'
  end
end
