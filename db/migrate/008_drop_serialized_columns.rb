Sequel.migration do
  tables = %i[food_entries food_portions foods]

  up do
    tables.each do |table|
      alter_table(table) { drop_column(:serialized) }
    end
  end

  down do
    tables.each do |table|
      alter_table(table) { add_column(:serialized, :text, null: false) }
    end
  end
end
