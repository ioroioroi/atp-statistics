namespace :atp_activity do
  desc "Get activities data and db register"
  task :get, ['url'] => :environment do |task, args|
    scraping = AtpScraper.new
    html = scraping.get_html(args[:url])
    activity_doc = scraping.parse_html(html[:html], html[:charset])
    activities = scraping.pickup_activity_data(activity_doc)
    puts activities
  end
end

