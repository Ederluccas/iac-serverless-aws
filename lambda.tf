resource "aws_lambda_function" "backend" {
  function_name = "${var.project_name}-lambda"
  handler       = "index.handler"
  runtime       = "nodejs18.x" # FREE TIER compatível
  role          = aws_iam_role.lambda_role.arn

  filename         = "lambda.zip"
  source_code_hash = filebase64sha256("lambda.zip")

  # FREE TIER: 128MB é suficiente e gratuito
  memory_size = 128 # FREE TIER: 128MB (mínimo e mais barato)
  timeout     = 30  # FREE TIER: 30 segundos (máximo gratuito para baixo uso)

  # FREE TIER: Configurações de ambiente otimizadas
  environment {
    variables = {
      DYNAMO_TABLE = aws_dynamodb_table.users.name
      NODE_ENV     = "production"
      # Removidas variáveis extras para economizar
    }
  }

  # FREE TIER: Sem dead letter queue (pode gerar custos SQS)
  # dead_letter_config não configurado

  # FREE TIER: Sem VPC (pode gerar custos NAT Gateway)
  # vpc_config não configurado

  tags = {
    Name = "${var.project_name}-lambda"
    Tier = "free"
  }
}

# Permissão para API Gateway invocar Lambda (menor privilégio)
resource "aws_lambda_permission" "api_gateway_invoke" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.backend.function_name
  principal     = "apigateway.amazonaws.com"

  # Restringe à API específica e stage específico
  source_arn = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
}

# CloudWatch Log Group para Lambda (FREE TIER)
resource "aws_cloudwatch_log_group" "lambda_logs" {
  name              = "/aws/lambda/${aws_lambda_function.backend.function_name}"
  retention_in_days = 7 # FREE TIER: 7 dias para economizar espaço (5GB grátis)

  tags = {
    Name = "${var.project_name}-lambda-logs"
    Tier = "free"
  }
}
