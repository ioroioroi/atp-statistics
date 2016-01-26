AtpStatistics::App.controllers :activity do
  get :index, :with => [:name, :year] do
    player_name = Player.convert_name_from_url_name(params[:name])
    @activities = Activity
      .where("player_name = ?", player_name)
      .where("year = ?", params[:year])
      .order("tournament_start_date")
      .order("id DESC")
    erb :'activity/common'
  end

  get :vstop10, :with => [:name, :year] do
    player_name = Player.convert_name_from_url_name(params[:name])
    @activities = Activity
      .where("opponent_rank <= ?", 10)
      .where("player_name = ?", player_name)
      .where("year = ?", params[:year])
      .order("tournament_start_date")
      .order("id DESC")
    erb :'activity/common'
  end

  get :higher, :with => [:name, :year] do
    player_name = Player.convert_name_from_url_name(params[:name])
    @activities = Activity
      .where("player_rank > opponent_rank")
      .where("player_name = ?", player_name)
      .where("year = ?", params[:year])
      .order("tournament_start_date")
      .order("id DESC")
    erb :'activity/common'
  end

  get :lower, :with => [:name, :year] do
    player_name = Player.convert_name_from_url_name(params[:name])
    @activities = Activity
      .where("player_rank < opponent_rank")
      .where("win_loss = ?", "L")
      .where("player_name = ?", player_name)
      .where("year = ?", params[:year])
      .order("tournament_start_date")
      .order("id DESC")
    erb :'activity/common'
  end
end
