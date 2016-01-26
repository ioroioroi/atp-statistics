class Player < ActiveRecord::Base
  def self.create_records(players)
    players.each do |player|
      begin
        if Player.exists?(name: player[:name])
          logger.info "Record Duplicate. Skip."
          next
        end

        Player.create(player)
      rescue => e
        logger.info "#{e}"
      end
    end
  end

  def self.convert_name_from_url_name(url_name)
    Player.where(url_name: url_name).take.name
  end
end
