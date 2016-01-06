namespace :atp_activity do
  desc "Get activities data and db register"
  task :get, ['url'] => :environment do |task, args|
    logger.info "Start #{task}."
    scraping = AtpScraper.new
    html = scraping.get_html(args[:url])
    activity_doc = scraping.parse_html(html[:html], html[:charset])
    activities = scraping.pickup_activity_data(activity_doc)
    puts activities
  end
end

namespace :atp_player do
  desc "Create player record"
  task :create, ['name', 'url_id'] => :environment do |task, args|
    logger.info "Start #{task}."
    create_player = Player.new(name: args[:name], url_id: args[:url_id])
    create_player.save
  end
end
