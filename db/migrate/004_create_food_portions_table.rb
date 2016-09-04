Sequel.migration do
  up do
    extension(:constraint_validations)
    create_table(:food_portions) do
      primary_key :id
      foreign_key :food_id, :foods, null: false

      Integer :options_index, null: false
      String  :description,   null: false
      Float   :amount,        null: false
      Float   :gram_weight,   null: false
      Text    :serialized,    null: false

      validate do
        min_length 50, :serialized
      end
    end
  end

  down do
    drop_table(:food_portions)
  end
end
