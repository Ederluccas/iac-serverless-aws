// 🆓 FREE TIER Serverless Frontend JavaScript

class ServerlessApp {
    constructor() {
        // Initialize with empty values - users need to configure with their Terraform outputs
        this.apiUrl = '';
        this.apiKey = '';
        this.init();
    }

    init() {
        this.bindEvents();
        this.loadConfig();
        this.initTheme();
        this.showWelcomeMessage();
    }

    bindEvents() {
        // Theme Toggle
        document.getElementById('theme-toggle').addEventListener('click', () => {
            this.toggleTheme();
        });

        // Test Connection
        document.getElementById('testConnection').addEventListener('click', () => {
            this.testConnection();
        });

        // Clear Configuration
        document.getElementById('clearConfig').addEventListener('click', () => {
            this.clearConfiguration();
        });

        // Add User Form
        document.getElementById('addUserForm').addEventListener('submit', (e) => {
            e.preventDefault();
            this.addUser();
        });

        // Refresh Users
        document.getElementById('refreshUsers').addEventListener('click', () => {
            this.loadUsers();
        });

        // Save config on input change
        document.getElementById('apiUrl').addEventListener('blur', () => {
            this.saveConfig();
        });

        document.getElementById('apiKey').addEventListener('blur', () => {
            this.saveConfig();
        });
    }

    showWelcomeMessage() {
        this.showStatus('info', 'fa-info-circle', 
            '🚀 Bem-vindo ao IaC Serverless AWS! Para usar sua própria infraestrutura, configure a URL da API e API Key obtidas do comando "terraform output" acima.');
    }

    loadConfig() {
        const savedApiUrl = localStorage.getItem('serverless_api_url');
        const savedApiKey = localStorage.getItem('serverless_api_key');
        
        if (savedApiUrl) {
            document.getElementById('apiUrl').value = savedApiUrl;
            this.apiUrl = savedApiUrl;
        }
        
        if (savedApiKey) {
            document.getElementById('apiKey').value = savedApiKey;
            this.apiKey = savedApiKey;
        }

        // Auto-load users if config exists
        if (this.apiUrl && this.apiKey) {
            setTimeout(() => this.loadUsers(), 1000);
        }
    }

    saveConfig() {
        this.apiUrl = document.getElementById('apiUrl').value.trim();
        this.apiKey = document.getElementById('apiKey').value.trim();
        
        localStorage.setItem('serverless_api_url', this.apiUrl);
        localStorage.setItem('serverless_api_key', this.apiKey);
    }

    clearConfiguration() {
        // Confirm before clearing
        if (confirm('Tem certeza que deseja limpar toda a configuração? Isso irá remover a URL da API e API Key salvos.')) {
            // Clear form fields
            document.getElementById('apiUrl').value = '';
            document.getElementById('apiKey').value = '';
            
            // Clear instance variables
            this.apiUrl = '';
            this.apiKey = '';
            
            // Clear localStorage
            localStorage.removeItem('serverless_api_url');
            localStorage.removeItem('serverless_api_key');
            
            // Clear users list
            document.getElementById('usersContainer').innerHTML = `
                <div class="loading">
                    <i class="fas fa-cog"></i>
                    Configure a API acima para visualizar usuários
                </div>
            `;
            
            // Show status message
            this.showStatus('info', 'fa-info-circle', 
                '🧹 Configuração limpa! Configure a API novamente para usar a aplicação.');
        }
    }

    async testConnection() {
        this.saveConfig();
        
        if (!this.apiUrl || !this.apiKey) {
            this.showStatus('error', 'fa-exclamation-triangle', 
                'Por favor, configure a URL da API e API Key primeiro.');
            return;
        }

        const testBtn = document.getElementById('testConnection');
        const originalText = testBtn.innerHTML;
        testBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Testando...';
        testBtn.disabled = true;

        try {
            const response = await this.makeApiCall('GET', '/users?limit=1');
            
            if (response.ok) {
                this.showStatus('success', 'fa-check-circle', 
                    '✅ Conexão estabelecida com sucesso! API funcionando corretamente.');
                this.loadUsers();
            } else {
                throw new Error(`HTTP ${response.status}: ${response.statusText}`);
            }
        } catch (error) {
            console.error('Connection test failed:', error);
            this.showStatus('error', 'fa-times-circle', 
                `❌ Erro na conexão: ${error.message}. Verifique a URL da API e API Key.`);
        } finally {
            testBtn.innerHTML = originalText;
            testBtn.disabled = false;
        }
    }

    async loadUsers() {
        if (!this.apiUrl || !this.apiKey) {
            document.getElementById('usersContainer').innerHTML = `
                <div class="loading">
                    <i class="fas fa-cog"></i>
                    Configure a API acima para visualizar usuários
                </div>
            `;
            return;
        }

        document.getElementById('usersContainer').innerHTML = `
            <div class="loading">
                <i class="fas fa-spinner fa-spin"></i>
                Carregando usuários...
            </div>
        `;

        try {
            const response = await this.makeApiCall('GET', '/users?limit=25');
            const data = await response.json();

            if (response.ok) {
                this.renderUsers(data.users || []);
                this.showStatus('success', 'fa-check-circle', 
                    `✅ ${data.count || 0} usuários carregados com sucesso.`);
            } else {
                throw new Error(data.message || 'Erro ao carregar usuários');
            }
        } catch (error) {
            console.error('Load users failed:', error);
            this.showStatus('error', 'fa-times-circle', 
                `❌ Erro ao carregar usuários: ${error.message}`);
            document.getElementById('usersContainer').innerHTML = `
                <div class="loading">
                    <i class="fas fa-exclamation-triangle"></i>
                    Erro ao carregar usuários. Verifique a configuração da API.
                </div>
            `;
        }
    }

    async addUser() {
        const name = document.getElementById('userName').value.trim();
        const email = document.getElementById('userEmail').value.trim();

        if (!name || !email) {
            this.showStatus('error', 'fa-exclamation-triangle', 
                'Por favor, preencha nome e email.');
            return;
        }

        if (!this.apiUrl || !this.apiKey) {
            this.showStatus('error', 'fa-exclamation-triangle', 
                'Configure a API primeiro.');
            return;
        }

        const submitBtn = document.querySelector('#addUserForm button[type="submit"]');
        const originalText = submitBtn.innerHTML;
        submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Adicionando...';
        submitBtn.disabled = true;

        try {
            const response = await this.makeApiCall('POST', '/users', {
                name: name,
                email: email
            });

            const data = await response.json();

            if (response.ok) {
                this.showStatus('success', 'fa-check-circle', 
                    `✅ Usuário "${name}" adicionado com sucesso!`);
                document.getElementById('addUserForm').reset();
                this.loadUsers(); // Reload users list
            } else {
                throw new Error(data.message || 'Erro ao adicionar usuário');
            }
        } catch (error) {
            console.error('Add user failed:', error);
            this.showStatus('error', 'fa-times-circle', 
                `❌ Erro ao adicionar usuário: ${error.message}`);
        } finally {
            submitBtn.innerHTML = originalText;
            submitBtn.disabled = false;
        }
    }

    async deleteUser(userId, userName) {
        if (!confirm(`Tem certeza que deseja excluir o usuário "${userName}"?`)) {
            return;
        }

        try {
            // Note: Implementar DELETE endpoint no Lambda se necessário
            this.showStatus('info', 'fa-info-circle', 
                'Funcionalidade de exclusão não implementada no backend. Adicione endpoint DELETE no Lambda.');
        } catch (error) {
            console.error('Delete user failed:', error);
            this.showStatus('error', 'fa-times-circle', 
                `❌ Erro ao excluir usuário: ${error.message}`);
        }
    }

    renderUsers(users) {
        const container = document.getElementById('usersContainer');
        
        if (!users || users.length === 0) {
            container.innerHTML = `
                <div class="loading">
                    <i class="fas fa-users"></i>
                    Nenhum usuário encontrado. Adicione o primeiro usuário acima!
                </div>
            `;
            return;
        }

        const usersHTML = users.map(user => `
            <div class="user-card">
                <div class="user-info">
                    <h4>${this.escapeHtml(user.name)}</h4>
                    <p><i class="fas fa-envelope"></i> ${this.escapeHtml(user.email)}</p>
                    <div class="user-meta">
                        <i class="fas fa-clock"></i> 
                        Criado em: ${this.formatDate(user.createdAt)}
                        ${user.userId ? `| ID: ${user.userId}` : ''}
                    </div>
                </div>
                <div class="user-actions">
                    <button class="btn btn-danger" onclick="app.deleteUser('${user.userId}', '${this.escapeHtml(user.name)}')">
                        <i class="fas fa-trash"></i>
                    </button>
                </div>
            </div>
        `).join('');

        container.innerHTML = usersHTML;
    }

    async makeApiCall(method, endpoint, body = null) {
        const url = this.apiUrl + endpoint;
        const headers = {
            'Content-Type': 'application/json',
            'X-API-Key': this.apiKey
        };

        // Note: Em produção, você precisará implementar AWS Signature V4
        // Para simplicidade, este exemplo assume que você configurou CORS
        // e autenticação adequadamente no API Gateway

        const config = {
            method: method,
            headers: headers,
        };

        if (body && (method === 'POST' || method === 'PUT')) {
            config.body = JSON.stringify(body);
        }

        return fetch(url, config);
    }

    showStatus(type, icon, message) {
        const statusDiv = document.getElementById('connectionStatus');
        statusDiv.className = `status-message ${type}`;
        statusDiv.innerHTML = `<i class="fas ${icon}"></i> ${message}`;
        statusDiv.style.display = 'block';

        // Auto-hide after 5 seconds for non-error messages
        if (type !== 'error') {
            setTimeout(() => {
                statusDiv.style.display = 'none';
            }, 5000);
        }
    }

    escapeHtml(text) {
        const map = {
            '&': '&amp;',
            '<': '&lt;',
            '>': '&gt;',
            '"': '&quot;',
            "'": '&#039;'
        };
        return text.replace(/[&<>"']/g, (m) => map[m]);
    }

    formatDate(dateString) {
        if (!dateString) return 'N/A';
        
        try {
            const date = new Date(dateString);
            return date.toLocaleDateString('pt-BR') + ' ' + 
                   date.toLocaleTimeString('pt-BR', { 
                       hour: '2-digit', 
                       minute: '2-digit' 
                   });
        } catch (error) {
            return dateString;
        }
    }

    // 🌙 Theme Management
    initTheme() {
        console.log('🌙 Initializing theme...');
        const savedTheme = localStorage.getItem('theme') || 'light';
        console.log('Saved theme:', savedTheme);
        this.setTheme(savedTheme);
    }

    toggleTheme() {
        console.log('🌙 Toggling theme...');
        const currentTheme = document.documentElement.getAttribute('data-theme') || 'light';
        console.log('Current theme:', currentTheme);
        const newTheme = currentTheme === 'light' ? 'dark' : 'light';
        console.log('New theme:', newTheme);
        this.setTheme(newTheme);
    }

    setTheme(theme) {
        console.log('🌙 Setting theme to:', theme);
        document.documentElement.setAttribute('data-theme', theme);
        localStorage.setItem('theme', theme);
        
        // Update theme toggle icon
        const themeToggle = document.getElementById('theme-toggle');
        if (themeToggle) {
            const icon = themeToggle.querySelector('i');
            console.log('Found theme toggle button and icon');
            
            if (theme === 'dark') {
                icon.className = 'fas fa-sun';
                themeToggle.setAttribute('aria-label', 'Alternar para modo claro');
                console.log('Changed to sun icon (dark mode)');
            } else {
                icon.className = 'fas fa-moon';
                themeToggle.setAttribute('aria-label', 'Alternar para modo escuro');
                console.log('Changed to moon icon (light mode)');
            }
        } else {
            console.error('Theme toggle button not found!');
        }

        // Show theme change notification
        this.showMessage(`Tema alterado para modo ${theme === 'dark' ? 'escuro' : 'claro'} 🌙`, 'info');
    }
}

// Initialize app when DOM is loaded
document.addEventListener('DOMContentLoaded', () => {
    window.app = new ServerlessApp();
});

// Service Worker for PWA (optional)
if ('serviceWorker' in navigator) {
    window.addEventListener('load', () => {
        navigator.serviceWorker.register('/sw.js')
            .then((registration) => {
                console.log('SW registered: ', registration);
            })
            .catch((registrationError) => {
                console.log('SW registration failed: ', registrationError);
            });
    });
}

// Utility functions
function copyToClipboard(text) {
    navigator.clipboard.writeText(text).then(() => {
        console.log('Copied to clipboard: ', text);
    });
}

// Add some FREE TIER monitoring utilities
class FreeTierMonitor {
    static getUsageInfo() {
        const usage = {
            apiCalls: parseInt(localStorage.getItem('api_calls_today') || '0'),
            lastReset: localStorage.getItem('usage_last_reset') || new Date().toDateString()
        };

        // Reset daily counter
        if (usage.lastReset !== new Date().toDateString()) {
            localStorage.setItem('api_calls_today', '0');
            localStorage.setItem('usage_last_reset', new Date().toDateString());
            usage.apiCalls = 0;
        }

        return usage;
    }

    static incrementApiCall() {
        const current = parseInt(localStorage.getItem('api_calls_today') || '0');
        localStorage.setItem('api_calls_today', (current + 1).toString());
        
        // Warn at 80% of daily limit (assuming 33,333 per day for 1M/month)
        if (current > 26666) {
            console.warn('⚠️ Approaching FREE TIER daily API limit');
        }
    }
}

// Enhance the makeApiCall to track usage
const originalMakeApiCall = ServerlessApp.prototype.makeApiCall;
ServerlessApp.prototype.makeApiCall = function(method, endpoint, body) {
    FreeTierMonitor.incrementApiCall();
    return originalMakeApiCall.call(this, method, endpoint, body);
};