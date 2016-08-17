describe API::Schema::User do
  describe 'Creation' do
    let(:schema)         { described_class::Creation }
    let(:valid_username) { 'bazz' }
    let(:valid_password) { 'foobar' }

    context 'valid input' do
      let(:valid_params) { { username: valid_username, password: valid_password } }

      it 'outputs the provided valid params' do
        expect(schema.call(valid_params).output).to eql valid_params
      end

      it 'outputs no messages' do
        expect(schema.call(valid_params).messages).to eql({})
      end

      it 'succeed' do
        expect(schema.call(valid_params).success?).to eql true
      end
    end

    context 'invalid username' do
      it 'fails when not given a username' do
        expect(schema.call(password: 'foobar').messages)
          .to eql(username: ['is missing', 'size must be within 4 - 30'])
      end

      it 'fails when given a non-string username' do
        expect(schema.call(username: { foo: 'bar' }, password: valid_password).messages)
          .to eql(username: ['must be a string', 'size must be within 4 - 30'])
      end

      it 'fails when given an empty username' do
        expect(schema.call(username: '', password: valid_password).messages)
          .to eql(username: ['must be filled', 'size must be within 4 - 30'])
      end

      it 'fails when given an empty username' do
        expect(schema.call(username: 'a', password: valid_password).messages)
          .to eql(username: ['length must be within 4 - 30'])
      end
    end

    context 'invalid password' do
      it 'fails when not given a password' do
        expect(schema.call(username: valid_username).messages)
          .to eql(password: ['is missing', 'size must be within 6 - 255'])
      end

      it 'fails when given a non-string password' do
        expect(schema.call(username: valid_username, password: { foo: 'bar' }).messages)
          .to eql(password: ['must be a string', 'size must be within 6 - 255'])
      end

      it 'fails when given an empty password' do
        expect(schema.call(username: valid_username, password: '').messages)
          .to eql(password: ['must be filled', 'size must be within 6 - 255'])
      end
    end
  end
end
