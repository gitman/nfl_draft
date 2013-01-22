class AddChosenToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :chosen, :boolean, :default => false
  end
end
