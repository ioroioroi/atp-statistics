namespace :atp_activity do
  desc "Get activities data and db register"
  task :get, ['url'] => :environment do |task, args|
    scraping = Scraping.new
    doc = scraping.parse_activity_data(args[:url])
    activities = scraping.pickup_data(doc)
    scraping.register_activity_data(activities)
  end
end

