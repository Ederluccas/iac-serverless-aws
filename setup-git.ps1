# 🚀 Script de Deploy para GitHub e GitLab

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "🚀 IaC Serverless AWS - Deploy Setup" -ForegroundColor Green  
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "📋 INSTRUÇÕES PARA PUSH:" -ForegroundColor Yellow
Write-Host ""

Write-Host "🐙 GITHUB:" -ForegroundColor Magenta
Write-Host "1. Acesse: https://github.com/Ederluccas" -ForegroundColor White
Write-Host "2. Clique em 'New repository'" -ForegroundColor White
Write-Host "3. Nome: iac-serverless-aws" -ForegroundColor White
Write-Host "4. Descrição: Serverless AWS Infrastructure with FREE TIER optimization" -ForegroundColor White
Write-Host "5. Público ✅" -ForegroundColor White
Write-Host "6. NÃO inicialize com README (já temos)" -ForegroundColor White
Write-Host "7. Clique 'Create repository'" -ForegroundColor White
Write-Host ""

Write-Host "🦊 GITLAB:" -ForegroundColor Red
Write-Host "1. Acesse: https://gitlab.com/Ederluccas" -ForegroundColor White
Write-Host "2. Clique em 'New project'" -ForegroundColor White
Write-Host "3. Nome: iac-serverless-aws" -ForegroundColor White
Write-Host "4. Descrição: Serverless AWS Infrastructure with FREE TIER optimization" -ForegroundColor White
Write-Host "5. Público ✅" -ForegroundColor White
Write-Host "6. NÃO inicialize com README (já temos)" -ForegroundColor White
Write-Host "7. Clique 'Create project'" -ForegroundColor White
Write-Host ""

Write-Host "⚡ APÓS CRIAR OS REPOSITÓRIOS, EXECUTE:" -ForegroundColor Green
Write-Host ""
Write-Host "# Push para GitHub" -ForegroundColor Cyan
Write-Host "git push -u github main" -ForegroundColor White
Write-Host ""
Write-Host "# Push para GitLab" -ForegroundColor Cyan  
Write-Host "git push -u gitlab main" -ForegroundColor White
Write-Host ""

Write-Host "✅ VERIFICAÇÃO:" -ForegroundColor Green
Write-Host "GitHub: https://github.com/Ederluccas/iac-serverless-aws" -ForegroundColor White
Write-Host "GitLab: https://gitlab.com/Ederluccas/iac-serverless-aws" -ForegroundColor White
Write-Host ""

Write-Host "🔧 REMOTES CONFIGURADOS:" -ForegroundColor Yellow
git remote -v

Write-Host ""
Write-Host "🎯 STATUS ATUAL:" -ForegroundColor Yellow
git status --porcelain
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Repositório limpo - pronto para push!" -ForegroundColor Green
} else {
    Write-Host "⚠️  Há mudanças pendentes" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "📊 ESTATÍSTICAS DO PROJETO:" -ForegroundColor Cyan
$fileCount = (Get-ChildItem -Recurse -File | Where-Object { $_.Name -notlike ".*" -and $_.Extension -ne ".tfstate" }).Count
Write-Host "Arquivos: $fileCount" -ForegroundColor White

$terraformFiles = (Get-ChildItem *.tf).Count
Write-Host "Arquivos Terraform: $terraformFiles" -ForegroundColor White

$frontendFiles = (Get-ChildItem frontend\*.*).Count  
Write-Host "Arquivos Frontend: $frontendFiles" -ForegroundColor White

Write-Host ""
Write-Host "🚀 Projeto pronto para deploy!" -ForegroundColor Green