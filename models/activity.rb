class Activity < ActiveRecord::Base
  def self.create_records(activities)
    activities.each do |activity|
      begin
        if Activity.exists?(
          year: activity[:year],
          player_name: activity[:player_name],
          opponent_name: activity[:opponent_name],
          round: activity[:round],
          tournament_name: activity[:tournament_name]
        )
          logger.info "Record Duplicate. Skip."
          next
        end

        Activity.create(activity)
      rescue => e
        logger.info "#{e}"
      end
    end
  end
end
