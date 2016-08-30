class LocalFile
  ROOT = Pathname.new(__dir__).parent.expand_path.freeze

  def self.read(path)
    ROOT.join(path).read.b
  end

  def self.write_binary(path, binary_content)
    File.open(ROOT.join(path), 'wb') { |f| f.write(binary_content) }
  end

  def self.dump_yml(path, object)
    contents = YAML.dump(object)
    File.open(path, 'w') { |f| f.write(contents) }
  end

  def self.read_yml(path)
    YAML.load(File.read(path))
  end
end
