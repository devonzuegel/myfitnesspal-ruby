describe API::Repo::User, :db do
  let(:user_repo) { described_class.new(repository) }
  let(:attrs)     { { username: 'username', password: 'password' } }
  let(:duplicate) { { username: 'duplicate-username', password: 'password', id: -1 } }

  before { db[:users].insert(duplicate) }

  describe '#create' do
    it 'adds a user to the db' do
      expect { user_repo.create(attrs) }
        .to change { db[:users].count }
        .by(1)
    end

    it 'fails when not given a username' do
      expect { user_repo.create(password: 'foo') }
        .to raise_error(ROM::SQL::NotNullConstraintError)
    end

    it 'fails when not given a password' do
      expect { user_repo.create(username: 'foo') }
        .to raise_error(ROM::SQL::NotNullConstraintError)
    end

    it 'fails when a duplicate user is added' do
      expect { user_repo.create(username: duplicate[:username], password: 'bar') }
        .to raise_error(ROM::SQL::CheckConstraintError)
    end

    it 'raises an error if the given username is not unique' do
      expect { user_repo.create(duplicate) }
        .to raise_error(ROM::SQL::UniqueConstraintError)
    end
  end

  describe '#query' do
    it '#query' do
      expect(user_repo.query(username: duplicate[:username]))
        .to eql([API::Models::User.new(duplicate)])
    end

    it '#query' do
      expect(user_repo.query(username: 'username-that-doesnt-exist'))
        .to eql([])
    end
  end

  describe '#available?' do
    it 'is false when the username is taken' do
      expect(user_repo.available?(username: 'duplicate-username')).to eql false
    end

    it 'is true when the username does not yet exist' do
      expect(user_repo.available?(username: 'available-username')).to eql true
      expect(user_repo.available?(username: 'available-username', x: 1)).to eql true
    end

    it 'handles (but ignores) keywords besides :username' do
      expect(user_repo.available?(username: 'available-username', x: 1)).to eql true
    end

    it 'fails if :username is not provided' do
      expect { user_repo.available?(x: 1) }
        .to raise_error(KeyError, 'key not found: :username')
    end
  end
end
