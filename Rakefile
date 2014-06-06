def subfolders; ['Spec', 'Example']; end

def subperform(command)
  subfolders.each do |subfolder|
    Dir.chdir(subfolder) do
      sh "rake #{command}"
    end
  end
end

task :default => :test

task :ci => [:clobber, :test]

task :clobber do
  subperform(:clobber)
end

task :clean do
  subperform(:clean)
end

task :test do
  subperform(:test)
end

task :coverage do
  excludes = ['.*/Classes/.*\.h'] + subfolders.map { |subfolder| ".*/#{subfolder}/.*" }
  sh "coveralls #{excludes.map { |exclude| "-E '#{exclude}'" }.join(' ')}"
end
