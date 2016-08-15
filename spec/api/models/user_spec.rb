RSpec.describe API::Models::User do
  let(:username) { 'uname' }
  let(:password) { 'pword' }

  it '..' do
    described_class.create(username: username, password: password)
    expect(DB[:users].count).to eql 1
  end
end
