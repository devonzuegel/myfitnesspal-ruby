Sequel.migration do
  up do
    extension(:constraint_validations)
    create_constraint_validations_table
  end

  down do
    extension(:constraint_validations)
    drop_table(:sequel_constraint_validations)
  end
end
