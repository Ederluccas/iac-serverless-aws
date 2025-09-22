#!/bin/bash

# 🚀 Configure API Gateway URL from Terraform Output
# This script automatically configures your frontend to use your Terraform infrastructure

set -e

echo "🔧 Configuring serverless app with Terraform outputs..."

# Check if Terraform state exists
if [ ! -f "terraform.tfstate" ]; then
    echo "❌ Error: terraform.tfstate not found"
    echo "   Run 'terraform apply' first to create infrastructure"
    exit 1
fi

# Get Terraform outputs
echo "📋 Getting Terraform outputs..."

API_URL=$(terraform output -raw api_gateway_url 2>/dev/null || echo "")
API_KEY=$(terraform output -raw api_key 2>/dev/null || echo "")
BUCKET=$(terraform output -raw s3_bucket_name 2>/dev/null || echo "")
CLOUDFRONT_DOMAIN=$(terraform output -raw cloudfront_domain 2>/dev/null || echo "")

# Validate outputs
if [ -z "$API_URL" ] || [ -z "$API_KEY" ] || [ -z "$BUCKET" ]; then
    echo "❌ Error: Missing required Terraform outputs"
    echo "   Expected outputs: api_gateway_url, api_key, s3_bucket_name"
    echo "   Run 'terraform apply' to create missing resources"
    exit 1
fi

echo "✅ Found Terraform outputs:"
echo "   API URL: $API_URL"
echo "   API Key: ${API_KEY:0:8}..."
echo "   S3 Bucket: $BUCKET"
echo "   CloudFront: $CLOUDFRONT_DOMAIN"

# Backup original script.js
if [ ! -f "frontend/script.js.backup" ]; then
    echo "💾 Creating backup of original script.js..."
    cp frontend/script.js frontend/script.js.backup
fi

# Update script.js with actual values
echo "📝 Updating frontend configuration..."

# Use sed to replace the hardcoded values
sed -i.tmp "s|this\.apiUrl = '[^']*';|this.apiUrl = '$API_URL';|g" frontend/script.js
sed -i.tmp "s|this\.apiKey = '[^']*';|this.apiKey = '$API_KEY';|g" frontend/script.js

# Remove temporary file
rm -f frontend/script.js.tmp

# Upload to S3
echo "☁️  Uploading updated frontend to S3..."
aws s3 cp frontend/script.js s3://$BUCKET/script.js

# Invalidate CloudFront cache if distribution exists
if [ ! -z "$CLOUDFRONT_DOMAIN" ]; then
    echo "🔄 Invalidating CloudFront cache..."
    DISTRIBUTION_ID=$(terraform output -raw cloudfront_distribution_id 2>/dev/null || echo "")
    if [ ! -z "$DISTRIBUTION_ID" ]; then
        aws cloudfront create-invalidation --distribution-id $DISTRIBUTION_ID --paths "/script.js" > /dev/null
        echo "   Cache invalidation created for script.js"
    fi
fi

echo ""
echo "🎉 Configuration complete!"
echo ""
echo "📱 Your serverless app is now configured with your infrastructure:"
echo "   Frontend URL: https://$CLOUDFRONT_DOMAIN"
echo "   API URL: $API_URL"
echo ""
echo "🧪 Next steps:"
echo "   1. Open your app: https://$CLOUDFRONT_DOMAIN"
echo "   2. The API should now be pre-configured"
echo "   3. Click 'Testar Conexão' to verify everything works"
echo ""
echo "💡 Tip: If you see old configuration, wait 2-3 minutes for CloudFront cache to update"