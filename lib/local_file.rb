# Retrieve contents of local file
class LocalFile
  ROOT = Pathname.new(__dir__).parent.expand_path.freeze

  def self.read(path)
    ROOT.join(path).read.b
  end
end
