set hw [lindex [get_hardware_names] 0]
set dev [lindex [get_device_names -hardware_name $hw] 0]
begin_memory_edit -device_name $dev -hardware_name $hw
update_content_to_memory_from_file -instance_index 0 -mem_file_path code.mif -mem_file_type mif
end_memory_edit
