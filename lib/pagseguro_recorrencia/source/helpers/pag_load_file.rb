def load_file(path)
  file = nil
  root_path = File.dirname(File.absolute_path(__FILE__))
  file_path = File.join(File.dirname(root_path), path)

  if path.include? '.yaml'
    yaml_load = YAML.safe_load(File.read(file_path))
    file = HashWithIndifferentAccess.new(yaml_load)
  else
    file = File.read(file_path)
  end

  file
end
