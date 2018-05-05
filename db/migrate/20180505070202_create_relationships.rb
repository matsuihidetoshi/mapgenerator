class CreateRelationships < ActiveRecord::Migration[5.0]
  def change
    create_table :relationships do |t|
      t.references :part, foreign_key: true
      t.references :relate, foreign_key: { to_table: :parts }

      t.timestamps
      
      t.index [:part_id, :relate_id], unique: true
    end
  end
end
