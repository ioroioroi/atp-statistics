require "csv"

CSV.foreach('db/sample_data.csv') do |row|
  Activity.create(
    :player_name => row[0],
    :player_ranking => row[1],
    :opponent_name => row[2],
    :opponent_ranking => row[3],
    :round => row[4],
    :score => row[5],
    :win_loss => row[6],
    :tournament_name => row[7],
    :tournament_place => row[8],
    :tournament_date => row[9],
    :tournament_surface => row[10]
  )
end
