class CreateTokenCreateds < ActiveRecord::Migration[5.2]
  def change
    create_table :token_createds do |t|
      t.string :tokenId, :unique => true

      t.timestamps
    end
  end
end
