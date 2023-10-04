resource "shoreline_notebook" "postgres_connection_limit_reached" {
  name       = "postgres_connection_limit_reached"
  data       = file("${path.module}/data/postgres_connection_limit_reached.json")
  depends_on = [shoreline_action.invoke_set_max_connections]
}

resource "shoreline_file" "set_max_connections" {
  name             = "set_max_connections"
  input_file       = "${path.module}/data/set_max_connections.sh"
  md5              = filemd5("${path.module}/data/set_max_connections.sh")
  description      = "Increase the maximum number of connections allowed by the Postgres database. This can be done in the postgresql.conf file by modifying the max_connections parameter."
  destination_path = "/agent/scripts/set_max_connections.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_set_max_connections" {
  name        = "invoke_set_max_connections"
  description = "Increase the maximum number of connections allowed by the Postgres database. This can be done in the postgresql.conf file by modifying the max_connections parameter."
  command     = "`chmod +x /agent/scripts/set_max_connections.sh && /agent/scripts/set_max_connections.sh`"
  params      = ["DESIRED_MAXIMUM_CONNECTIONS","VERSION"]
  file_deps   = ["set_max_connections"]
  enabled     = true
  depends_on  = [shoreline_file.set_max_connections]
}

