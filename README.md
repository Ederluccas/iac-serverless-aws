# 🚀 IaC Serverless AWS - FREE TIER

![AWS](https://img.shields.io/badge/AWS-%23FF9900.svg?style=for-the-badge&logo=amazon-aws&logoColor=white)
![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)
![JavaScript](https://img.shields.io/badge/javascript-%23323330.svg?style=for-the-badge&logo=javascript&logoColor=%23F7DF1E)
![HTML5](https://img.shields.io/badge/html5-%23E34F26.svg?style=for-the-badge&logo=html5&logoColor=white)
![CSS3](https://img.shields.io/badge/css3-%231572B6.svg?style=for-the-badge&logo=css3&logoColor=white)

Uma aplicação **serverless completa** na AWS usando **Infrastructure as Code (Terraform)** otimizada para o **FREE TIER**.

## 📋 Visão Geral

Este projeto implementa uma aplicação web serverless moderna com:

- **🔒 Segurança**: Menor privilégio aplicado em todos os recursos
- **💰 FREE TIER**: Otimizada para custos zero
- **🌙 Modo Escuro**: Interface moderna com toggle de temas
- **📱 Responsiva**: PWA com service worker
- **⚡ Performance**: CDN global com CloudFront
- **🔄 CRUD**: Operações completas de usuários

## 🏗️ Arquitetura

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   CloudFront    │    │   API Gateway   │    │     Lambda      │
│      (CDN)      │◄──►│    (REST API)   │◄──►│   (Backend)     │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         ▲                       ▲                       ▲
         │                       │                       │
         ▼                       ▼                       ▼
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│       S3        │    │   CloudWatch    │    │   DynamoDB      │
│  (Frontend)     │    │    (Logs)       │    │   (Database)    │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

## 🛠️ Serviços AWS

| Serviço | Propósito | FREE TIER |
|---------|-----------|-----------|
| **S3** | Hospedagem frontend | 5GB storage, 20K GETs |
| **CloudFront** | CDN global | 1TB transfer, 10M requests |
| **API Gateway** | REST API | 1M requests/mês |
| **Lambda** | Backend serverless | 1M requests, 400K GB-s |
| **DynamoDB** | Banco NoSQL | 25GB storage |
| **CloudWatch** | Monitoramento | 5GB logs |
| **IAM** | Autenticação | Ilimitado |

## 🚦 Pré-requisitos

- **AWS CLI** configurada
- **Terraform** >= 1.6.0
- **Node.js** (para desenvolvimento)
- Conta AWS com **FREE TIER** ativo

## 🚀 Deploy Rápido

### 1. Clone o repositório
```bash
git clone <repository-url>
cd iac-serverless-aws
```

### 2. Configure suas credenciais AWS
```bash
aws configure
```

### 3. Deploy da infraestrutura
```bash
terraform init
terraform plan
terraform apply -auto-approve
```

### 4. Upload do frontend
```bash
# O nome do bucket será exibido no output do Terraform
aws s3 cp frontend/ s3://<bucket-name>/ --recursive
```

### 5. Acesse sua aplicação
```
CloudFront URL será exibida no output do Terraform
```

## 📁 Estrutura do Projeto

```
iac-serverless-aws/
├── 📄 main.tf                 # Configuração principal do Terraform
├── 📄 variables.tf            # Variáveis do projeto
├── 📄 outputs.tf              # Outputs importantes
├── 📄 iam.tf                  # Roles e políticas IAM
├── 📄 s3.tf                   # Bucket S3 para frontend
├── 📄 cloudfront.tf           # CDN CloudFront
├── 📄 api_gateway.tf          # API Gateway REST
├── 📄 lambda.tf               # Função Lambda
├── 📄 dynamodb.tf             # Tabela DynamoDB
├── 📁 frontend/               # Código do frontend
│   ├── 📄 index.html          # Interface principal
│   ├── 📄 styles.css          # Estilos com modo escuro
│   ├── 📄 script.js           # Lógica JavaScript
│   ├── 📄 sw.js               # Service Worker PWA
│   └── 📄 error.html          # Página de erro
├── 📁 lambda/                 # Código do backend
│   └── 📄 index.js            # Handler da função Lambda
├── 📄 deploy-frontend.ps1     # Script de deploy do frontend
├── 📄 FREE_TIER_MONITORING.md # Guia de monitoramento
└── 📄 README.md               # Esta documentação
```

## 🔐 Segurança Implementada

### ✅ Menor Privilégio (Least Privilege)

- **S3**: Bucket privado com Origin Access Control (OAC)
- **CloudFront**: Acesso exclusivo via OAC, sem acesso direto ao S3
- **API Gateway**: Autenticação IAM + API Key obrigatória
- **Lambda**: Permissões específicas apenas para DynamoDB necessário
- **IAM**: Roles com políticas mínimas requeridas

### 🛡️ Headers de Segurança

```javascript
// Aplicados via CloudFront
'Strict-Transport-Security': 'max-age=63072000'
'X-Content-Type-Options': 'nosniff'
'X-Frame-Options': 'DENY'
'X-XSS-Protection': '1; mode=block'
'Referrer-Policy': 'strict-origin-when-cross-origin'
```

## 🌙 Modo Escuro

### Recursos
- **Toggle Button** no header
- **Persistência** da preferência no localStorage
- **Transições suaves** entre temas
- **Cores otimizadas** para acessibilidade
- **Ícones dinâmicos** (🌙/☀️)

### CSS Variables
```css
:root {
    --bg-primary: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    --text-primary: #333;
    /* ... mais variáveis */
}

[data-theme="dark"] {
    --bg-primary: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%);
    --text-primary: #e0e0e0;
    /* ... tema escuro */
}
```

## 💰 Monitoramento FREE TIER

### Limites Importantes
```javascript
// Configurações otimizadas
API Gateway: 10 req/seg, 1M/mês
Lambda: 128MB RAM, 30seg timeout
DynamoDB: Pay-per-request
S3: Lifecycle rules ativas
CloudFront: PriceClass_100
```

### Alertas Implementados
- Limite de requisições da API (80% = 26.666/dia)
- Monitoramento de uso no localStorage
- Logs com retenção de 7 dias

## 🔧 Customização

### Variáveis Terraform
```hcl
# variables.tf
variable "project_name" {
    default = "iac-serverless"
}

variable "region" {
    default = "ap-southeast-2"
}

variable "environment" {
    default = "free-tier"
}
```

### Configuração da API
```javascript
// frontend/script.js
constructor() {
    this.apiUrl = 'https://your-api-id.execute-api.region.amazonaws.com/prod';
    this.apiKey = 'your-api-key';
}
```

## 🧪 Testando a Aplicação

### 1. Teste de Conectividade
- Clique em "Testar Conexão" na interface
- Deve retornar status 200 com mensagem de sucesso

### 2. Operações CRUD
```javascript
// Criar usuário
POST /users { "name": "João", "email": "joao@email.com" }

// Listar usuários
GET /users

// Buscar por ID
GET /users/{id}
```

### 3. Modo Escuro
- Clique no ícone da lua (🌙) no header
- Interface deve alternar para tema escuro
- Recarregue a página - preferência deve persistir

## 📊 Outputs Importantes

Após o `terraform apply`, você receberá:

```
api_gateway_url = "https://abc123.execute-api.region.amazonaws.com/prod"
api_key = <sensitive>
cloudfront_domain = "d1234567890.cloudfront.net"
s3_bucket_name = "iac-serverless-frontend-abc123"
```

## 🚨 Troubleshooting

### Problemas Comuns

**1. Erro de Bucket Existente**
```bash
# Solução: Nome será gerado automaticamente com sufixo aleatório
terraform apply
```

**2. API Gateway 403**
```bash
# Verificar se API Key está configurada
aws apigateway get-api-key --api-key YOUR_KEY_ID --include-value
```

**3. CloudFront não atualiza**
```bash
# Invalidar cache manualmente
aws cloudfront create-invalidation --distribution-id DIST_ID --paths "/*"
```

## 🤝 Contribuindo

1. Fork o projeto
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

## 📝 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para detalhes.

## 🎯 Roadmap

- [ ] Autenticação com Cognito
- [ ] Pipeline CI/CD com GitHub Actions
- [ ] Testes automatizados
- [ ] Monitoring com X-Ray
- [ ] Multi-região deployment
- [ ] Custom domain com Route53

## 📞 Suporte

- 🐛 **Issues**: Reporte bugs via GitHub Issues
- 💬 **Discussões**: Use GitHub Discussions
- 📧 **Email**: Para questões privadas

---

⭐ **Se este projeto foi útil, deixe uma estrela no GitHub!**

🚀 **Deploy em minutos, escale para milhões!**