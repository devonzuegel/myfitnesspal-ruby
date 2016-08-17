# TODO: remove file if no longer using Sequel (replaced with ROM)
RSpec.shared_context 'db context', shared_context: :metadata do
  let(:db) { Sequel.connect(ENV['DATABASE_CONNECTION']) }

  around(:each) do |t|
    db.transaction(rollback: :always, auto_savepoint: true) { t.run }
  end
end
