require 'open-uri'
require 'nokogiri'

# Scrape data and insert db
class Scraping
  def parse_activity_data(url)
    charset = nil
    html = open(url) do |f|
      charset = f.charset
      f.read
    end
    return Nokogiri::HTML.parse(html, nil, charset)
  end

  def pickup_data(doc)
    result = []
    tournaments = doc.css(".activity-tournament-table")
    tournaments.each do |t|
      tournament = pickup_tournament_info(t)
      player_name = "Rafael Nadal"
      player_rank = pickup_player_rank(tournament["caption"])
      record_table = t.css(".mega-table tbody tr")
      record_table.each do |r|
        record = pickup_record(r)
        hash = {
          year: tournament["year"],
          player_name: player_name,
          player_rank: player_rank,
          opponent_name: record["opponent_name"],
          opponent_rank: record["opponent_rank"],
          round: record["round"],
          score: record["score"],
          win_loss: record["win_loss"],
          tournament_name: tournament["name"],
          tournament_location: tournament["location"],
          tournament_date: tournament["date"],
          tournament_surface: tournament["surface"]
        }
        result.push(hash)
      end
    end
    return result
  end
  
  def pickup_record(data)
    result = {}
    data.css("td").each_with_index do |td, n|
      result["round"] = td.content.strip if n == 0
      result["opponent_rank"] = td.content.strip if n == 1
      result["opponent_name"] = td.content.strip if n == 2
      result["win_loss"] = td.content.strip if n == 3
      result["score"] = td.content.strip if n == 4
    end
    return result
  end

  def pickup_tournament_info(data)
    result = {}
    result["name"] = data.css(".tourney-title").first.content.strip
    result["location"] = data.css(".tourney-location").first.content.strip
    result["date"] = data.css(".tourney-dates").first.content.strip
    result["year"] = data.css(".tourney-dates").first.content.strip[0, 4]
    result["caption"] = data.css(".activity-tournament-caption").first.content.strip
    result["surface"] = 'surface'
    return result
  end

  def pickup_player_rank(caption)
    rank = caption.match(/ATP Ranking:(.+), Prize/)
    return rank[1].strip
  end

  def register_activity_data(activities)
    activities.each do |a|
      Activity.create(
        :year => a[:year],
        :player_name => a[:player_name],
        :player_ranking => a[:player_rank],
        :opponent_name => a[:opponent_name],
        :opponent_ranking => a[:opponent_rank],
        :round => a[:round],
        :score => a[:score],
        :win_loss => a[:win_loss],
        :tournament_name => a[:tournament_name],
        :tournament_place => a[:tournament_location],
        :tournament_date => a[:tournament_date],
        :tournament_surface => a[:tournament_surface]
      )
    end
  end
end
