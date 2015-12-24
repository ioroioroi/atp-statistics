require "csv"

CSV.foreach('db/sample_data.csv') do |row|
  Activity.create(
    :year => row[0],
    :player_name => row[1],
    :player_ranking => row[2],
    :opponent_name => row[3],
    :opponent_ranking => row[4],
    :round => row[5],
    :score => row[6],
    :win_loss => row[7],
    :tournament_name => row[8],
    :tournament_place => row[9],
    :tournament_date => row[10],
    :tournament_surface => row[11]
  )
end
