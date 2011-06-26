Gem::Specification.new do |s|
  s.author = "Ryan Scott Lewis"
  s.email = "c00lryguy@gmail.com"
  s.homepage = "http://github.com/c00lryguy/rulebook"
  
  s.description = "Allows you to define a set of 'rules' or dynamic methods to apply to a class."
  s.summary = "Define methods with regex for dynamic methods."
  
  s.require_paths = ["lib"]
  
  s.name = File.basename(__FILE__, ".gemspec")
  s.version = File.read("VERSION")
  # VERSIONING
  # Some people like to use a YAML file to display the version, some like CSV,
  # others might just add a constant set to a version string, some (Rack) might
  # even have an array splitting the version into parts.
  # Just edit the above line appropriately.
  # An easy thing to do is set a constant within your app to a version string
  # and use it in here
  
  # Add directories you *might* use in ALL projects.
  s.files = [File.basename(__FILE__)] + Dir['lib/**/*'] + Dir['bin/**/*'] + Dir['test/**/*'] + Dir['examples/**/*'] + Dir['spec/**/*']
  
  # Add files you *might* use in ALL projects!
  %W{Gemfile.lock README.* README Rakefile VERSION LICENSE}.each do |file|
    s.files.unshift(file) if File.exists?(file)
  end
  
  # Add files you *might* use in ALL projects!
  %W{README.* README VERSION LICENSE LICENSE.*}.each do |file|
    (s.extra_rdoc_files ||= []).unshift(file) if File.exists?(file)
  end
  
  # s.executables = ["bin/myapp.rb"]
  
  # If you only specify one application file in executables, that file becomes 
  # the default executable. Therefore, you only need to specify this value if you 
  # have more than one application file. 
  if s.executables.length > 1
    if exe = s.executables.find { |e| e.include?(File.basename(__FILE__, ".gemspec")) }
      s.default_executable = exe
    else
      raise(Exception, "Couldn't automatically figure out the default_executable")
    end
  end
  
  s.test_files = Dir['test/**/*'] + Dir['examples/**/*'] + Dir['spec/**/*']
  
  s.add_dependency("meta_tools", "0.2.3")
  s.add_development_dependency("rake", "0.9.2")
  s.add_development_dependency("riot", "0.12.4")
  s.add_development_dependency("rspec", "2.6.0")
  s.add_development_dependency("shoulda", "2.11.3")
  s.add_development_dependency("mocha", "0.9.12")
end