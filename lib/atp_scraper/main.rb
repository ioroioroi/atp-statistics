require 'open-uri'
require 'nokogiri'

## ページ構成の命名
# activity_doc(全体)
#   tournament_doc
#     record_doc
#     record_doc
#     record_doc
#     record_doc
#   tournament_doc
#     record_doc
#     record_doc
#     record_doc

# Scrape data and insert db
class Scraping
  def parse_html(url)
    charset = nil
    html = open(url) do |f|
      charset = f.charset
      f.read
    end
    return Nokogiri::HTML.parse(html, nil, charset)
  end
  
  # nokogiriでparseされたactivityのページから
  # 必要な情報を抜き出す
  def pickup_activity_data(activity_doc)
    result = []
    player = {}
    player['name'] = pickup_player_name(activity_doc) 

    search_tournaments_doc(activity_doc).each do |tournament_doc|
      tournament = pickup_tournament_info(tournament_doc)
      player['rank'] = pickup_player_rank(tournament["caption"])
      search_records_doc(tournament_doc).each do |record_doc|
        record = pickup_record(record_doc)
        record_hash = create_record(record, player, tournament)
        result.push(record_hash)
      end
    end
    return result
  end
  
  def search_tournaments_doc(activity_doc)
    activity_doc.css(".activity-tournament-table")
  end

  def search_records_doc(tournament_doc)
    tournament_doc.css(".mega-table tbody tr")
  end

  def create_record(record, player, tournament)
    hash = {
      year: tournament["year"],
      player_name: player["name"],
      player_rank: player["rank"],
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
  end
  
  def pickup_player_name(activity_doc)
    activity_doc.
      css("meta[property=\"pageTransitionTitle\"]").
      attr("content").
      value
  end

  def pickup_record(record_doc)
    result = {}
    record_doc.css("td").each_with_index do |td, n|
      result["round"] = td.content.strip if n == 0
      result["opponent_rank"] = td.content.strip if n == 1
      result["opponent_name"] = td.content.strip if n == 2
      result["win_loss"] = td.content.strip if n == 3
      result["score"] = td.content.strip if n == 4
    end
    return result
  end

  def pickup_tournament_info(tournament_doc)
    result = {}
    result["name"] = tournament_doc.css(".tourney-title").first.content.strip
    result["location"] = tournament_doc.css(".tourney-location").first.content.strip
    result["date"] = tournament_doc.css(".tourney-dates").first.content.strip
    result["year"] = tournament_doc.css(".tourney-dates").first.content.strip[0, 4]
    result["caption"] = tournament_doc.css(".activity-tournament-caption").first.content.strip
    result["surface"] = 'surface'
    return result
  end

  def pickup_player_rank(tournament_caption)
    rank = tournament_caption.match(/ATP Ranking:(.+), Prize/)
    return rank[1].strip
  end

  def register_activity_data(activities)
    activities.each do |a|
      Activity.create(
        :year => a[:year],
        :player_name => a[:player_name],
        :player_rank => a[:player_rank],
        :opponent_name => a[:opponent_name],
        :opponent_rank => a[:opponent_rank],
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
