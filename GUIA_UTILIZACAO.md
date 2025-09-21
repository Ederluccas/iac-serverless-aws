# 📖 Guia de Utilização - Aplicação Serverless

## 🚀 **Passo a Passo Completo**

### **Pré-requisitos**
- ✅ Terraform instalado (versão >= 1.6.0)
- ✅ AWS CLI configurado com credenciais
- ✅ Navegador web moderno (Chrome, Firefox, Edge)

---

## 🏗️ **FASE 1: DEPLOY DA INFRAESTRUTURA**

### **1.1 Preparar o Ambiente**
```powershell
# Clone o repositório
git clone https://github.com/Ederluccas/iac-serverless-aws.git
cd iac-serverless-aws

# Verificar versão do Terraform
terraform version

# Verificar AWS CLI
aws --version
aws sts get-caller-identity
```

### **1.2 Deploy dos Recursos**
```powershell
# Inicializar Terraform
terraform init

# Validar configuração
terraform validate

# Planejar deployment
terraform plan

# Aplicar mudanças
terraform apply
# Digite 'yes' quando solicitado
```

### **1.3 Obter URLs de Acesso**
```powershell
# Ver outputs importantes
terraform output

# Salvar informações importantes:
# - cloudfront_distribution_domain_name
# - api_gateway_invoke_url  
# - api_key_value
```

---

## 🌐 **FASE 2: ACESSAR A APLICAÇÃO**

### **2.1 Abrir a Aplicação Web**

1. **Copie a URL do CloudFront** obtida no terraform output
2. **Cole no navegador:** `https://d3hg8r3vfucvhl.cloudfront.net`
3. **Aguarde carregar** (primeiro acesso pode demorar ~30s)

### **2.2 Interface Principal**

**📱 Layout Responsivo:**
- **Header:** Título + Botão modo escuro
- **Main:** Formulário de gerenciamento de itens
- **Footer:** Links para documentação

**🎨 Modo Escuro:**
- **Botão no header:** 🌙/☀️ para alternar tema
- **Persistência:** Preferência salva no navegador
- **Transições suaves** entre temas

---

## 📋 **FASE 3: FUNCIONALIDADES**

### **3.1 Adicionar Item**

1. **Preencha o formulário:**
   - **Nome:** Digite o nome do item
   - **Descrição:** Adicione detalhes opcionais

2. **Clique em "Adicionar Item"**

3. **Resultado esperado:**
   - ✅ Item aparece na lista abaixo
   - ✅ Formulário é limpo automaticamente
   - ✅ Mensagem de sucesso (se configurada)

**📝 Exemplo:**
```
Nome: Produto Demo
Descrição: Item de teste para demonstração
```

### **3.2 Visualizar Lista**

**📋 Lista de Itens:**
- **Cards responsivos** para cada item
- **Nome em destaque**
- **Descrição** como subtítulo
- **Botões de ação:** Editar | Excluir

**🔍 Funcionalidades:**
- **Carregamento automático** na inicialização
- **Atualização dinâmica** após mudanças
- **Loading states** durante operações

### **3.3 Editar Item**

1. **Clique no botão "Editar"** no card do item
2. **Formulário será preenchido** com dados atuais
3. **Modifique os campos** desejados
4. **Clique "Atualizar Item"**
5. **Item é atualizado** na lista automaticamente

### **3.4 Excluir Item**

1. **Clique no botão "Excluir"** no card
2. **Confirme a ação** (se popup configurado)
3. **Item é removido** da lista imediatamente

---

## 🎯 **FASE 4: RECURSOS AVANÇADOS**

### **4.1 Modo Escuro**

**🌙 Ativação:**
1. **Clique no ícone** no header (🌙/☀️)
2. **Interface muda** instantaneamente
3. **Preferência é salva** no localStorage
4. **Reabre sempre** no último modo usado

**🎨 Diferenças Visuais:**
- **Fundo escuro** com texto claro
- **Cards com bordas** sutis
- **Botões com cores** adaptadas
- **Melhor para uso noturno**

### **4.2 PWA (Progressive Web App)**

**📱 Instalação:**
1. **Chrome/Edge:** Ícone + na barra de endereços
2. **Firefox:** Menu → Instalar aplicativo
3. **Mobile:** "Adicionar à tela inicial"

**⚡ Recursos PWA:**
- **Funciona offline** (cache básico)
- **Ícone na área de trabalho**
- **Experiência tipo app nativo**
- **Atualizações automáticas**

### **4.3 API Direta (Desenvolvedores)**

**🔧 Endpoints Disponíveis:**
```bash
# Base URL (obtida do terraform output)
API_URL="https://abc123.execute-api.ap-southeast-2.amazonaws.com/dev"
API_KEY="sua-api-key-aqui"

# Listar itens
curl -X GET "$API_URL/items" \
  -H "x-api-key: $API_KEY"

# Criar item
curl -X POST "$API_URL/items" \
  -H "x-api-key: $API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"name":"Teste","description":"Via API"}'

# Atualizar item
curl -X PUT "$API_URL/items/item-id" \
  -H "x-api-key: $API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"name":"Atualizado","description":"Via API"}'

# Excluir item  
curl -X DELETE "$API_URL/items/item-id" \
  -H "x-api-key: $API_KEY"
```

---

## 🔍 **FASE 5: MONITORAMENTO**

### **5.1 AWS CloudWatch**

**📊 Métricas Importantes:**
1. **AWS Console → CloudWatch → Metrics**
2. **Lambda:** Invocations, Duration, Errors
3. **API Gateway:** Count, Latency, 4XXError
4. **DynamoDB:** ConsumedReadCapacity, ConsumedWriteCapacity
5. **CloudFront:** Requests, BytesDownloaded

### **5.2 Logs de Depuração**

**🔧 CloudWatch Logs:**
```bash
# Via AWS CLI
aws logs describe-log-groups --log-group-name-prefix "/aws/lambda"

# Ver logs específicos
aws logs tail "/aws/lambda/serverless-crud-function" --follow
```

**🌐 Browser DevTools:**
- **F12 → Console:** Logs de JavaScript
- **Network Tab:** Requests para API
- **Application Tab:** localStorage (tema)
- **Lighthouse:** Performance audit

---

## ❗ **FASE 6: TROUBLESHOOTING**

### **6.1 Problemas Comuns**

**🔴 "API Gateway não responde"**
```bash
# Verificar se API foi deployada
aws apigateway get-rest-apis

# Testar endpoint diretamente
curl -I https://sua-api-url/dev/items
```

**🔴 "Página não carrega"**
```bash
# Verificar CloudFront
aws cloudfront list-distributions

# Invalidar cache se necessário
aws cloudfront create-invalidation \
  --distribution-id E123456789 \
  --paths "/*"
```

**🔴 "Items não salvam"**
```bash
# Verificar DynamoDB
aws dynamodb list-tables
aws dynamodb scan --table-name serverless-crud-table
```

### **6.2 Reset Completo**

**🔄 Recriar Infraestrutura:**
```powershell
# Destruir recursos
terraform destroy
# Digite 'yes' para confirmar

# Recriar tudo
terraform apply
# Digite 'yes' para confirmar
```

---

## ✅ **FASE 7: VALIDAÇÃO**

### **7.1 Checklist de Funcionamento**

- [ ] **Página carrega** em <5 segundos
- [ ] **Modo escuro** funciona e persiste
- [ ] **Adicionar item** funciona
- [ ] **Lista** mostra items adicionados
- [ ] **Editar item** funciona
- [ ] **Excluir item** funciona
- [ ] **PWA** pode ser instalado
- [ ] **API direta** responde com API key

### **7.2 Testes de Performance**

**⚡ Métricas Esperadas:**
- **First Load:** <3 segundos
- **API Response:** <500ms
- **Theme Toggle:** <100ms
- **CRUD Operations:** <1 segundo
- **Mobile Performance:** >90 Lighthouse score

---

## 🎓 **CONCLUSÃO**

### **🏆 Parabéns!** 

Você tem uma **aplicação serverless completa** funcionando com:

- ✅ **Frontend moderno** com modo escuro
- ✅ **API REST** securizada
- ✅ **Banco NoSQL** escalável
- ✅ **CDN global** para performance
- ✅ **PWA** instalável
- ✅ **FREE TIER** otimizado
- ✅ **Monitoramento** integrado

### **🚀 Próximos Passos:**

1. **Personalize** o frontend com sua marca
2. **Adicione autenticação** com Cognito
3. **Implemente** casos de uso específicos
4. **Monitore** uso do FREE TIER
5. **Escale** conforme necessário

### **💡 Dicas Pro:**

- **Bookmark** a URL do CloudFront
- **Monitore** métricas semanalmente  
- **Documente** customizações
- **Teste** em diferentes dispositivos
- **Compartilhe** com sua equipe

---

**🎯 Sua aplicação serverless está pronta para produção!** 🚀