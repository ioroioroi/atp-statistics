namespace :atp_activity do
  desc "Get activities data and db register"
  task :get, ['url'] => :environment do |task, args|
    logger.info "Start #{task}."
    scraping = AtpScraper.new
    html = scraping.get_html(args[:url])
    activity_doc = scraping.parse_html(html[:html], html[:charset])
    activities = scraping.pickup_activity_data(activity_doc)
    activities.each do |a|
      Activity.update(
        year: a[:year],
        player_name: a[:player_name],
        player_rank: a[:player_rank],
        opponent_name: a[:opponent_name],
        opponent_rank: a[:opponent_rank],
        round: a[:round],
        score: a[:score],
        win_loss: a[:win_loss],
        tournament_name: a[:tournament_name],
        tournament_place: a[:tournament_location],
        tournament_start_date: a[:tournament_start_date],
        tournament_end_date: a[:tournament_end_date],
        tournament_surface: a[:tournament_surface]
      )
    end
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
