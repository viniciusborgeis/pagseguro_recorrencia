def load_file(path)
  root_path = File.dirname(File.absolute_path(__FILE__))
  file_path = File.join(File.dirname(root_path), path)
  File.read(file_path)
end
