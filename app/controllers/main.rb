AtpStatistics::App.controllers :main do
  get :index do
    @activities = Activity.all
    erb :'main/index'
  end
end
