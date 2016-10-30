Sequel.migration do
  up do
    create_table(:last_sync_info) do
      primary_key :id
      foreign_key :user_id, :users, null: false

      Date :date,            null: false
      Text :serialized_ptrs, null: false
    end
  end

  down do
    drop_table(:last_sync_info)
  end
end
