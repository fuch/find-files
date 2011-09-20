require 'FileUtils'
include FileTest

def searchFolders(file_extension, paths_file_location, copy_dir) # *add a 'true/false' flag to determine if we should copy the files or not
  # get each file in this directory that has the required extension   
  matching_files = Dir["*." + file_extension]
  # for each of these entries
  matching_files.each do |file|
    # get the file's path and add it to the paths file
    file_path = File.absolute_path(file)
    f = File.open(paths_file_location, "a")
    f.puts(file_path + "\n")
    # copy that file into the matching files directory
    FileUtils.cp(file_path, copy_dir)
  end
  # get each directory inside the current directory
  folders = Dir.entries(Dir.getwd).select{ |i| File.directory?(i) and !(i == '.' || i == '..') and !(File.absolute_path(i) == File.absolute_path(copy_dir)) }
  puts folders
   # for each directory
    # open that folder and run search function on it
end

def init # *something's up with using initialize
  file_extension = "pdf"
  # make current directory the search directory
  search_dir = Dir.getwd
  Dir.chdir(search_dir)
  # create a new directory inside the search directory -- *needs error handling if dir already exists
  Dir.mkdir("matching-files")
  # create a text file in the new directory (paths file)
  Dir.chdir("./matching-files")
  paths_file = File.new("./paths.txt", "w+")
  paths_file_location = File.absolute_path(paths_file)
  Dir.mkdir("files")
  Dir.chdir("./files")
  copy_dir = Dir.getwd
  # get back into search directory
  Dir.chdir(search_dir)
  # run search function
  searchFolders(file_extension, paths_file_location, copy_dir)
end
init()