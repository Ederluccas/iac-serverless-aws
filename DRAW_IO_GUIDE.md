# 🎨 Como Usar o Diagrama Draw.io para LinkedIn

## 📋 **Passo a Passo**

### **1. Abrir o Arquivo**
1. Acesse: [app.diagrams.net](https://app.diagrams.net)
2. Clique em **"Open Existing Diagram"**
3. Selecione o arquivo: `arquitetura_linkedin.drawio`
4. Ou copie o código XML e cole em "Create New → Blank Diagram → Import XML"

### **2. Personalizar o Diagrama**

**🎯 Elementos Editáveis:**

- **Título:** Altere para nome do seu projeto
- **URLs:** Substitua pelos seus links do GitHub/GitLab
- **Cores:** Ajuste conforme paleta da empresa
- **Ícones:** Adicione emojis específicos do projeto

### **3. Exportar para LinkedIn**

**📱 Formato Otimizado:**
1. File → Export as → PNG
2. Configurações:
   - **Resolution:** 300 DPI
   - **Width:** 1200px (LinkedIn ideal)
   - **Background:** Transparent ❌ (manter branco)
   - **Border:** 10px

### **4. Variações por Tela**

#### **🖼️ Tela 1 - Arquitetura Completa**
- Mostrar diagrama completo
- Destacar fluxo principal com setas mais grossas
- Adicionar "NEW" badges nos recursos principais

#### **🖼️ Tela 2 - Foco no IaC**
- Destacar apenas Terraform + AWS resources
- Escurecer outros elementos
- Adicionar callout box com "Infrastructure as Code"

#### **🖼️ Tela 3 - Pipeline CI/CD**
- Destacar Developer → Git → Terraform
- Adicionar ícones de status (✅ success)
- Incluir timeline/steps

#### **🖼️ Tela 4 - AWS Console View**
- Destacar apenas recursos AWS (remover user/developer)
- Adicionar badges com "FREE TIER" 
- Mostrar métricas/números

#### **🖼️ Tela 5 - Result/Demo**
- Destacar User → Frontend flow
- Adicionar screenshot mockup da aplicação
- Incluir performance metrics

---

## 🎨 **Customizações Avançadas**

### **📊 Adicionar Métricas**

```xml
<!-- Adicionar caixa de métricas -->
<mxCell id="metrics" value="📊 Métricas:&#xa;• Load Time: <2s&#xa;• Uptime: 99.9%&#xa;• Cost: $5/mês&#xa;• Requests: 10k/dia" style="..."/>
```

### **🏷️ Badges e Labels**

```xml
<!-- Badge FREE TIER -->
<mxCell id="freetier" value="FREE TIER" style="rounded=1;fillColor=#22c55e;fontColor=white;fontSize=8;fontStyle=1;"/>
```

### **🎯 Call-to-Actions**

```xml
<!-- CTA Box -->
<mxCell id="cta" value="🔗 Ver Demo: https://seu-link.com&#xa;📚 GitHub: github.com/user/repo" style="..."/>
```

---

## 📸 **Screenshots Complementares**

### **Para Tela 2 - Código IaC:**
**Screenshot do VSCode mostrando:**
```hcl
# main.tf
resource "aws_lambda_function" "serverless_crud" {
  function_name = "serverless-crud-function"
  runtime      = "nodejs18.x"
  handler      = "index.handler"
  
  # Highlight this section
  memory_size = 128
  timeout     = 30
  
  # FREE TIER optimized
}

resource "aws_api_gateway_rest_api" "main" {
  name = "serverless-crud-api"
  # Highlight endpoint configuration
}
```

### **Para Tela 3 - Pipeline:**
**Screenshot GitHub Actions workflow:**
```yaml
name: Deploy Serverless App
on:
  push:
    branches: [main]
    
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v3
        
      - name: Terraform Plan
        run: terraform plan
        
      - name: Deploy to AWS  
        run: terraform apply -auto-approve
```

### **Para Tela 4 - Console AWS:**
**Screenshots necessários:**
- Lambda Functions list
- DynamoDB Tables
- API Gateway APIs
- CloudFront Distributions
- S3 Buckets

### **Para Tela 5 - Teste Funcional:**
**Postman/Insomnia request:**
```json
POST /dev/items
{
  "name": "Test Item",
  "description": "Demo via API"
}

Response: 201 Created
{
  "id": "abc123",
  "name": "Test Item",
  "description": "Demo via API",
  "timestamp": "2025-09-21T12:00:00Z"
}
```

---

## 🎯 **Templates de Imagem**

### **Layout Sugerido por Tela:**

**📐 Tela 1 (1200x630px):**
```
┌─────────────────────────────────────┐
│  🚀 ARQUITETURA SERVERLESS AWS      │
│                                     │
│  [    DIAGRAMA DRAW.IO AQUI    ]    │
│                                     │
│  💰 $0-20/mês | ⚡ <2s | 🔒 Secure  │
└─────────────────────────────────────┘
```

**📐 Tela 2 (1200x630px):**
```
┌─────────────────────────────────────┐
│  🏗️ INFRASTRUCTURE AS CODE          │
│                                     │
│  [  CÓDIGO TERRAFORM + DIAGRAMA ]   │
│                                     │
│  ✅ Versionado | ✅ Reproduzível    │
└─────────────────────────────────────┘
```

**📐 Tela 3 (1200x630px):**
```
┌─────────────────────────────────────┐
│  🔄 CI/CD PIPELINE                  │
│                                     │
│  [  GITHUB ACTIONS + WORKFLOW  ]    │
│                                     │
│  🚀 Deploy Automático em 10min      │
└─────────────────────────────────────┘
```

**📐 Tela 4 (1200x630px):**
```
┌─────────────────────────────────────┐
│  ☁️ AWS RESOURCES CREATED           │
│                                     │
│  [  CONSOLE AWS SPLIT SCREEN   ]    │
│                                     │
│  🎯 36 recursos | 💰 FREE TIER      │
└─────────────────────────────────────┘
```

**📐 Tela 5 (1200x630px):**
```
┌─────────────────────────────────────┐
│  ✅ APLICAÇÃO FUNCIONANDO           │
│                                     │
│  [  POSTMAN + FRONTEND DEMO    ]    │
│                                     │
│  🔗 Demo: https://seu-link.com      │
└─────────────────────────────────────┘
```

---

## 🔧 **Ferramentas Complementares**

### **Para Screenshots:**
- **Windows:** Snipping Tool ou Greenshot
- **Mac:** Cmd+Shift+4
- **Chrome:** DevTools Device Mode para mobile
- **Figma/Canva:** Para composições profissionais

### **Para Edição:**
- **Figma:** Templates LinkedIn 1200x630
- **Canva:** LinkedIn post templates
- **GIMP/Photoshop:** Edições avançadas
- **Remove.bg:** Remover backgrounds

### **Para Performance:**
- **TinyPNG:** Comprimir imagens
- **Squoosh:** Otimização avançada
- **Lighthouse:** Testar performance da app

---

## ✅ **Checklist Final**

**Antes de Publicar:**
- [ ] Diagrama exportado em 300 DPI
- [ ] Screenshots com interface limpa
- [ ] Texto legível em mobile
- [ ] Links testados e funcionando
- [ ] Cores consistentes entre imagens
- [ ] Call-to-action em cada imagem
- [ ] Watermark/logo se necessário
- [ ] Preview em diferentes dispositivos

**🎯 Resultado Esperado:**
Posts com alta qualidade visual que demonstram expertise técnica e geram engajamento profissional no LinkedIn!

---

## 🚀 **Próximos Passos**
1. Criar as 5 imagens usando este guia
2. Agendar posts durante a semana
3. Monitorar engajamento e ajustar
4. Reaproveitar conteúdo para outras redes
5. Criar série de posts relacionados