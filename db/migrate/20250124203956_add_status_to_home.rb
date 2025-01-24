class AddStatusToHome < ActiveRecord::Migration[7.1]

  def change
    change_table :homes do |t|
      t.string :status, default: "pending", null: false, index: true
    end
  end

end
