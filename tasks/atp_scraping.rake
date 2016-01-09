namespace :atp_activity do
  desc "Get activities data and db register"
  task :get, ['url'] => :environment do |task, args|
    logger.info "Start #{task}."
    scraping = AtpScraper::Activity.new
    html = AtpScraper::Get.get_html(args[:url])
    activity_doc = AtpScraper::Get.parse_html(html[:html], html[:charset])
    activities = scraping.pickup_activity_data(activity_doc)
    Activity.create_records(activities)
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
