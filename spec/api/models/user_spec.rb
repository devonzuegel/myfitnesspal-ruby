RSpec.describe API::Models::User do
  let(:username) { 'uname' }
  let(:password) { 'pword' }

  it '..' do
    DB[:users].where(username: /.*/).delete
    described_class.create(username: username, password: password)
    expect(DB[:users].count).to eql 1
    DB[:users].where(username: /.*/).delete
  end
end
