module FixtureHelpers
  def fixture(filename)
    dir_path = %w[spec support fixtures]
    LocalFile::ROOT.join(*dir_path, filename)
  end

  def fake_http(fake_body)
    fake_response = instance_double(HTTP::Response, body: fake_body)
    fake_client   = instance_double(HTTP::Client, post: fake_response)
    class_double(HTTP, headers: fake_client)
  end
end
