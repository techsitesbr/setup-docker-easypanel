#!/bin/bash

## // ## // ## // ## // ## // ## // ## // ## //## // ## // ## // ## // ## // ## // ## // ## // ##
##                                    TECHSITES  - DOCKER SETUP                             ##
## // ## // ## // ## // ## // ## // ## // ## //## // ## // ## // ## // ## // ## // ## // ## // ##

## Cores
amarelo="\e[33m"
verde="\e[32m"
branco="\e[97m"
bege="\e[93m"
vermelho="\e[91m"
azul="\e[34m"
reset="\e[0m"

## // ## // ## // ## // ## // ## // ## // ## //## // ## // ## // ## // ## // ## // ## // ## // ##
##                                         FUNÇÕES DE DISPLAY                                 ##
## // ## // ## // ## // ## // ## // ## // ## //## // ## // ## // ## // ## // ## // ## // ## // ##

nome_logo(){
    clear
    echo ""
    echo -e "$amarelo===================================================================================================$reset"
    echo -e "$amarelo=                                                                                                 $amarelo=$reset"
    echo -e "$amarelo=                     $branco ██████╗  ██████╗  ██████╗██╗  ██╗███████╗██████╗                        $amarelo=$reset"
    echo -e "$amarelo=                     $branco ██╔══██╗██╔═══██╗██╔════╝██║ ██╔╝██╔════╝██╔══██╗                       $amarelo=$reset"
    echo -e "$amarelo=                     $branco ██║  ██║██║   ██║██║     █████╔╝ █████╗  ██████╔╝                       $amarelo=$reset"
    echo -e "$amarelo=                     $branco ██║  ██║██║   ██║██║     ██╔═██╗ ██╔══╝  ██╔══██╗                       $amarelo=$reset"
    echo -e "$amarelo=                     $branco ██████╔╝╚██████╔╝╚██████╗██║  ██╗███████╗██║  ██║                       $amarelo=$reset"
    echo -e "$amarelo=                     $branco ╚═════╝  ╚═════╝  ╚═════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝                       $amarelo=$reset"
    echo -e "$amarelo=                                                                                                 $amarelo=$reset"
    echo -e "$amarelo=                              $verde SETUP AUTOMÁTICO v3.1 - FIXED$reset                              $amarelo=$reset"
    echo -e "$amarelo===================================================================================================$reset"
    echo ""
}

nome_instalando(){
    clear
    echo ""
    echo -e "$amarelo===================================================================================================$reset"
    echo -e "$amarelo=                                                                                                 $amarelo=$reset"
    echo -e "$amarelo=    $branco ██╗███╗   ██╗███████╗████████╗ █████╗ ██╗      █████╗ ███╗   ██╗██████╗  ██████╗        $amarelo=$reset"
    echo -e "$amarelo=    $branco ██║████╗  ██║██╔════╝╚══██╔══╝██╔══██╗██║     ██╔══██╗████╗  ██║██╔══██╗██╔═══██╗       $amarelo=$reset"
    echo -e "$amarelo=    $branco ██║██╔██╗ ██║███████╗   ██║   ███████║██║     ███████║██╔██╗ ██║██║  ██║██║   ██║       $amarelo=$reset"
    echo -e "$amarelo=    $branco ██║██║╚██╗██║╚════██║   ██║   ██╔══██║██║     ██╔══██║██║╚██╗██║██║  ██║██║   ██║       $amarelo=$reset"
    echo -e "$amarelo=    $branco ██║██║ ╚████║███████║   ██║   ██║  ██║███████╗██║  ██║██║ ╚████║██████╔╝╚██████╔╝       $amarelo=$reset"
    echo -e "$amarelo=    $branco ╚═╝╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝  ╚═════╝        $amarelo=$reset"
    echo -e "$amarelo=                                                                                                 $amarelo=$reset"
    echo -e "$amarelo===================================================================================================$reset"
    echo ""
}

## // ## // ## // ## // ## // ## // ## // ## //## // ## // ## // ## // ## // ## // ## // ## // ##
##                                    FUNÇÕES DE VERIFICAÇÃO                                  ##
## // ## // ## // ## // ## // ## // ## // ## //## // ## // ## // ## // ## // ## // ## // ## // ##

log() {
    echo -e "[$verde INFO $reset] $1"
}

erro() {
    echo -e "[$vermelho ERRO $reset] $1"
}

check_error() {
    if [ $? -ne 0 ]; then
        erro "$1"
        exit 1
    fi
}

check_root() {
    if [ "$EUID" -ne 0 ]; then
        erro "Execute este script como root ou com sudo."
        exit 1
    fi
}

check_ubuntu() {
    if ! grep -q 'Ubuntu' /etc/os-release; then
        echo -e "$amarelo⚠️  Aviso: Este script foi testado no Ubuntu. Continuar mesmo assim? (s/n): $reset"
        read -r resposta
        if [[ $resposta != "s" && $resposta != "S" ]]; then
            exit 1
        fi
    fi
}

verificar_dns() {
    local domain=$1
    local server_ip=$(curl -s ifconfig.me)
    
    echo -e "$azul🔍 Verificando DNS para $domain...$reset"
    
    # Verificar se o domínio aponta para o IP do servidor
    domain_ip=$(dig +short $domain | tail -n1)
    
    if [ "$domain_ip" = "$server_ip" ]; then
        echo -e "$verde✅ DNS configurado corretamente ($domain -> $server_ip)$reset"
        return 0
    else
        echo -e "$vermelho❌ DNS não está apontando corretamente$reset"
        echo -e "$amarelo   Domínio aponta para: $domain_ip$reset"
        echo -e "$amarelo   IP do servidor: $server_ip$reset"
        return 1
    fi
}

## // ## // ## // ## // ## // ## // ## // ## //## // ## // ## // ## // ## // ## // ## // ## // ##
##                                    FUNÇÕES DE INSTALAÇÃO                                   ##
## // ## // ## // ## // ## // ## // ## // ## //## // ## // ## // ## // ## // ## // ## // ## // ##

atualizar_sistema() {
    nome_instalando
    echo -e "$azul🔄 Atualizando o sistema...$reset"
    echo ""
    
    apt update > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "1/2 - [ $verde OK $reset ] - APT Update"
    else
        echo "1/2 - [ $vermelho ERRO $reset ] - APT Update"
    fi
    
    apt upgrade -y > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "2/2 - [ $verde OK $reset ] - APT Upgrade"
    else
        echo "2/2 - [ $vermelho ERRO $reset ] - APT Upgrade"
    fi
    
    echo ""
    echo -e "$verde✅ Sistema atualizado com sucesso!$reset"
    sleep 2
}

instalar_dependencias() {
    nome_instalando
    echo -e "$azul📦 Instalando dependências básicas...$reset"
    echo ""
    
    dependencias=("curl" "wget" "git" "sudo" "apt-transport-https" "ca-certificates" "gnupg" "lsb-release" "dnsutils" "nginx")
    contador=1
    total=${#dependencias[@]}
    
    for dep in "${dependencias[@]}"; do
        apt install -y "$dep" > /dev/null 2>&1
        if [ $? -eq 0 ]; then
            echo "$contador/$total - [ $verde OK $reset ] - Instalando $dep"
        else
            echo "$contador/$total - [ $vermelho ERRO $reset ] - Instalando $dep"
        fi
        ((contador++))
    done
    
    echo ""
    echo -e "$verde✅ Dependências instaladas!$reset"
    sleep 2
}

configurar_firewall() {
    nome_instalando
    echo -e "$azul🔥 Configurando firewall...$reset"
    echo ""
    
    # Instalar e configurar UFW
    apt install -y ufw > /dev/null 2>&1
    echo "1/6 - [ $verde OK $reset ] - Instalando UFW"
    
    # Resetar configurações
    ufw --force reset > /dev/null 2>&1
    echo "2/6 - [ $verde OK $reset ] - Resetando configurações"
    
    # Configurar regras básicas
    ufw default deny incoming > /dev/null 2>&1
    ufw default allow outgoing > /dev/null 2>&1
    echo "3/6 - [ $verde OK $reset ] - Configurando políticas padrão"
    
    # Permitir portas essenciais
    ufw allow ssh > /dev/null 2>&1
    ufw allow 22 > /dev/null 2>&1
    ufw allow 80 > /dev/null 2>&1
    ufw allow 443 > /dev/null 2>&1
    echo "4/6 - [ $verde OK $reset ] - Liberando portas HTTP/HTTPS/SSH"
    
    # Permitir portas específicas do Easypanel
    ufw allow 3000 > /dev/null 2>&1
    ufw allow 8080 > /dev/null 2>&1
    ufw allow 8081 > /dev/null 2>&1
    echo "5/6 - [ $verde OK $reset ] - Liberando portas dos serviços"
    
    # Ativar firewall
    ufw --force enable > /dev/null 2>&1
    echo "6/6 - [ $verde OK $reset ] - Ativando firewall"
    
    echo ""
    echo -e "$verde✅ Firewall configurado!$reset"
    sleep 2
}

instalar_docker() {
    nome_instalando
    echo -e "$azul🐳 Instalando Docker...$reset"
    echo ""
    
    # Remove versões antigas
    apt-get remove -y docker docker-engine docker.io containerd runc > /dev/null 2>&1
    echo "1/7 - [ $verde OK $reset ] - Removendo versões antigas"
    
    # Adiciona repositório oficial do Docker
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg > /dev/null 2>&1
    echo "2/7 - [ $verde OK $reset ] - Adicionando chave GPG"
    
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
    echo "3/7 - [ $verde OK $reset ] - Adicionando repositório"
    
    # Instala Docker
    apt update > /dev/null 2>&1
    echo "4/7 - [ $verde OK $reset ] - Atualizando repositórios"
    
    apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin > /dev/null 2>&1
    echo "5/7 - [ $verde OK $reset ] - Instalando Docker CE"
    
    # Inicia e habilita Docker
    systemctl start docker
    systemctl enable docker > /dev/null 2>&1
    echo "6/7 - [ $verde OK $reset ] - Configurando serviço"
    
    # Adicionar usuário atual ao grupo docker (se não for root)
    if [ "$SUDO_USER" ]; then
        usermod -aG docker $SUDO_USER > /dev/null 2>&1
        echo "7/7 - [ $verde OK $reset ] - Configurando permissões de usuário"
    else
        echo "7/7 - [ $amarelo SKIP $reset ] - Executando como root"
    fi
    
    echo ""
    echo -e "$verde✅ Docker instalado: $(docker --version)$reset"
    sleep 2
}

instalar_docker_compose() {
    nome_instalando
    echo -e "$azul🔧 Instalando Docker Compose...$reset"
    echo ""
    
    # O Docker Compose já vem com o Docker moderno, mas vamos garantir a versão standalone
    COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep tag_name | cut -d '"' -f 4)
    echo "1/3 - [ $verde OK $reset ] - Verificando versão mais recente: $COMPOSE_VERSION"
    
    curl -L "https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose > /dev/null 2>&1
    echo "2/3 - [ $verde OK $reset ] - Baixando Docker Compose"
    
    chmod +x /usr/local/bin/docker-compose
    echo "3/3 - [ $verde OK $reset ] - Configurando permissões"
    
    echo ""
    echo -e "$verde✅ Docker Compose instalado: $(docker-compose --version)$reset"
    sleep 2
}

configurar_nginx_proxy() {
    nome_instalando
    echo -e "$azul🌐 Configurando Nginx como proxy reverso...$reset"
    echo ""
    
    # Parar nginx se estiver rodando
    systemctl stop nginx > /dev/null 2>&1
    echo "1/4 - [ $verde OK $reset ] - Parando Nginx"
    
    # Backup da configuração padrão
    if [ -f "/etc/nginx/sites-available/default" ]; then
        cp /etc/nginx/sites-available/default /etc/nginx/sites-available/default.backup > /dev/null 2>&1
    fi
    echo "2/4 - [ $verde OK $reset ] - Backup da configuração"
    
    # Criar configuração básica para proxy
    cat > /etc/nginx/sites-available/default << 'EOF'
server {
    listen 80 default_server;
    listen [::]:80 default_server;
    
    server_name _;
    
    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header Referrer-Policy "no-referrer-when-downgrade" always;
    add_header Content-Security-Policy "default-src 'self' http: https: data: blob: 'unsafe-inline'" always;
    
    location / {
        proxy_pass http://127.0.0.1:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
        proxy_read_timeout 86400;
    }
}
EOF
    echo "3/4 - [ $verde OK $reset ] - Configurando proxy reverso"
    
    # Testar configuração e iniciar
    nginx -t > /dev/null 2>&1 && systemctl start nginx && systemctl enable nginx > /dev/null 2>&1
    echo "4/4 - [ $verde OK $reset ] - Iniciando Nginx"
    
    echo ""
    echo -e "$verde✅ Nginx configurado como proxy reverso!$reset"
    sleep 2
}

instalar_easypanel() {
    nome_instalando
    echo -e "$azul🎛️  Instalando Easypanel...$reset"
    echo ""
    
    # Método oficial atualizado do Easypanel
    curl -sSL https://get.easypanel.io | sh > /dev/null 2>&1
    
    if [ $? -eq 0 ]; then
        echo "1/3 - [ $verde OK $reset ] - Download e instalação do Easypanel"
        
        # Aguardar alguns segundos para o serviço inicializar
        sleep 10
        
        # Verificar se o serviço está rodando
        if docker ps | grep -q easypanel; then
            echo "2/3 - [ $verde OK $reset ] - Serviço Easypanel iniciado"
        else
            echo "2/3 - [ $amarelo WAIT $reset ] - Aguardando inicialização..."
            sleep 5
        fi
        
        # Configurar proxy se nginx estiver instalado
        if systemctl is-active --quiet nginx; then
            echo "3/3 - [ $verde OK $reset ] - Proxy configurado"
        else
            echo "3/3 - [ $amarelo SKIP $reset ] - Nginx não encontrado"
        fi
        
        echo ""
        echo -e "$verde✅ Easypanel instalado com sucesso!$reset"
        echo -e "$azul🌐 Acesse: http://$(curl -s ifconfig.me)$reset"
        echo -e "$amarelo⚠️  Configure email e senha no primeiro acesso$reset"
        echo -e "$amarelo⚠️  Para usar domínios, configure DNS e SSL$reset"
    else
        echo "1/3 - [ $vermelho ERRO $reset ] - Falha na instalação"
        erro "Falha ao instalar Easypanel. Tentando método alternativo..."
        
        # Método alternativo
        docker run -d \
            --name easypanel \
            --restart unless-stopped \
            -p 3000:3000 \
            -v /var/run/docker.sock:/var/run/docker.sock:ro \
            -v easypanel-data:/app/data \
            easypanel/easypanel:latest > /dev/null 2>&1
            
        if [ $? -eq 0 ]; then
            echo -e "$verde✅ Easypanel instalado via método alternativo!$reset"
        else
            erro "Falha na instalação alternativa"
            return 1
        fi
    fi
    sleep 3
}

configurar_ssl_automatico() {
    nome_instalando
    echo -e "$azul🔒 Configurando SSL automático...$reset"
    echo ""
    
    # Instalar snapd e certbot
    apt install -y snapd > /dev/null 2>&1
    echo "1/6 - [ $verde OK $reset ] - Instalando Snapd"
    
    snap install core; snap refresh core > /dev/null 2>&1
    echo "2/6 - [ $verde OK $reset ] - Atualizando Snap"
    
    snap install --classic certbot > /dev/null 2>&1
    echo "3/6 - [ $verde OK $reset ] - Instalando Certbot"
    
    ln -sf /snap/bin/certbot /usr/bin/certbot > /dev/null 2>&1
    echo "4/6 - [ $verde OK $reset ] - Configurando Certbot"
    
    # Instalar plugin nginx
    snap set certbot trust-plugin-with-root=ok > /dev/null 2>&1
    snap install certbot-dns-cloudflare > /dev/null 2>&1
    echo "5/6 - [ $verde OK $reset ] - Instalando plugins"
    
    # Criar script de renovação automática
    cat > /etc/cron.d/certbot-renew << 'EOF'
0 12 * * * root /usr/bin/certbot renew --quiet
EOF
    echo "6/6 - [ $verde OK $reset ] - Configurando renovação automática"
    
    echo ""
    echo -e "$verde✅ Certbot instalado!$reset"
    echo -e "$amarelo💡 Para configurar SSL para um domínio:$reset"
    echo -e "$amarelo   1. Certifique-se que o DNS está apontado corretamente$reset"
    echo -e "$amarelo   2. Execute: certbot --nginx -d seudominio.com$reset"
    sleep 3
}

configurar_ssl_dominio() {
    nome_instalando
    echo -e "$azul🔒 Configuração de SSL para domínio...$reset"
    echo ""
    
    echo -ne "$amarelo Digite seu domínio (ex: exemplo.com): $reset"
    read -r dominio
    
    if [ -z "$dominio" ]; then
        erro "Domínio não pode estar vazio!"
        return 1
    fi
    
    # Verificar DNS
    if ! verificar_dns "$dominio"; then
        echo -e "$vermelho❌ Configure o DNS primeiro no Cloudflare ou seu provedor$reset"
        echo -e "$amarelo   Tipo: A$reset"
        echo -e "$amarelo   Nome: @ (ou seu subdomínio)$reset"
        echo -e "$amarelo   Valor: $(curl -s ifconfig.me)$reset"
        echo -e "$amarelo   TTL: Auto ou 300$reset"
        sleep 5
        return 1
    fi
    
    # Configurar nginx para o domínio
    cat > /etc/nginx/sites-available/$dominio << EOF
server {
    listen 80;
    server_name $dominio www.$dominio;
    
    location / {
        proxy_pass http://127.0.0.1:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_cache_bypass \$http_upgrade;
        proxy_read_timeout 86400;
    }
}
EOF
    
    # Ativar site
    ln -sf /etc/nginx/sites-available/$dominio /etc/nginx/sites-enabled/ > /dev/null 2>&1
    nginx -t > /dev/null 2>&1 && systemctl reload nginx > /dev/null 2>&1
    
    echo -e "$verde✅ Configuração Nginx criada para $dominio$reset"
    
    # Obter certificado SSL
    echo -e "$azul🔐 Obtendo certificado SSL...$reset"
    certbot --nginx -d $dominio -d www.$dominio --non-interactive --agree-tos --email admin@$dominio
    
    if [ $? -eq 0 ]; then
        echo -e "$verde✅ SSL configurado com sucesso!$reset"
        echo -e "$azul🌐 Acesse: https://$dominio$reset"
    else
        erro "Falha ao obter certificado SSL"
    fi
    
    sleep 3
}

instalar_evolution_api() {
    nome_instalando
    echo -e "$azul📱 Instalando Evolution API...$reset"
    echo ""
    
    # Criar diretório para Evolution API
    mkdir -p /opt/evolution-api
    cd /opt/evolution-api
    
    # Criar docker-compose.yml para Evolution API com configurações otimizadas
    cat > docker-compose.yml << 'EOF'
version: '3.8'
services:
  evolution-api:
    image: davidsongomes/evolution-api:latest
    container_name: evolution-api
    restart: always
    ports:
      - "8080:8080"
    environment:
      - DATABASE_ENABLED=false
      - REDIS_ENABLED=false
      - RABBITMQ_ENABLED=false
      - WEBSOCKET_ENABLED=true
      - CONFIG_SESSION_PHONE_CLIENT=Chrome
      - CONFIG_SESSION_PHONE_NAME=Chrome
      - SERVER_TYPE=http
      - CORS_ORIGIN=*
      - CORS_METHODS=GET,POST,PUT,DELETE,OPTIONS
      - DEL_INSTANCE=false
    volumes:
      - evolution_instances:/evolution/instances
      - evolution_store:/evolution/store
    networks:
      - evolution_network
      
networks:
  evolution_network:
    driver: bridge
    
volumes:
  evolution_instances:
  evolution_store:
EOF
    
    echo "1/3 - [ $verde OK $reset ] - Criando configuração"
    
    docker-compose up -d > /dev/null 2>&1
    echo "2/3 - [ $verde OK $reset ] - Iniciando Evolution API"
    
    # Aguardar inicialização
    sleep 10
    
    # Verificar se está rodando
    if docker ps | grep -q evolution-api; then
        echo "3/3 - [ $verde OK $reset ] - Serviço verificado"
    else
        echo "3/3 - [ $amarelo WAIT $reset ] - Aguardando inicialização..."
    fi
    
    echo ""
    echo -e "$verde✅ Evolution API instalada!$reset"
    echo -e "$azul🌐 Acesse: http://$(curl -s ifconfig.me):8080$reset"
    echo -e "$amarelo📖 Documentação: http://$(curl -s ifconfig.me):8080/manager$reset"
    sleep 3
}

instalar_wordpress() {
    nome_instalando
    echo -e "$azul📝 Preparando WordPress via Docker...$reset"
    echo ""
    
    # Criar diretório para WordPress
    mkdir -p /opt/wordpress
    cd /opt/wordpress
    
    # Gerar senhas seguras
    MYSQL_ROOT_PASSWORD=$(openssl rand -base64 32)
    MYSQL_PASSWORD=$(openssl rand -base64 32)
    
    # Criar docker-compose.yml para WordPress com configurações seguras
    cat > docker-compose.yml << EOF
version: '3.8'
services:
  wordpress:
    image: wordpress:latest
    container_name: wordpress
    restart: always
    ports:
      - "8081:80"
    environment:
      WORDPRESS_DB_HOST: db:3306
      WORDPRESS_DB_USER: wordpress
      WORDPRESS_DB_PASSWORD: $MYSQL_PASSWORD
      WORDPRESS_DB_NAME: wordpress
      WORDPRESS_CONFIG_EXTRA: |
        define('WP_REDIS_HOST', 'redis');
        define('WP_REDIS_PORT', 6379);
    volumes:
      - wordpress_data:/var/www/html
    depends_on:
      - db
      - redis
    networks:
      - wordpress_network
      
  db:
    image: mysql:8.0
    container_name: wordpress_db
    restart: always
    environment:
      MYSQL_DATABASE: wordpress
      MYSQL_USER: wordpress
      MYSQL_PASSWORD: $MYSQL_PASSWORD
      MYSQL_ROOT_PASSWORD: $MYSQL_ROOT_PASSWORD
    volumes:
      - db_data:/var/lib/mysql
    networks:
      - wordpress_network
    command: '--default-authentication-plugin=mysql_native_password'
    
  redis:
    image: redis:alpine
    container_name: wordpress_redis
    restart: always
    networks:
      - wordpress_network
      
networks:
  wordpress_network:
    driver: bridge
    
volumes:
  wordpress_data:
  db_data:
EOF
    
    echo "1/4 - [ $verde OK $reset ] - Criando configuração WordPress"
    
    # Salvar credenciais
    cat > .env << EOF
MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD
MYSQL_PASSWORD=$MYSQL_PASSWORD
EOF
    
    echo "2/4 - [ $verde OK $reset ] - Gerando credenciais seguras"
    
    docker-compose up -d > /dev/null 2>&1
    echo "3/4 - [ $verde OK $reset ] - Iniciando WordPress"
    
    # Aguardar inicialização
    sleep 15
    echo "4/4 - [ $verde OK $reset ] - Verificando serviços"
    
    echo ""
    echo -e "$verde✅ WordPress configurado!$reset"
    echo -e "$azul🌐 Acesse: http://$(curl -s ifconfig.me):8081$reset"
    echo -e "$amarelo⚠️  Complete a instalação no navegador$reset"
    echo -e "$amarelo🔑 Credenciais salvas em: /opt/wordpress/.env$reset"
    sleep 3
}

verificar_servicos() {
    nome_instalando
    echo -e "$azul🔍 Verificando status dos serviços...$reset"
    echo ""
    
    # Verificar Docker
    if systemctl is-active --quiet docker; then
        echo "[ $verde OK $reset ] - Docker: Ativo"
    else
        echo "[ $vermelho ERRO $reset ] - Docker: Inativo"
    fi
    
    # Verificar Nginx
    if systemctl is-active --quiet nginx; then
        echo "[ $verde OK $reset ] - Nginx: Ativo"
    else
        echo "[ $amarelo SKIP $reset ] - Nginx: Não instalado/inativo"
    fi
    
    # Verificar containers
    echo ""
    echo -e "$azul📦 Containers ativos:$reset"
    docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" 2>/dev/null || echo "Nenhum container ativo"
    
    echo ""
    echo -e "$azul🌐 Serviços disponíveis:$reset"
    echo -e "- Easypanel: http://$(curl -s ifconfig.me)"
    echo -e "- Evolution API: http://$(curl -s ifconfig.me):8080"
    echo -e "- WordPress: http://$(curl -s ifconfig.me):8081"
    
    echo ""
    echo -e "$verde✅ Verificação concluída!$reset"
    sleep 5
}

## // ## // ## // ## // ## // ## // ## // ## //## // ## // ## // ## // ## // ## // ## // ## // ##
##                                        MENU PRINCIPAL                                      ##
## // ## // ## // ## // ## // ## // ## // ## //## // ## // ## // ## // ## // ## // ## // ## // ##

mostrar_menu() {
    nome_logo
    echo -e "$azul┌─────────────────────────────────────────────────────────────────────┐$reset"
    echo -e "$azul│                        MENU DE INSTALAÇÃO                          │$reset"
    echo -e "$azul├─────────────────────────────────────────────────────────────────────┤$reset"
    echo -e "$azul│  $branco 1$reset - Atualizar Sistema Ubuntu                                  │"
    echo -e "$azul│  $branco 2$reset - Instalar Docker + Compose                                 │"
    echo -e "$azul│  $branco 3$reset - Configurar Firewall                                       │"
    echo -e "$azul│  $branco 4$reset - Configurar Nginx (Proxy Reverso)                          │"
    echo -e "$azul│  $branco 5$reset - Instalar Easypanel                                        │"
    echo -e "$azul│  $branco 6$reset - Instalar Evolution API                                    │"
    echo -e "$azul│  $branco 7$reset - Instalar WordPress                                        │"
    echo -e "$azul├─────────────────────────────────────────────────────────────────────┤$reset"
    echo -e "$azul│  $verde 8$reset - Configurar SSL (Certbot)                                   │"
    echo -e "$azul│  $verde 9$reset - Configurar SSL para Domínio                                │"
    echo -e "$azul├─────────────────────────────────────────────────────────────────────┤$reset"
    echo -e "$azul│  $bege 10$reset - Instalação Completa (Docker + Easypanel + SSL)            │"
    echo -e "$azul│  $bege 11$reset - Instalação Full (Tudo + Configurações)                    │"
    echo -e "$azul│  $bege 12$reset - Verificar Status dos Serviços                             │"
    echo -e "$azul├─────────────────────────────────────────────────────────────────────┤$reset"
    echo -e "$azul│  $vermelho 0$reset - Sair                                                       │"
    echo -e "$azul└─────────────────────────────────────────────────────────────────────┘$reset"
    echo ""
    echo -ne "$amarelo Escolha uma opção: $reset"
}

instalacao_completa() {
    atualizar_sistema
    instalar_dependencias
    configurar_firewall
    instalar_docker
    instalar_docker_compose
    configurar_nginx_proxy
    instalar_easypanel
    configurar_ssl_automatico
    
    echo ""
    echo -e "$verde🎉 Instalação completa finalizada!$reset"
    echo -e "$azul🌐 Easypanel: http://$(curl -s ifconfig.me)$reset"
    echo -e "$amarelo💡 Para usar domínio, execute a opção 9 do menu$reset"
    sleep 5
}

instalacao_full() {
    atualizar_sistema
    instalar_dependencias
    configurar_firewall
    instalar_docker
    instalar_docker_compose
    configurar_nginx_proxy
    instalar_easypanel
    instalar_evolution_api
    instalar_wordpress
    configurar_ssl_automatico
    
    echo ""
    echo -e "$verde🎉 Instalação completa finalizada!$reset"
    echo -e "$azul🌐 Todos os serviços instalados e configurados!$reset"
    verificar_servicos
}

## // ## // ## // ## // ## // ## // ## // ## //## // ## // ## // ## // ## // ## // ## // ## // ##
##                                         MAIN SCRIPT                                        ##
## // ## // ## // ## // ## // ## // ## // ## //## // ## // ## // ## // ## // ## // ## // ## // ##

# Verificações iniciais
check_root
check_ubuntu

# Loop principal
while true; do
    mostrar_menu
    read -r opcao
    
    case $opcao in
        1)
            atualizar_sistema
            ;;
        2)
            instalar_dependencias
            instalar_docker
            instalar_docker_compose
            ;;
        3)
            configurar_firewall
            ;;
        4)
            configurar_nginx_proxy
            ;;
        5)
            instalar_easypanel
            ;;
        6)
            instalar_evolution_api
            ;;
        7)
            instalar_wordpress
            ;;
        8)
            configurar_ssl_automatico
            ;;
        9)
            configurar_ssl_dominio
            ;;
        10)
            instalacao_completa
            ;;
        11)
            instalacao_full
            ;;
        12)
            verificar_servicos
            ;;
        0)
            clear
            echo -e "$verde✅ Script finalizado. Obrigado por usar o Docker Setup!$reset"
            echo -e "$amarelo📧 Criado por TechSites - Versão Corrigida$reset"
            exit 0
            ;;
        *)
            clear
            echo -e "$vermelho❌ Opção inválida! Pressione Enter para continuar...$reset"
            read
            ;;
    esac
done
