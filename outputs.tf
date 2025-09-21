# Frontend outputs
output "s3_bucket_name" {
  description = "Nome do bucket S3 para frontend"
  value       = aws_s3_bucket.frontend_bucket.bucket
}

output "cloudfront_domain" {
  description = "Domínio do CloudFront"
  value       = aws_cloudfront_distribution.cdn.domain_name
}

output "cloudfront_distribution_id" {
  description = "ID da distribuição CloudFront"
  value       = aws_cloudfront_distribution.cdn.id
}

# API Gateway outputs
output "api_gateway_url" {
  description = "URL base da API (stage prod)"
  value       = aws_api_gateway_stage.api_prod.invoke_url
}

output "api_gateway_id" {
  description = "ID do API Gateway"
  value       = aws_api_gateway_rest_api.api.id
}

output "api_key" {
  description = "API Key para acesso à API (sensível)"
  value       = aws_api_gateway_api_key.api_key.value
  sensitive   = true
}

output "api_key_id" {
  description = "ID da API Key"
  value       = aws_api_gateway_api_key.api_key.id
}

# Security outputs
output "lambda_log_group" {
  description = "Nome do log group do Lambda"
  value       = aws_cloudwatch_log_group.lambda_logs.name
}

output "api_log_group" {
  description = "Nome do log group do API Gateway"
  value       = aws_cloudwatch_log_group.api_gateway_logs.name
}

# Usage information (FREE TIER)
output "usage_instructions" {
  description = "Instruções de uso da API (FREE TIER)"
  value       = <<-EOT
    🆓 FREE TIER Configuration Active!
    
    Para usar a API:
    1. Use a URL: ${aws_api_gateway_stage.api_prod.invoke_url}
    2. Inclua o header: X-API-Key: ${aws_api_gateway_api_key.api_key.value}
    3. Configure autenticação IAM para suas requisições
    
    Endpoints disponíveis:
    - GET /users (listar usuários)
    - POST /users (criar usuário)
    - GET /users/{id} (buscar usuário específico)
    
    FREE TIER Limits:
    - API Gateway: 1M requests/mês, 10 req/seg
    - Lambda: 1M requests/mês, 400K GB-segundos
    - DynamoDB: 25GB storage, gratuito
    - S3: 5GB storage, 20K GET, 2K PUT
    - CloudFront: 1TB transfer, 10M requests
    - CloudWatch: 5GB logs, 7 dias retenção
  EOT
  sensitive   = true
}

# FREE TIER monitoring outputs
output "free_tier_limits" {
  description = "Limites do FREE TIER configurados"
  value = {
    api_gateway = {
      monthly_requests = "1,000,000"
      rate_limit       = "10 req/sec"
      burst_limit      = "20 req/sec"
    }
    lambda = {
      monthly_requests = "1,000,000"
      monthly_compute  = "400,000 GB-seconds"
      memory_size      = "128 MB"
      timeout          = "30 seconds"
    }
    dynamodb = {
      storage        = "25 GB"
      billing_mode   = "PAY_PER_REQUEST"
      backup_enabled = false
    }
    s3 = {
      storage      = "5 GB"
      get_requests = "20,000"
      put_requests = "2,000"
    }
    cloudwatch = {
      log_storage = "5 GB"
      retention   = "7 days"
    }
  }
}
