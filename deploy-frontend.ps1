# 🚀 Script de Deploy do Frontend para S3

param(
    [string]$BucketName,
    [string]$Region = "ap-southeast-2",  # Sydney - conforme sua conta AWS
    [switch]$DryRun
)

Write-Host "🆓 FREE TIER - Deploy Frontend para S3" -ForegroundColor Cyan

# Verificar se o bucket foi fornecido
if (-not $BucketName) {
    Write-Host "❌ Erro: Nome do bucket é obrigatório" -ForegroundColor Red
    Write-Host "Uso: .\deploy-frontend.ps1 -BucketName 'seu-bucket-frontend'" -ForegroundColor Yellow
    exit 1
}

# Verificar se AWS CLI está instalado
try {
    $null = aws --version
} catch {
    Write-Host "❌ AWS CLI não encontrado. Instale o AWS CLI primeiro." -ForegroundColor Red
    exit 1
}

# Verificar credenciais AWS
try {
    $identity = aws sts get-caller-identity 2>$null
    if (-not $identity) {
        throw "No identity"
    }
    Write-Host "✅ Credenciais AWS válidas" -ForegroundColor Green
} catch {
    Write-Host "❌ Credenciais AWS não configuradas. Execute 'aws configure'" -ForegroundColor Red
    exit 1
}

# Verificar se os arquivos existem
$frontendPath = ".\frontend"
$requiredFiles = @("index.html", "styles.css", "script.js", "error.html", "sw.js")

foreach ($file in $requiredFiles) {
    if (-not (Test-Path "$frontendPath\$file")) {
        Write-Host "❌ Arquivo não encontrado: $frontendPath\$file" -ForegroundColor Red
        exit 1
    }
}

Write-Host "✅ Todos os arquivos frontend encontrados" -ForegroundColor Green

# Dry run
if ($DryRun) {
    Write-Host "🔍 DRY RUN - Arquivos que seriam enviados:" -ForegroundColor Yellow
    Get-ChildItem $frontendPath | ForEach-Object {
        Write-Host "  - $($_.Name)" -ForegroundColor Yellow
    }
    exit 0
}

# Fazer upload dos arquivos
Write-Host "📤 Enviando arquivos para s3://$BucketName..." -ForegroundColor Blue

try {
    # Upload HTML files
    aws s3 cp "$frontendPath\index.html" "s3://$BucketName/index.html" --content-type "text/html" --region $Region
    aws s3 cp "$frontendPath\error.html" "s3://$BucketName/error.html" --content-type "text/html" --region $Region
    
    # Upload CSS
    aws s3 cp "$frontendPath\styles.css" "s3://$BucketName/styles.css" --content-type "text/css" --region $Region
    
    # Upload JS
    aws s3 cp "$frontendPath\script.js" "s3://$BucketName/script.js" --content-type "application/javascript" --region $Region
    aws s3 cp "$frontendPath\sw.js" "s3://$BucketName/sw.js" --content-type "application/javascript" --region $Region
    
    Write-Host "✅ Upload concluído com sucesso!" -ForegroundColor Green
    
    # Invalidar cache do CloudFront (se configurado)
    Write-Host "🔄 Para invalidar cache do CloudFront (se necessário):" -ForegroundColor Yellow
    Write-Host "aws cloudfront create-invalidation --distribution-id SEU-DISTRIBUTION-ID --paths '/*'" -ForegroundColor Gray
    
    # Mostrar informações úteis
    Write-Host "" 
    Write-Host "📋 Informações do Deploy:" -ForegroundColor Cyan
    Write-Host "  Bucket: $BucketName" -ForegroundColor White
    Write-Host "  Região: $Region" -ForegroundColor White
    Write-Host "  Arquivos: $($requiredFiles.Count)" -ForegroundColor White
    Write-Host ""
    Write-Host "🌐 URLs de acesso:" -ForegroundColor Cyan
    Write-Host "  S3 Website: http://$BucketName.s3-website-$Region.amazonaws.com" -ForegroundColor White
    Write-Host "  CloudFront: https://[SEU-CLOUDFRONT-DOMAIN]" -ForegroundColor White
    
} catch {
    Write-Host "❌ Erro no upload: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "🎉 Deploy do frontend concluído!" -ForegroundColor Green
Write-Host "Configure a URL da API e API Key na interface para começar a usar." -ForegroundColor Yellow