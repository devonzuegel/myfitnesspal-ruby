Sequel.migration do
  NO_SPACES = /^\S*$/

  up do
    extension(:constraint_validations)
    create_table(:users) do
      primary_key :id

      String :username, null: false, unique: true
      String :password, null: false

      validate do
        length_range 4..30, :username
        format NO_SPACES, :username

        length_range 6..255, :password
        format NO_SPACES, :password
      end
    end
  end

  down do
    drop_table(:users)
  end
end
