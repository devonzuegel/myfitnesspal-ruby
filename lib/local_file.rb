# Retrieve contents of local file
class LocalFile
  ROOT = Pathname.new(__dir__).parent.expand_path.freeze

  def self.read(path)
    ROOT.join(path).read.b
  end

  def self.write_binary(path, binary_content)
    File.open(ROOT.join(path), 'wb') { |f| f.write(binary_content) }
  end
end
