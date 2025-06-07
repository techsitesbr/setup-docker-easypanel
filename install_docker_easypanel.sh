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
    echo -e "$amarelo=                              $verde SETUP AUTOMÁTICO v3.0$reset                                     $amarelo=$reset"
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
    
    dependencias=("curl" "wget" "git" "sudo" "apt-transport-https" "ca-certificates" "gnupg" "lsb-release")
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

instalar_docker() {
    nome_instalando
    echo -e "$azul🐳 Instalando Docker...$reset"
    echo ""
    
    # Remove versões antigas
    apt-get remove -y docker docker-engine docker.io containerd runc > /dev/null 2>&1
    echo "1/6 - [ $verde OK $reset ] - Removendo versões antigas"
    
    # Adiciona repositório oficial do Docker
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg > /dev/null 2>&1
    echo "2/6 - [ $verde OK $reset ] - Adicionando chave GPG"
    
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
    echo "3/6 - [ $verde OK $reset ] - Adicionando repositório"
    
    # Instala Docker
    apt update > /dev/null 2>&1
    echo "4/6 - [ $verde OK $reset ] - Atualizando repositórios"
    
    apt install -y docker-ce docker-ce-cli containerd.io > /dev/null 2>&1
    echo "5/6 - [ $verde OK $reset ] - Instalando Docker CE"
    
    # Inicia e habilita Docker
    systemctl start docker
    systemctl enable docker > /dev/null 2>&1
    echo "6/6 - [ $verde OK $reset ] - Configurando serviço"
    
    echo ""
    echo -e "$verde✅ Docker instalado: $(docker --version)$reset"
    sleep 2
}

instalar_docker_compose() {
    nome_instalando
    echo -e "$azul🔧 Instalando Docker Compose...$reset"
    echo ""
    
    # Download da versão mais recente
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

instalar_easypanel() {
    nome_instalando
    echo -e "$azul🎛️  Instalando Easypanel...$reset"
    echo ""
    
    docker run --rm -v /etc/easypanel:/etc/easypanel -v /var/run/docker.sock:/var/run/docker.sock:ro easypanel/easypanel setup > /dev/null 2>&1
    
    if [ -d "/etc/easypanel" ]; then
        echo "1/2 - [ $verde OK $reset ] - Instalação do Easypanel"
        
        # Configurar firewall se disponível
        if command -v ufw &> /dev/null; then
            ufw allow 80 > /dev/null 2>&1
            ufw allow 443 > /dev/null 2>&1
            echo "2/2 - [ $verde OK $reset ] - Configurando firewall"
        else
            echo "2/2 - [ $amarelo SKIP $reset ] - UFW não encontrado"
        fi
        
        echo ""
        echo -e "$verde✅ Easypanel instalado com sucesso!$reset"
        echo -e "$azul🌐 Acesse: http://$(curl -s ifconfig.me):80$reset"
        echo -e "$amarelo⚠️  Configure email e senha no primeiro acesso$reset"
    else
        echo "1/2 - [ $vermelho ERRO $reset ] - Falha na instalação"
        erro "Falha ao instalar Easypanel"
        return 1
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
    
    # Criar docker-compose.yml para Evolution API
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
      - WEBSOCKET_ENABLED=false
      - CONFIG_SESSION_PHONE_CLIENT=Chrome
      - CONFIG_SESSION_PHONE_NAME=Chrome
    volumes:
      - evolution_instances:/evolution/instances
      - evolution_store:/evolution/store
volumes:
  evolution_instances:
  evolution_store:
EOF
    
    echo "1/2 - [ $verde OK $reset ] - Criando configuração"
    
    docker-compose up -d > /dev/null 2>&1
    echo "2/2 - [ $verde OK $reset ] - Iniciando Evolution API"
    
    echo ""
    echo -e "$verde✅ Evolution API instalada!$reset"
    echo -e "$azul🌐 Acesse: http://$(curl -s ifconfig.me):8080$reset"
    sleep 3
}

configurar_ssl() {
    nome_instalando
    echo -e "$azul🔒 Configurando SSL com Certbot...$reset"
    echo ""
    
    # Instalar snapd e certbot
    apt install -y snapd > /dev/null 2>&1
    echo "1/4 - [ $verde OK $reset ] - Instalando Snapd"
    
    snap install core; snap refresh core > /dev/null 2>&1
    echo "2/4 - [ $verde OK $reset ] - Atualizando Snap"
    
    snap install --classic certbot > /dev/null 2>&1
    echo "3/4 - [ $verde OK $reset ] - Instalando Certbot"
    
    ln -s /snap/bin/certbot /usr/bin/certbot > /dev/null 2>&1
    echo "4/4 - [ $verde OK $reset ] - Configurando Certbot"
    
    echo ""
    echo -e "$verde✅ Certbot instalado!$reset"
    echo -e "$amarelo⚠️  Para configurar SSL, execute: certbot --nginx ou certbot --apache$reset"
    sleep 3
}

instalar_wordpress() {
    nome_instalando
    echo -e "$azul📝 Preparando WordPress via Docker...$reset"
    echo ""
    
    # Criar diretório para WordPress
    mkdir -p /opt/wordpress
    cd /opt/wordpress
    
    # Criar docker-compose.yml para WordPress
    cat > docker-compose.yml << 'EOF'
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
      WORDPRESS_DB_PASSWORD: wordpress_password
      WORDPRESS_DB_NAME: wordpress
    volumes:
      - wordpress_data:/var/www/html
  db:
    image: mysql:5.7
    container_name: wordpress_db
    restart: always
    environment:
      MYSQL_DATABASE: wordpress
      MYSQL_USER: wordpress
      MYSQL_PASSWORD: wordpress_password
      MYSQL_ROOT_PASSWORD: root_password
    volumes:
      - db_data:/var/lib/mysql
volumes:
  wordpress_data:
  db_data:
EOF
    
    echo "1/2 - [ $verde OK $reset ] - Criando configuração WordPress"
    
    docker-compose up -d > /dev/null 2>&1
    echo "2/2 - [ $verde OK $reset ] - Iniciando WordPress"
    
    echo ""
    echo -e "$verde✅ WordPress configurado!$reset"
    echo -e "$azul🌐 Acesse: http://$(curl -s ifconfig.me):8081$reset"
    echo -e "$amarelo⚠️  Complete a instalação no navegador$reset"
    sleep 3
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
    echo -e "$azul│  $branco 2$reset - Instalar Docker                                           │"
    echo -e "$azul│  $branco 3$reset - Instalar Docker Compose                                   │"
    echo -e "$azul│  $branco 4$reset - Instalar Easypanel                                        │"
    echo -e "$azul│  $branco 5$reset - Instalar Evolution API                                    │"
    echo -e "$azul│  $branco 6$reset - Configurar SSL (Certbot)                                  │"
    echo -e "$azul│  $branco 7$reset - Instalar WordPress                                        │"
    echo -e "$azul├─────────────────────────────────────────────────────────────────────┤$reset"
    echo -e "$azul│  $verde 8$reset - Instalação Completa (Docker + Easypanel)                   │"
    echo -e "$azul│  $verde 9$reset - Instalação Full (Tudo)                                     │"
    echo -e "$azul├─────────────────────────────────────────────────────────────────────┤$reset"
    echo -e "$azul│  $vermelho 0$reset - Sair                                                       │"
    echo -e "$azul└─────────────────────────────────────────────────────────────────────┘$reset"
    echo ""
    echo -ne "$amarelo Escolha uma opção: $reset"
}

instalacao_completa() {
    atualizar_sistema
    instalar_dependencias
    instalar_docker
    instalar_docker_compose
    instalar_easypanel
}

instalacao_full() {
    atualizar_sistema
    instalar_dependencias
    instalar_docker
    instalar_docker_compose
    instalar_easypanel
    instalar_evolution_api
    configurar_ssl
    instalar_wordpress
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
            ;;
        3)
            instalar_docker_compose
            ;;
        4)
            instalar_easypanel
            ;;
        5)
            instalar_evolution_api
            ;;
        6)
            configurar_ssl
            ;;
        7)
            instalar_wordpress
            ;;
        8)
            instalacao_completa
            ;;
        9)
            instalacao_full
            ;;
        0)
            clear
            echo -e "$verde✅ Script finalizado. Obrigado por usar o Docker Setup!$reset"
            echo -e "$amarelo📧 Criado por TechSites$reset"
            exit 0
            ;;
        *)
            clear
            echo -e "$vermelho❌ Opção inválida! Pressione Enter para continuar...$reset"
            read
            ;;
    esac
done
