module FixtureHelpers
  def fixture(filename)
    dir_path = %w[spec support fixtures]
    LocalFile::ROOT.join(*dir_path, filename)
  end
end
