# Retrieve contents of local file
class LocalFile
  def self.read(path)
    full_path = Pathname.new(__dir__).join("../#{path}").expand_path
    File.read(full_path).force_encoding('ASCII-8BIT')
  end
end