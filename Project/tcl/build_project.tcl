set script_dir [file dirname [info script]]
set origin_dir "$script_dir/.."


create_project project_hw $origin_dir/project_hw 

proc add_src_files {filename} {
  set fp [open $filename r]
  if { $fp == -1 } {
    puts stderr "Error: Couldn't open file '$filename'"
    return
  }

  set index 0
  while { [eof $fp] == 0 } {
	set line [gets $fp]
	# Remove leading/trailing whitespace
	set path [string trim $line]
	add_files -fileset sources_1 $path
	incr index
  }

  close $fp
}


add_src_files "src/sourcefile_order"

set fileset [get_filesets sources_1]

# Get the list of files in the fileset
set files [get_files -of_objects $fileset]

# Print the files in the fileset
puts "Files in sources_1:"
foreach file $files {
    puts "  $file"
}

set_property top tbench_top [get_filesets sources_1] 
set_property top tbench_top [get_filesets sim_1] 

set_property source_mgmt_mode DisplayOnly [current_project]
