# DynamoDB Table otimizada para FREE TIER
resource "aws_dynamodb_table" "users" {
  name         = "${var.project_name}-users"
  billing_mode = "PAY_PER_REQUEST" # FREE TIER: On-demand é gratuito até 25GB
  hash_key     = "userId"

  attribute {
    name = "userId"
    type = "S"
  }

  # FREE TIER: Point-in-time recovery desabilitado (pode gerar custos)
  point_in_time_recovery {
    enabled = false
  }

  # FREE TIER: Server-side encryption padrão (gratuito)
  server_side_encryption {
    enabled = true
  }

  tags = {
    Name = "${var.project_name}-users"
    Tier = "free"
  }
}
