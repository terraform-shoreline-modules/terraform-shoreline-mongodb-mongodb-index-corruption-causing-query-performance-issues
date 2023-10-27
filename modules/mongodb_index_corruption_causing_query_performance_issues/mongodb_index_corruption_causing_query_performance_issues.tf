resource "shoreline_notebook" "mongodb_index_corruption_causing_query_performance_issues" {
  name       = "mongodb_index_corruption_causing_query_performance_issues"
  data       = file("${path.module}/data/mongodb_index_corruption_causing_query_performance_issues.json")
  depends_on = [shoreline_action.invoke_backup_script,shoreline_action.invoke_rebuild_indexes]
}

resource "shoreline_file" "backup_script" {
  name             = "backup_script"
  input_file       = "${path.module}/data/backup_script.sh"
  md5              = filemd5("${path.module}/data/backup_script.sh")
  description      = "Perform a complete backup of the database before attempting any remediation procedures."
  destination_path = "/tmp/backup_script.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "rebuild_indexes" {
  name             = "rebuild_indexes"
  input_file       = "${path.module}/data/rebuild_indexes.sh"
  md5              = filemd5("${path.module}/data/rebuild_indexes.sh")
  description      = "If the index corruption is not easily fixable, consider rebuilding the indexes from scratch. This can be done using the "reindex" command in MongoDB."
  destination_path = "/tmp/rebuild_indexes.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_backup_script" {
  name        = "invoke_backup_script"
  description = "Perform a complete backup of the database before attempting any remediation procedures."
  command     = "`chmod +x /tmp/backup_script.sh && /tmp/backup_script.sh`"
  params      = ["DB_NAME","DATABASE_NAME","BACKUP_DIRECTORY","DATABASE_HOST"]
  file_deps   = ["backup_script"]
  enabled     = true
  depends_on  = [shoreline_file.backup_script]
}

resource "shoreline_action" "invoke_rebuild_indexes" {
  name        = "invoke_rebuild_indexes"
  description = "If the index corruption is not easily fixable, consider rebuilding the indexes from scratch. This can be done using the "reindex" command in MongoDB."
  command     = "`chmod +x /tmp/rebuild_indexes.sh && /tmp/rebuild_indexes.sh`"
  params      = ["COLLECTION_NAME","DB_NAME","DATABASE_NAME"]
  file_deps   = ["rebuild_indexes"]
  enabled     = true
  depends_on  = [shoreline_file.rebuild_indexes]
}

