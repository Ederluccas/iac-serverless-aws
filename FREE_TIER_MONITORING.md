# 🆓 AWS Free Tier Monitoring Guide

## Limites Configurados

### 📊 **API Gateway**
- **Monthly Requests**: 1,000,000 (FREE TIER limit)
- **Rate Limiting**: 10 requests/second
- **Burst Capacity**: 20 requests/second
- **Monitoring**: CloudWatch logs com retenção de 7 dias

### ⚡ **Lambda**
- **Memory**: 128 MB (mínimo, mais econômico)
- **Timeout**: 30 segundos
- **Monthly Requests**: 1,000,000 (FREE TIER limit)
- **Compute Time**: 400,000 GB-segundos/mês
- **Runtime**: Node.js 18.x

### 💾 **DynamoDB**
- **Storage**: 25 GB gratuitos
- **Billing Mode**: PAY_PER_REQUEST (on-demand)
- **Backup**: Desabilitado (economiza custos)
- **Encryption**: Server-side habilitada (gratuita)

### 🪣 **S3**
- **Storage**: 5 GB gratuitos
- **GET Requests**: 20,000/mês
- **PUT Requests**: 2,000/mês
- **Lifecycle**: Transição para IA após 30 dias
- **Multipart**: Cleanup após 1 dia

### 🌐 **CloudFront**
- **Data Transfer**: 1 TB gratuito/mês
- **Requests**: 10,000,000 gratuitas/mês
- **Price Class**: 100 (América do Norte, Europa)
- **Cache**: Desabilitado (evita custos extras)
- **Logs**: Desabilitados (evita custos S3)

### 📈 **CloudWatch**
- **Log Storage**: 5 GB gratuitos
- **Retention**: 7 dias (economiza espaço)
- **Metrics**: Básicas incluídas
- **Alarms**: 10 gratuitos

## 🚨 Monitoramento Recomendado

### Billing Alerts
```bash
# Configure billing alerts no console AWS
# Threshold sugerido: $1.00 USD
```

### CloudWatch Dashboards Gratuitos
- Monitore métricas básicas de cada serviço
- 3 dashboards gratuitos incluídos

### Cost Explorer
- Monitore custos diariamente
- Configure alertas para $0.50 e $1.00

## ⚠️ Cuidados para Evitar Custos

### ❌ **Evitar**
- Cache do API Gateway (cobra extra)
- X-Ray tracing (cobra por trace)
- Logs do CloudFront (cobra espaço S3)
- VPC configurations (pode gerar custos NAT)
- Reserved Capacity no DynamoDB
- Versioning excessivo no S3

### ✅ **Manter**
- Rate limiting configurado
- Log retention baixa (7 dias)
- Memory Lambda mínima (128MB)
- DynamoDB on-demand
- Lifecycle policies S3
- Monitoring básico

## 📱 Comandos de Monitoramento

### Verificar Custos Atuais
```bash
# Via AWS CLI (configure suas credenciais)
aws ce get-cost-and-usage \
  --time-period Start=2025-09-01,End=2025-09-21 \
  --granularity DAILY \
  --metrics BlendedCost
```

### Verificar Usage API Gateway
```bash
# Métricas do API Gateway
aws logs describe-log-groups \
  --log-group-name-prefix "/aws/apigateway"
```

### Verificar Usage Lambda
```bash
# Invocações Lambda
aws lambda get-function \
  --function-name iac-serverless-lambda
```

## 🎯 Otimizações Implementadas

1. **API Gateway**: Rate limiting rigoroso (10 req/s)
2. **Lambda**: 128MB RAM, 30s timeout
3. **DynamoDB**: On-demand billing
4. **S3**: Lifecycle rules ativas
5. **CloudFront**: Price class otimizada
6. **Logs**: Retenção mínima (7 dias)
7. **Monitoring**: Apenas essencial

## 📞 Suporte Free Tier

- **AWS Support**: Basic (gratuito)
- **Documentation**: Completa e gratuita
- **Forums**: Community support
- **Trusted Advisor**: Limitado no free tier

---

**⚡ Dica**: Configure billing alerts desde o primeiro dia para evitar surpresas!