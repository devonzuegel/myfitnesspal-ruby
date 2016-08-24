describe API::Repo::User, :db do
  let(:repo)      { described_class.new(repository) }
  let(:attrs)     { { username: 'username', password: 'password' } }
  let(:duplicate) { { username: 'duplicate-username', password: 'password' } }

  before { db[:users].insert(duplicate) }

  describe '#create' do
    it 'adds a user to the db' do
      expect { repo.create(attrs) }
        .to change { db[:users].count }
        .by(1)
    end

    it 'fails when not given a username' do
      expect { repo.create(password: 'foo') }
        .to raise_error(ROM::SQL::NotNullConstraintError)
    end

    it 'fails when not given a password' do
      expect { repo.create(username: 'foo') }
        .to raise_error(ROM::SQL::NotNullConstraintError)
    end

    it 'fails when a duplicate user is added' do
      expect { repo.create(username: duplicate[:username], password: 'bar') }
        .to raise_error(ROM::SQL::CheckConstraintError)
    end

    it 'raises an error if the given username is not unique' do
      expect { repo.create(duplicate) }
        .to raise_error(ROM::SQL::UniqueConstraintError)
    end
  end

  describe '#query' do
    it '#query' do
      expect(repo.query(username: duplicate[:username]).count)
        .to be(1)
    end
  end
end
