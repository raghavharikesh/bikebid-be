class CreateBikeQuestionsAndReviews < ActiveRecord::Migration[8.0]
  def change
    create_table :bike_questions do |t|
      t.references :bike, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.text    :content,  null: false
      t.text    :answer
      t.boolean :is_public, default: true
      t.timestamps
    end

    create_table :reviews do |t|
      t.references :bike, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :rating, null: false
      t.text    :comment
      t.timestamps
    end
  end
end
