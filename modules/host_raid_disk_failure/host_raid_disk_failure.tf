resource "shoreline_notebook" "host_raid_disk_failure" {
  name       = "host_raid_disk_failure"
  data       = file("${path.module}/data/host_raid_disk_failure.json")
  depends_on = [shoreline_action.invoke_replace_disk_rebuild_array]
}

resource "shoreline_file" "replace_disk_rebuild_array" {
  name             = "replace_disk_rebuild_array"
  input_file       = "${path.module}/data/replace_disk_rebuild_array.sh"
  md5              = filemd5("${path.module}/data/replace_disk_rebuild_array.sh")
  description      = "Replace the failed disk in the RAID array and rebuild the array."
  destination_path = "/agent/scripts/replace_disk_rebuild_array.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_replace_disk_rebuild_array" {
  name        = "invoke_replace_disk_rebuild_array"
  description = "Replace the failed disk in the RAID array and rebuild the array."
  command     = "`chmod +x /agent/scripts/replace_disk_rebuild_array.sh && /agent/scripts/replace_disk_rebuild_array.sh`"
  params      = ["BACKUP_FILE","FAILED_DISK","NUMBER_OF_DISKS","NEW_DISK"]
  file_deps   = ["replace_disk_rebuild_array"]
  enabled     = true
  depends_on  = [shoreline_file.replace_disk_rebuild_array]
}

