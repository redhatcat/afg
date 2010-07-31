class CreateWarDiaries < ActiveRecord::Migration
  def self.up
    create_table :war_diaries do |t|
      t.string "reportkey"
      t.string "reportdate"
      t.string "reporttype"
      t.string "category"
      t.string "trackingnumber"
      t.text   "title"
      t.text   "summary"
      t.string "region"
      t.string "attackon"
      t.string "complexattack"
      t.string "reportingunit"
      t.string "unitname"
      t.string "typeofunit"
      t.string "friendlywia"
      t.string "friendlykia"
      t.string "hostnationwia"
      t.string "hostnationkia"
      t.string "civilianwia"
      t.string "civiliankia"
      t.string "enemywia"
      t.string "enemykia"
      t.string "enemydetained"
      t.string "mgrs"
      t.string "latitude"
      t.string "longitude"
      t.string "originatorgroup"
      t.string "updatedbygroup"
      t.string "ccir"
      t.string "sigact"
      t.string "affiliation"
      t.string "dcolor"
      t.string "classification"
    end
  end

  def self.down
    drop_table :war_diaries
  end
end
