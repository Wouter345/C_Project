set script_dir [file dirname [info script]]
set origin_dir "$script_dir/.."


create_project project_hw $origin_dir/project_hw -part xc7z020clg400-1
set_property board_part tul.com.tw:pynq-z2:part0:1.0 [current_project]


# Set IP repository paths
set_property ip_repo_paths "[file normalize $origin_dir/project_ipcores] [file normalize $origin_dir/project_ipcores]" [get_filesets sources_1]

# Rebuild user ip_repo's index before adding any source files
update_ip_catalog






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

# update_compile_order -help
# update_compile_order -fileset sim_1
