require 'FileUtils'
include FileTest

def writeFilePath(file, paths_file_location, file_path)
  f = File.open(paths_file_location, "a")
  f.puts(file_path + "\n")
end

def copyFile(file_path, copy_dir)
  FileUtils.cp(file_path, copy_dir)
end

def searchFolders(file_extension, paths_file_location, copy_dir, matching_files_folder) # *add a 'true/false' flag to determine if we should copy the files or not
  # get each file in this directory that has the required extension   
  matching_files = Dir["*." + file_extension]
  matching_files.each do |file|
    file_path = File.absolute_path(file)
    writeFilePath(file, paths_file_location, file_path)
    copyFile(file_path, copy_dir)
  end
  # get each directory inside the current directory, excluding the copy directory
  folders = Dir.entries(Dir.getwd).select{ |i| File.directory?(i) and i.index(/^\./) === nil and i.to_s != matching_files_folder }
  # for each directory
  if folders.any?
    folders.each do |folder|
      # open that folder and run search function on it
      Dir.chdir(File.absolute_path(folder))
        searchFolders(file_extension, paths_file_location, copy_dir, matching_files_folder)
      Dir.chdir("..")
    end
  end
end

def init # *something's up with using initialize
  file_extension = "pdf"
  matching_files_folder = "matching-files"
  # make current directory the search directory
  search_dir = Dir.getwd
  Dir.chdir(search_dir)
  # create a new directory inside the search directory -- *needs error handling if dir already exists
  Dir.mkdir(matching_files_folder)
  # create a text file in the new directory (paths file)
  Dir.chdir("./" + matching_files_folder)
  paths_file = File.new("./paths.txt", "w+")
  paths_file_location = File.absolute_path(paths_file)
  Dir.mkdir("files")
  Dir.chdir("./files")
  copy_dir = Dir.getwd
  # get back into search directory
  Dir.chdir(search_dir)
  # run search function
  searchFolders(file_extension, paths_file_location, copy_dir, matching_files_folder)
end
init()