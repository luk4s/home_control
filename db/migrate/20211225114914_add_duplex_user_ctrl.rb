class AddDuplexUserCtrl < ActiveRecord::Migration[6.1]

  def change
    add_column :homes, :duplex_user_ctrl, :jsonb
  end

end
