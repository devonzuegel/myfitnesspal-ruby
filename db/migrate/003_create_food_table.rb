Sequel.migration do
  up do
    extension(:constraint_validations)
    create_table(:food) do
      primary_key :id

      Integer :master_food_id, null: false, unique: true
      String  :description,    null: false
      String  :brand,          null: false
      Float   :calories,       null: false
      Float   :grams,          null: false
      Text    :serialized,     null: false # TODO text or string????????????????? YAML?????????????

      validate do
        min_length 50, :serialized
      end
    end
  end

  down do
    drop_table(:food)
  end
end
