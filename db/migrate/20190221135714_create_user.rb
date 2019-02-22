class CreateUser < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :email, index: { unique: true }
      t.string :first_name
      t.string :last_name
      t.string :password_digest
      t.boolean :is_admin, default: false

      t.timestamps
    end
  end
end
