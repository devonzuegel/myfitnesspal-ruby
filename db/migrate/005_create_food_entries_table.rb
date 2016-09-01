Sequel.migration do
  up do
    extension(:constraint_validations)
    create_table(:food_entries) do
      primary_key :id

      Date   :date,       null: false
      String :meal_name,  null: false
      Float  :quantity,   null: false
      Text   :serialized, null: false

      validate do
        min_length 50, :serialized
      end
    end
  end

  down do
    drop_table(:food_entries)
  end
end
