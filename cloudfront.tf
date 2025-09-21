# Origin Access Control (OAC) - Abordagem mais segura que OAI
resource "aws_cloudfront_origin_access_control" "s3_oac" {
  name                              = "${var.project_name}-s3-oac"
  description                       = "Origin Access Control for S3 bucket"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# CloudFront Distribution com menor privilégio
resource "aws_cloudfront_distribution" "cdn" {
  origin {
    domain_name              = aws_s3_bucket.frontend_bucket.bucket_regional_domain_name
    origin_id                = "s3-${var.project_name}-origin"
    origin_access_control_id = aws_cloudfront_origin_access_control.s3_oac.id

    # Removido s3_origin_config para usar OAC em vez de OAI
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"
  comment             = "CloudFront distribution for ${var.project_name} frontend"

  # Configuração de cache com menor privilégio
  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "s3-${var.project_name}-origin"
    compress               = true
    viewer_protocol_policy = "redirect-to-https"

    # Configuração moderna de cache (substitui forwarded_values depreciado)
    cache_policy_id          = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad" # Managed-CachingDisabled
    origin_request_policy_id = "88a5eaf4-2fd4-4709-b370-b4c650ea3fcf" # Managed-CORS-S3Origin

    # Headers de segurança
    response_headers_policy_id = "67f7725c-6f97-4210-82d7-5512b31e9d03" # Managed-SecurityHeadersPolicy
  }

  # Configuração de preços (FREE TIER - apenas locações principais)
  price_class = "PriceClass_100" # FREE TIER: América do Norte, Europa (mais locais = mais caro)

  # Restrições geográficas (FREE TIER otimizado)
  restrictions {
    geo_restriction {
      restriction_type = "none"
      # Para economizar mais, pode restringir a regiões específicas:
      # restriction_type = "whitelist"
      # locations = ["US", "CA", "GB", "DE", "FR", "BR"]
    }
  }

  # Certificado SSL (FREE TIER)
  viewer_certificate {
    cloudfront_default_certificate = true
    minimum_protocol_version       = "TLSv1.2_2021"
  }

  # REMOVIDO: logging_config (pode gerar custos no S3)
  # Comentado para FREE TIER - use CloudWatch se necessário

  # Páginas de erro customizadas (FREE TIER compatível)
  custom_error_response {
    error_code         = 404
    response_code      = 200
    response_page_path = "/index.html"
  }

  custom_error_response {
    error_code         = 403
    response_code      = 200
    response_page_path = "/index.html"
  }

  tags = {
    Name        = "${var.project_name}-cdn"
    Environment = "free-tier"
    ManagedBy   = "Terraform"
  }
}

# REMOVIDO: Bucket de logs (economiza custos S3)
# REMOVIDO: Lifecycle policies (não necessário para FREE TIER)