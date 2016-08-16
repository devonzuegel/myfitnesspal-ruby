RSpec.describe API::Models::User, :db do
  describe '#create' do
    it 'adds a user to the db' do
      expect { described_class.create(username: 'uname', password: 'foo') }
        .to change { DB[:users].count }
        .by 1
    end

    it 'fails when not given a username' do
      expect { described_class.create(password: 'foo') }
        .to raise_error(Sequel::ValidationFailed, 'username is not present')
    end

    it 'fails when not given a password' do
      expect { described_class.create(username: 'foo') }
        .to raise_error(Sequel::ValidationFailed, 'password is not present')
    end

    it 'fails when a duplicate user is added' do
      used_username = 'existing-uname'
      described_class.create(username: used_username, password: 'foo')

      expect { described_class.create(username: used_username, password: 'bar') }
        .to raise_error(Sequel::ValidationFailed, 'username is already taken')
    end
  end
end
