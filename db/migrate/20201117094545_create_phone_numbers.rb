class CreatePhoneNumbers < ActiveRecord::Migration[5.2]
  def change
    create_table :phone_numbers do |t|
      t.bigint :number
      t.references :account, foreign_key: true

    end
  end
end
