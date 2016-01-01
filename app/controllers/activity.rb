AtpStatistics::App.controllers :activity do
  get :index, :with => [:name, :year] do
    player_name = convert_player_name_to_upper(params[:name])
    @activities = Activity
      .where("player_name = ?", player_name)
      .where("year = ?", params[:year])
    erb :'activity/common'
  end

  get :vstop10, :with => [:name, :year] do
    player_name = convert_player_name_to_upper(params[:name])
    @activities = Activity
      .where("opponent_rank <= ?", 10)
      .where("player_name = ?", player_name)
      .where("year = ?", params[:year])
    erb :'activity/common'
  end

  get :higher, :with => [:name, :year] do
    player_name = convert_player_name_to_upper(params[:name])
    @activities = Activity
      .where("player_rank > opponent_rank")
      .where("win_loss = ?", "W")
      .where("player_name = ?", player_name)
      .where("year = ?", params[:year])
    erb :'activity/common'
  end

  get :lower, :with => [:name, :year] do
    player_name = convert_player_name_to_upper(params[:name])
    @activities = Activity
      .where("player_rank < opponent_rank")
      .where("win_loss = ?", "L")
      .where("player_name = ?", player_name)
      .where("year = ?", params[:year])
    erb :'activity/common'
  end
end