describe API::Schema::User do
  describe 'Creation' do
    let(:repo)           { instance_double(API::Repo::User, available?: true) }
    let(:schema)         { described_class::Creation }
    let(:valid_username) { 'bazz' }
    let(:valid_password) { 'foobar' }

    context 'valid input' do
      let(:valid_params) { { username: valid_username, password: valid_password } }

      it 'outputs the provided valid params' do
        expect(schema.call(valid_params, repo).output).to eql valid_params
      end

      it 'outputs no messages' do
        expect(schema.call(valid_params, repo).messages).to eql({})
      end

      it 'succeed' do
        expect(schema.call(valid_params, repo).success?).to be true
      end
    end

    context 'invalid username' do
      it 'fails when not given a username' do
        params = { password: 'foobar' }
        expect(schema.call(params, repo).messages)
          .to eql(username: ['is missing', 'size must be within 4 - 30'])
      end

      it 'fails when given a non-string username' do
        params = { username: { foo: 'bar' }, password: valid_password }
        expect(schema.call(params, repo).messages)
          .to eql(username: ['must be a string', 'size must be within 4 - 30'])
      end

      it 'fails when given an empty username' do
        params = { username: '', password: valid_password }
        expect(schema.call(params, repo).messages)
          .to eql(username: ['must be filled', 'size must be within 4 - 30'])
      end

      it 'fails when given a too-short username' do
        params = { username: 'a', password: valid_password }
        expect(schema.call(params, repo).messages)
          .to eql(username: ['length must be within 4 - 30'])
      end

      it 'fails when given a too-long username' do
        params = { username: 'a' * 31, password: valid_password }
        expect(schema.call(params, repo).messages)
          .to eql(username: ['length must be within 4 - 30'])
      end

      it 'fails when given a duplicate username' do
        duplicate_repo = instance_double(API::Repo::User, available?: false)
        params = { username: 'aaaaaa', password: valid_password }
        expect(schema.call(params, duplicate_repo).messages)
          .to eql(username: ['has already been taken'])
        expect(duplicate_repo).to have_received(:available?).with(params)
      end
    end

    context 'invalid password' do
      it 'fails when not given a password' do
        params = { username: valid_username }
        expect(schema.call(params, repo).messages)
          .to eql(password: ['is missing', 'size must be within 6 - 255'])
      end

      it 'fails when given a non-string password' do
        params = { username: valid_username, password: { foo: 'bar' } }
        expect(schema.call(params, repo).messages)
          .to eql(password: ['must be a string', 'size must be within 6 - 255'])
      end

      it 'fails when given a too-short password' do
        params = { username: valid_username, password: 'x' }
        expect(schema.call(params, repo).messages)
          .to eql(password: ['length must be within 6 - 255'])
      end

      it 'fails when given a too-long password' do
        params = { username: valid_username, password: 'x' * 256 }
        expect(schema.call(params, repo).messages)
          .to eql(password: ['length must be within 6 - 255'])
      end

      it 'fails when given an empty password' do
        params = { username: valid_username, password: '' }
        expect(schema.call(params, repo).messages)
          .to eql(password: ['must be filled', 'size must be within 6 - 255'])
      end

      it 'fails when given the incorrect MFP password'
    end
  end
end
