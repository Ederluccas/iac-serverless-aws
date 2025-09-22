# 🚀 Configure API Gateway URL from Terraform Output (PowerShell)
# This script automatically configures your frontend to use your Terraform infrastructure

param(
    [switch]$WhatIf,
    [switch]$Force
)

Write-Host "🔧 Configuring serverless app with Terraform outputs..." -ForegroundColor Cyan

# Check if Terraform state exists
if (-not (Test-Path "terraform.tfstate")) {
    Write-Host "❌ Error: terraform.tfstate not found" -ForegroundColor Red
    Write-Host "   Run 'terraform apply' first to create infrastructure" -ForegroundColor Yellow
    exit 1
}

# Get Terraform outputs
Write-Host "📋 Getting Terraform outputs..." -ForegroundColor Blue

try {
    $API_URL = terraform output -raw api_gateway_url
    $API_KEY = terraform output -raw api_key
    $BUCKET = terraform output -raw s3_bucket_name
    $CLOUDFRONT_DOMAIN = terraform output -raw cloudfront_domain
} catch {
    Write-Host "❌ Error getting Terraform outputs: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# Validate outputs
if ([string]::IsNullOrWhiteSpace($API_URL) -or [string]::IsNullOrWhiteSpace($API_KEY) -or [string]::IsNullOrWhiteSpace($BUCKET)) {
    Write-Host "❌ Error: Missing required Terraform outputs" -ForegroundColor Red
    Write-Host "   Expected outputs: api_gateway_url, api_key, s3_bucket_name" -ForegroundColor Yellow
    Write-Host "   Run 'terraform apply' to create missing resources" -ForegroundColor Yellow
    exit 1
}

Write-Host "✅ Found Terraform outputs:" -ForegroundColor Green
Write-Host "   API URL: $API_URL" -ForegroundColor White
Write-Host "   API Key: $($API_KEY.Substring(0, [Math]::Min(8, $API_KEY.Length)))..." -ForegroundColor White
Write-Host "   S3 Bucket: $BUCKET" -ForegroundColor White
Write-Host "   CloudFront: $CLOUDFRONT_DOMAIN" -ForegroundColor White

if ($WhatIf) {
    Write-Host "🔍 WhatIf mode - showing what would be changed:" -ForegroundColor Magenta
    Write-Host "   - frontend/script.js would be updated with new API URL and Key" -ForegroundColor White
    Write-Host "   - Updated file would be uploaded to S3: $BUCKET" -ForegroundColor White
    Write-Host "   - CloudFront cache would be invalidated for script.js" -ForegroundColor White
    exit 0
}

# Backup original script.js
if (-not (Test-Path "frontend/script.js.backup") -or $Force) {
    Write-Host "💾 Creating backup of original script.js..." -ForegroundColor Blue
    Copy-Item "frontend/script.js" "frontend/script.js.backup" -Force
}

# Update script.js with actual values
Write-Host "📝 Updating frontend configuration..." -ForegroundColor Blue

try {
    $scriptContent = Get-Content "frontend/script.js" -Raw -Encoding UTF8
    
    # Replace the hardcoded values using regex
    $scriptContent = $scriptContent -replace "this\.apiUrl = '[^']*';", "this.apiUrl = '$API_URL';"
    $scriptContent = $scriptContent -replace "this\.apiKey = '[^']*';", "this.apiKey = '$API_KEY';"
    
    # Save updated file
    $scriptContent | Out-File "frontend/script.js" -Encoding UTF8 -NoNewline
    
    Write-Host "   ✅ script.js updated successfully" -ForegroundColor Green
} catch {
    Write-Host "❌ Error updating script.js: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# Upload to S3
Write-Host "☁️  Uploading updated frontend to S3..." -ForegroundColor Blue

try {
    aws s3 cp frontend/script.js s3://$BUCKET/script.js
    Write-Host "   ✅ File uploaded to S3 successfully" -ForegroundColor Green
} catch {
    Write-Host "❌ Error uploading to S3: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "   Make sure AWS CLI is configured and you have S3 permissions" -ForegroundColor Yellow
    exit 1
}

# Invalidate CloudFront cache if distribution exists
if (-not [string]::IsNullOrWhiteSpace($CLOUDFRONT_DOMAIN)) {
    Write-Host "🔄 Invalidating CloudFront cache..." -ForegroundColor Blue
    
    try {
        $DISTRIBUTION_ID = terraform output -raw cloudfront_distribution_id
        if (-not [string]::IsNullOrWhiteSpace($DISTRIBUTION_ID)) {
            aws cloudfront create-invalidation --distribution-id $DISTRIBUTION_ID --paths "/script.js" | Out-Null
            Write-Host "   ✅ Cache invalidation created for script.js" -ForegroundColor Green
        }
    } catch {
        Write-Host "   ⚠️  Warning: Could not invalidate CloudFront cache" -ForegroundColor Yellow
        Write-Host "   Changes may take 5-15 minutes to appear due to caching" -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "🎉 Configuration complete!" -ForegroundColor Green -BackgroundColor Black
Write-Host ""
Write-Host "📱 Your serverless app is now configured with your infrastructure:" -ForegroundColor Cyan
Write-Host "   Frontend URL: https://$CLOUDFRONT_DOMAIN" -ForegroundColor White
Write-Host "   API URL: $API_URL" -ForegroundColor White
Write-Host ""
Write-Host "🧪 Next steps:" -ForegroundColor Yellow
Write-Host "   1. Open your app: https://$CLOUDFRONT_DOMAIN" -ForegroundColor White
Write-Host "   2. The API should now be pre-configured" -ForegroundColor White
Write-Host "   3. Click 'Testar Conexão' to verify everything works" -ForegroundColor White
Write-Host ""
Write-Host "💡 Tip: If you see old configuration, wait 2-3 minutes for CloudFront cache to update" -ForegroundColor Gray