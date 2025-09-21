# Random string para nome único do bucket
resource "random_string" "bucket_suffix" {
  length  = 8
  lower   = true
  upper   = false
  numeric = true
  special = false
}

resource "aws_s3_bucket" "frontend_bucket" {
  bucket = "${var.project_name}-frontend-${random_string.bucket_suffix.result}"

  tags = {
    Name = "${var.project_name}-frontend"
  }
}

# Configuração de website separada (nova versão do provider AWS)
resource "aws_s3_bucket_website_configuration" "frontend_website" {
  bucket = aws_s3_bucket.frontend_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

# Bloqueio de acesso público
resource "aws_s3_bucket_public_access_block" "frontend_bucket_pab" {
  bucket = aws_s3_bucket.frontend_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# ACL configurada separadamente
resource "aws_s3_bucket_acl" "frontend_bucket_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.frontend_bucket_ownership]
  bucket     = aws_s3_bucket.frontend_bucket.id
  acl        = "private"
}

# Controle de propriedade dos objetos
resource "aws_s3_bucket_ownership_controls" "frontend_bucket_ownership" {
  bucket = aws_s3_bucket.frontend_bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# FREE TIER: Lifecycle policy para otimizar custos
resource "aws_s3_bucket_lifecycle_configuration" "frontend_lifecycle" {
  bucket = aws_s3_bucket.frontend_bucket.id

  rule {
    id     = "free_tier_optimization"
    status = "Enabled"

    # Filter aplicado a todos os objetos
    filter {}

    # FREE TIER: Transição para IA após 30 dias (se necessário)
    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    # FREE TIER: Cleanup de uploads incompletos
    abort_incomplete_multipart_upload {
      days_after_initiation = 1
    }

    # FREE TIER: Remove versões antigas (se versionamento habilitado)
    noncurrent_version_expiration {
      noncurrent_days = 30
    }
  }
}

# Política restrita para CloudFront Origin Access Control (OAC)
resource "aws_s3_bucket_policy" "frontend_bucket_policy" {
  depends_on = [aws_s3_bucket_public_access_block.frontend_bucket_pab]
  bucket     = aws_s3_bucket.frontend_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowCloudFrontServicePrincipal"
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = "${aws_s3_bucket.frontend_bucket.arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.cdn.arn
          }
        }
      }
    ]
  })
}

# Data source para obter informações da conta AWS
data "aws_caller_identity" "current" {}