RSpec.shared_context 'db context', shared_context: :metadata do
  let(:db)         { Sequel.connect(ENV['DATABASE_URL']) }
  let(:repository) { ROM.container(ROM::Configuration.new(:sql, db)) }

  around do |t|
    db.transaction(rollback: :always, auto_savepoint: true) { t.run }
  end
end
