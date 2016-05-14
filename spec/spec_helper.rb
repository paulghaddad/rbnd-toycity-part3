PROJECT_ROOT = File.expand_path("../..", __FILE__)

lib_files = Dir.glob(File.join(PROJECT_ROOT, "lib", "*.rb"))

lib_files.each do |file|
  require file
end

