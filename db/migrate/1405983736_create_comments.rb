class CreateComments < ActiveRecord::Migration
  def up
    create_table :comments do |t|
      t.references :message
      t.string  :comment

    end
  end

  def down
    # add reverse migration code here
  end
end
