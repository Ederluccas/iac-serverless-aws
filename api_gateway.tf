# API Gateway com configurações de segurança avançadas
resource "aws_api_gateway_rest_api" "api" {
  name        = "${var.project_name}-api"
  description = "Secure API Gateway for Lambda backend"

  # Configurações de segurança
  minimum_compression_size = 1024

  # Policy para restringir acesso (exemplo: apenas IPs específicos)
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = "execute-api:Invoke"
        Resource  = "*"
        # Uncomment to restrict by IP:
        # Condition = {
        #   IpAddress = {
        #     "aws:SourceIp" = ["203.0.113.0/24", "198.51.100.0/24"]
        #   }
        # }
      }
    ]
  })

  endpoint_configuration {
    types = ["REGIONAL"] # Mais seguro que EDGE para controle regional
  }

  tags = {
    Name        = "${var.project_name}-api"
    Environment = "production"
    ManagedBy   = "Terraform"
  }
}

# API Key para controle de acesso (boa prática)
resource "aws_api_gateway_api_key" "api_key" {
  name        = "${var.project_name}-api-key"
  description = "API Key for ${var.project_name}"
  enabled     = true

  tags = {
    Name = "${var.project_name}-api-key"
  }
}

# Usage Plan otimizado para FREE TIER
resource "aws_api_gateway_usage_plan" "api_usage_plan" {
  name        = "${var.project_name}-usage-plan"
  description = "FREE TIER Usage plan for ${var.project_name} API"

  # Rate limiting (FREE TIER - 1M requests/mês)
  api_stages {
    api_id = aws_api_gateway_rest_api.api.id
    stage  = aws_api_gateway_stage.api_prod.stage_name
  }

  # Throttling configuration (FREE TIER otimizado)
  throttle_settings {
    rate_limit  = 10 # requests per second (reduzido para FREE TIER)
    burst_limit = 20 # burst capacity (reduzido para FREE TIER)
  }

  # Quota configuration (FREE TIER - 1M requests/mês)
  quota_settings {
    limit  = 1000000 # 1M requests per month (FREE TIER limit)
    period = "MONTH" # Mensal para controle FREE TIER
  }

  tags = {
    Name = "${var.project_name}-usage-plan"
    Tier = "free"
  }
}

# Associar API Key ao Usage Plan
resource "aws_api_gateway_usage_plan_key" "api_usage_plan_key" {
  key_id        = aws_api_gateway_api_key.api_key.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.api_usage_plan.id
}

# Request Validator para validação de entrada
resource "aws_api_gateway_request_validator" "validator" {
  name                        = "${var.project_name}-validator"
  rest_api_id                 = aws_api_gateway_rest_api.api.id
  validate_request_body       = true
  validate_request_parameters = true
}

# Modelo para validação do corpo da requisição
resource "aws_api_gateway_model" "user_model" {
  rest_api_id  = aws_api_gateway_rest_api.api.id
  name         = "UserModel"
  content_type = "application/json"

  schema = jsonencode({
    "$schema" = "http://json-schema.org/draft-04/schema#"
    title     = "User Schema"
    type      = "object"
    properties = {
      name = {
        type      = "string"
        minLength = 1
        maxLength = 100
      }
      email = {
        type   = "string"
        format = "email"
      }
    }
    required = ["name", "email"]
  })
}

# Resource /users
resource "aws_api_gateway_resource" "users" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "users"
}

# Resource /users/{id} para operações específicas
resource "aws_api_gateway_resource" "user_by_id" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_resource.users.id
  path_part   = "{id}"
}

# GET /users - Listar usuários (com autenticação)
resource "aws_api_gateway_method" "get_users" {
  rest_api_id      = aws_api_gateway_rest_api.api.id
  resource_id      = aws_api_gateway_resource.users.id
  http_method      = "GET"
  authorization    = "NONE"    # Alterado para usar apenas API Key
  api_key_required = true      # Requer API Key

  request_parameters = {
    "method.request.querystring.limit"  = false
    "method.request.querystring.offset" = false
  }
}

# POST /users - Criar usuário (com validação)
resource "aws_api_gateway_method" "post_users" {
  rest_api_id      = aws_api_gateway_rest_api.api.id
  resource_id      = aws_api_gateway_resource.users.id
  http_method      = "POST"
  authorization    = "NONE"    # Alterado para usar apenas API Key
  api_key_required = true      # Requer API Key

  request_validator_id = aws_api_gateway_request_validator.validator.id
  request_models = {
    "application/json" = aws_api_gateway_model.user_model.name
  }
}

# GET /users/{id} - Buscar usuário específico
resource "aws_api_gateway_method" "get_user_by_id" {
  rest_api_id      = aws_api_gateway_rest_api.api.id
  resource_id      = aws_api_gateway_resource.user_by_id.id
  http_method      = "GET"
  authorization    = "NONE"    # Alterado para usar apenas API Key
  api_key_required = true

  request_parameters = {
    "method.request.path.id" = true # ID é obrigatório
  }
}

# OPTIONS para CORS (necessário para aplicações web)
resource "aws_api_gateway_method" "options_users" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.users.id
  http_method   = "OPTIONS"
  authorization = "NONE" # OPTIONS não precisa de auth para CORS
}

# Integration GET /users
resource "aws_api_gateway_integration" "get_users_integration" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.users.id
  http_method = aws_api_gateway_method.get_users.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.backend.invoke_arn

  # Timeout configuration
  timeout_milliseconds = 10000 # 10 seconds max
}

# Integration POST /users
resource "aws_api_gateway_integration" "post_users_integration" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.users.id
  http_method = aws_api_gateway_method.post_users.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.backend.invoke_arn
  timeout_milliseconds    = 10000
}

# Integration GET /users/{id}
resource "aws_api_gateway_integration" "get_user_by_id_integration" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.user_by_id.id
  http_method = aws_api_gateway_method.get_user_by_id.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.backend.invoke_arn
  timeout_milliseconds    = 10000
}

# Integration OPTIONS para CORS
resource "aws_api_gateway_integration" "options_users_integration" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.users.id
  http_method = aws_api_gateway_method.options_users.http_method

  type = "MOCK"

  request_templates = {
    "application/json" = jsonencode({
      statusCode = 200
    })
  }
}

# Method Response para OPTIONS (CORS)
resource "aws_api_gateway_method_response" "options_200" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.users.id
  http_method = aws_api_gateway_method.options_users.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

# Integration Response para OPTIONS (CORS)
resource "aws_api_gateway_integration_response" "options_200" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.users.id
  http_method = aws_api_gateway_method.options_users.http_method
  status_code = aws_api_gateway_method_response.options_200.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'GET,POST,OPTIONS'"
    "method.response.header.Access-Control-Allow-Origin"  = "'https://d3hg8r3vfucvhl.cloudfront.net,http://localhost:3000,http://127.0.0.1:5500'" # Domínios específicos
  }
}

# Stage de produção otimizado para FREE TIER
resource "aws_api_gateway_stage" "api_prod" {
  depends_on = [aws_api_gateway_account.api_account]  # Garante que account settings estejam configurados
  
  deployment_id = aws_api_gateway_deployment.api.id
  rest_api_id   = aws_api_gateway_rest_api.api.id
  stage_name    = "prod"

  # REMOVIDO: Cache (pode gerar custos extras)
  # cache_cluster_enabled = false  # FREE TIER: sem cache

  # Logs básicos (FREE TIER - 5GB gratuitos CloudWatch)
  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gateway_logs.arn
    format = jsonencode({
      requestId    = "$context.requestId"
      ip           = "$context.identity.sourceIp"
      requestTime  = "$context.requestTime"
      httpMethod   = "$context.httpMethod"
      resourcePath = "$context.resourcePath"
      status       = "$context.status"
      # Removidos campos extras para economizar espaço de log
    })
  }

  # X-Ray tracing DESABILITADO (pode gerar custos)
  # xray_tracing_enabled = false

  tags = {
    Name        = "${var.project_name}-api-prod"
    Environment = "free-tier"
    Tier        = "free"
  }
}

# CloudWatch Log Group para logs do API Gateway (FREE TIER)
resource "aws_cloudwatch_log_group" "api_gateway_logs" {
  name              = "/aws/apigateway/${var.project_name}"
  retention_in_days = 7 # FREE TIER: 7 dias para economizar espaço (5GB grátis)

  tags = {
    Name = "${var.project_name}-api-logs"
    Tier = "free"
  }
}

# Deployment atualizado
resource "aws_api_gateway_deployment" "api" {
  rest_api_id = aws_api_gateway_rest_api.api.id

  depends_on = [
    aws_api_gateway_integration.get_users_integration,
    aws_api_gateway_integration.post_users_integration,
    aws_api_gateway_integration.get_user_by_id_integration,
    aws_api_gateway_integration.options_users_integration,
    aws_api_gateway_integration_response.options_200
  ]

  lifecycle {
    create_before_destroy = true
  }

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.users.id,
      aws_api_gateway_resource.user_by_id.id,
      aws_api_gateway_method.get_users.id,
      aws_api_gateway_method.post_users.id,
      aws_api_gateway_method.get_user_by_id.id,
      aws_api_gateway_integration.get_users_integration.id,
      aws_api_gateway_integration.post_users_integration.id,
      aws_api_gateway_integration.get_user_by_id_integration.id,
    ]))
  }
}
