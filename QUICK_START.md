# 🚀 Quick Start: Configure API Gateway URL

## TL;DR - Fastest Way to Configure

```bash
# 1. Deploy infrastructure
terraform apply -auto-approve

# 2. Auto-configure frontend (choose one)
./configure-api.sh        # Linux/Mac
.\configure-api.ps1       # Windows

# 3. Open your app
terraform output cloudfront_domain
```

## Manual Configuration (Web Interface)

1. **Get your values**:
   ```bash
   terraform output api_gateway_url
   terraform output -raw api_key
   ```

2. **Open your app**: Use CloudFront URL from `terraform output`

3. **Configure in browser**: Paste values in "Configuração da API" section

4. **Test**: Click "Testar Conexão" button

## Troubleshooting

| Problem | Solution |
|---------|----------|
| 403 Error | Check API Key is correct: `terraform output -raw api_key` |
| Network Error | Verify URL format includes `/prod`: `https://api-id.execute-api.region.amazonaws.com/prod` |
| No API Key | Use `-raw` flag: `terraform output -raw api_key` |
| Cache Issues | Wait 2-3 minutes for CloudFront cache to update |

## Scripts Options

```bash
# Bash script (Linux/Mac)
./configure-api.sh

# PowerShell with preview
.\configure-api.ps1 -WhatIf

# PowerShell force update
.\configure-api.ps1 -Force
```

**💡 The scripts automatically:**
- Get Terraform outputs
- Update frontend code
- Upload to S3
- Invalidate CloudFront cache

---
*For detailed instructions, see [IMPLEMENTATION_GUIDE.md](IMPLEMENTATION_GUIDE.md)*