require 'open-uri'

# Scrape data and insert db
class Scraping
  def get_activity_html(url)
    open(url, 'r:UTF-8', &:read)
  end

  def parse_activity_data(html)
    return ""
  end

  def register_activity_data(activities)
    activities.each do |a|
      Activity.create(
        :player_name => a[0],
        :player_ranking => a[1],
        :opponent_name => a[2],
        :opponent_ranking => a[3],
        :round => a[4],
        :score => a[5],
        :win_loss => a[6],
        :tournament_name => a[7],
        :tournament_place => a[8],
        :tournament_date => a[9],
        :tournament_surface => a[10]
      )
    end
  end
end
