class CreateActivities < ActiveRecord::Migration
  def self.up
    create_table :activities do |t|
      t.string :player_name
      t.string :player_ranking
      t.string :opponent_name
      t.string :opponent_ranking
      t.string :round
      t.string :score
      t.string :win_loss
      t.string :tournament_name
      t.string :tournament_place
      t.string :tournament_date
      t.string :tournament_surface
      t.timestamps
    end
  end

  def self.down
    drop_table :activities
  end
end
