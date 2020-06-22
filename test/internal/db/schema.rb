# frozen_string_literal: true

ActiveRecord::Schema.define do
  create_table :stance_event_records do |t|
    t.string :name
    t.string :subject_type
    t.integer :subject_id
    t.text :metadata
    t.timestamps
  end

  create_table :appointments do |t|
    t.integer :user_id
    t.timestamps
  end

  create_table :users do |t|
    t.string :name
    t.timestamps
  end
end
