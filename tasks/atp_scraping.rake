namespace :atp_statistics do
  namespace :activity do
    desc "Get activities data from activity page"
    task :get, ['url'] => :environment do |_task, args|
      activity = get_activity(args[:url])
      register_activity(activity)
    end

    desc "Register past data"
    task :register_past_data, ['start_year', 'end_year'] => :environment do |_task, args|
      Player.all.each do |player|
        year_range = args[:start_year]..args[:end_year]
        year_range.each do |year|
          activity_url = create_activity_url(player.url_name, player.url_id, year) 
          activity = get_activity(activity_url)
          register_activity(activity)
        end
      end
    end
    
    def get_activity(url)
      scraping = AtpScraper::Activity.new
      html = AtpScraper::Get.get_html(url)
      activity_doc = AtpScraper::Get.parse_html(html[:html], html[:charset])
      scraping.pickup_activity_data(activity_doc)
    end

    def register_activity(activities)
      Activity.create_records(activities)
    end

    def create_activity_url(player_url_name, url_id, year)
      base = "http://www.atpworldtour.com"
      path = "/players/#{player_url_name}/#{url_id}/player-activity"
      option = "?year=#{year}"
      base + path + option
    end
  end

  namespace :atp_player do
    desc "Get player list(TOP100) and db register"
    task :get, ['url'] => :environment do |task, args|
      scraping = AtpScraper::Player.new
      html = AtpScraper::Get.get_html(args[:url])
      ranking_doc = AtpScraper::Get.parse_html(html[:html], html[:charset])
      players = scraping.create_list(ranking_doc)
      Player.create_records(players)
    end
  end
end

