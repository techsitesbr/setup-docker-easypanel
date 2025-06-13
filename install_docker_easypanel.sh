instalacao_completa_automatica() {
    nome_instalando
    echo -e "$azul🚀 Instalação Completa (Docker + Easypanel)...$reset"
    echo ""
    
    echo -e "$verde📋 Usando o script oficial do Easypanel:$reset"
    echo -e "$branco   curl -sSL https://get.easypanel.io | sh$reset"
    echo ""
    echo -e "$amarelo⚠️  Este comando fará automaticamente:$reset"
    echo -e "$verde   ✅ Instalar Docker$reset"
    echo -e "$verde   ✅ Configurar Docker Swarm$reset"
    echo -e "$verde   ✅ Instalar Easypanel$reset"
    echo -e "$verde   ✅ Configurar todas as dependências$reset"
    echo ""
    
    echo -e "$azul🚀 Executando instalação automática...$reset"
    curl -sSL https://get.easypanel.io | sh
    
    if [ $? -eq 0 ]; then
        echo ""
        echo -e "$verde🎉 INSTALAÇÃO COMPLETA REALIZADA COM SUCESSO! 🎉$reset"
        echo -e "$azul🌐 Acesse: http://$(curl -s ifconfig.me)$reset"
        echo -e "$amarelo⚠️  Configure email e senha no primeiro acesso$reset"
        echo -e "$verde📝 Docker, Docker Swarm e Easypanel foram instalados automaticamente!$reset"
        
        # Aguardar inicialização
        echo ""
        echo -e "$azul⏱️  Aguardando inicialização dos serviços...$reset"
        sleep 30
        
        echo ""
        echo -e "$azul💡 Dicas importantes:$reset"
        echo -e "$branco   • Use a opção 9 para verificar se tudo está funcionando$reset"
        echo -e "$branco   • Para SSL, configure diretamente no painel do Easypanel$reset"
        echo -e "$branco   • Para domínios, aponte seu DNS para: $(curl -s ifconfig.me)$reset"
    else
        echo ""
        erro "Falha na instalação automática. Tente a instalação manual (opções 1-4)."
    fi
    
    sleep 5
}instalar_easypanel() {
    nome_instalando
    echo -e "$azul🎛️  Instalando Easypanel...$reset"
    echo ""
    
    echo -e "$verde📋 Comando executado:$reset"
    echo -e "$branco   docker run --rm -it \\$reset"
    echo -e "$branco     -v /etc/easypanel:/etc/easypanel \\$reset"
    echo -e "$branco     -v /var/run/docker.sock:/var/run/docker.sock:ro \\$reset"
    echo -e "$branco     easypanel/easypanel setup$reset"
    echo ""
    
    # Verificar se Docker está instalado e rodando
    if ! command -v docker &> /dev/null; then
        erro "Docker não está instalado! Execute a opção 2 primeiro."
        return 1
    fi
    
    if ! systemctl is-active --quiet docker; then
        erro "Docker não está rodando! Execute: systemctl start docker"
        return 1
    fi
    
    echo "1/4 - [ $verde OK $reset ] - Docker detectado e rodando"
    
    # Verificar se as portas 80 e 443 estão livres
    if netstat -tuln 2>/dev/null | grep -q ':80 '; then
        echo -e "$amarelo⚠️  Porta 80 está em uso. Parando serviços...$reset"
        systemctl stop nginx apache2 > /dev/null 2>&1
    fi
    
    if netstat -tuln 2>/dev/null | grep -q ':443 '; then
        echo -e "$amarelo⚠️  Porta 443 está em uso. Parando serviços...$reset"
        systemctl stop nginx apache2 > /dev/null 2>&1
    fi
    
    echo "2/4 - [ $verde OK $reset ] - Verificações pré-instalação"
    
    # Método oficial do Easypanel
    echo -e "$azul🚀 Executando instalação do Easypanel...$reset"
    echo ""
    
    docker run --rm -it \
        -v /etc/easypanel:/etc/easypanel \
        -v /var/run/docker.sock:/var/run/docker.sock:ro \
        easypanel/easypanel setup
    
    if [ $? -eq 0 ]; then
        echo ""
        echo "3/4 - [ $verde OK $reset ] - Instalação Easypanel concluída"
    else
        echo ""
        echo "3/4 - [ $vermelho ERRO $reset ] - Falha na instalação"
        erro "Falha ao instalar Easypanel"
        return 1
    fi
    
    # Aguardar alguns segundos para o serviço inicializar
    echo "4/4 - [ $azul WAIT $reset ] - Aguardando inicialização dos serviços..."
    sleep 20
    
    # Verificar se o serviço está rodando
    if docker service ls 2>/dev/null | grep -q easypanel; then
        echo "     [ $verde OK $reset ] - Serviço Easypanel ativo (Swarm mode)"
    elif docker ps | grep -q easypanel; then
        echo "     [ $verde OK $reset ] - Container Easypanel ativo"
    else
        echo "     [ $amarelo WAIT $reset ] - Ainda inicializando... Aguarde mais alguns minutos."
    fi
    
    echo ""
    echo -e "$verde🎉 EASYPANEL INSTALADO COM SUCESSO! 🎉$reset"
    echo -e "$azul🌐 Acesse: http://$(curl -s ifconfig.me)$reset"
    echo -e "$amarelo⚠️  Configure email e senha no primeiro acesso$reset"
    echo -e "$verde📝 Docker Swarm foi configurado automaticamente pelo Easypanel!$reset"
    echo ""
    echo -e "$azul💡 Dicas importantes:$reset"
    echo -e "$branco   • Use a opção 9 para verificar se tudo está funcionando$reset"
    echo -e "$branco   • Para SSL, configure diretamente no painel do Easypanel$reset"
    echo -e "$branco   • Para domínios, aponte seu DNS para: $(curl -s ifconfig.me)$reset"
    sleep 5
}#!/bin/bash

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
    
    dependencias=("curl" "wget" "git" "sudo" "apt-transport-https" "ca-certificates" "gnupg" "lsb-release" "dnsutils" "net-tools")
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
    echo -e "$azul🐳 Instalando Docker (método oficial)...$reset"
    echo ""
    
    # Usar o método oficial do Docker (mesmo que o Easypanel recomenda)
    curl -sSL https://get.docker.com | sh > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "1/3 - [ $verde OK $reset ] - Instalação Docker via script oficial"
    else
        echo "1/3 - [ $vermelho ERRO $reset ] - Falha no script oficial, tentando método manual..."
        
        # Fallback para método manual
        apt-get remove -y docker docker-engine docker.io containerd runc > /dev/null 2>&1
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg > /dev/null 2>&1
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
        apt update > /dev/null 2>&1
        apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin > /dev/null 2>&1
        echo "1/3 - [ $verde OK $reset ] - Instalação manual concluída"
    fi
    
    # Inicia e habilita Docker
    systemctl start docker
    systemctl enable docker > /dev/null 2>&1
    echo "2/3 - [ $verde OK $reset ] - Configurando serviço Docker"
    
    # Adicionar usuário atual ao grupo docker (se não for root)
    if [ "$SUDO_USER" ]; then
        usermod -aG docker $SUDO_USER > /dev/null 2>&1
        echo "3/3 - [ $verde OK $reset ] - Configurando permissões de usuário"
    else
        echo "3/3 - [ $amarelo SKIP $reset ] - Executando como root"
    fi
    
    echo ""
    echo -e "$verde✅ Docker instalado: $(docker --version)$reset"
    echo -e "$amarelo⚠️  IMPORTANTE: O Easypanel irá configurar o Docker Swarm automaticamente$reset"
    sleep 2
}



adicionar_funcoes_easypanel() {
    nome_instalando
    echo -e "$azul🔧 Funções úteis do Easypanel...$reset"
    echo ""
    
    echo -e "$verde📋 Comandos úteis do Easypanel:$reset"
    echo ""
    echo -e "$amarelo🔄 Atualizar Easypanel:$reset"
    echo "docker image pull easypanel/easypanel && docker service update easypanel --force"
    echo ""
    echo -e "$amarelo🔑 Resetar senha:$reset"
    echo "docker run --rm -it -v /etc/easypanel:/etc/easypanel -v /var/run/docker.sock:/var/run/docker.sock:ro easypanel/easypanel reset-password"
    echo ""
    echo -e "$amarelo📊 Verificar status dos serviços:$reset"
    echo "docker service ls"
    echo ""
    echo -e "$amarelo🔍 Ver logs do Easypanel:$reset"
    echo "docker service logs easypanel"
    echo ""
    
    # Criar script de comandos úteis
    cat > /root/easypanel-commands.sh << 'EOF'
#!/bin/bash

echo "=== COMANDOS ÚTEIS DO EASYPANEL ==="
echo ""
echo "1. Atualizar Easypanel:"
echo "   docker image pull easypanel/easypanel && docker service update easypanel --force"
echo ""
echo "2. Resetar senha:"
echo "   docker run --rm -it -v /etc/easypanel:/etc/easypanel -v /var/run/docker.sock:/var/run/docker.sock:ro easypanel/easypanel reset-password"
echo ""
echo "3. Verificar serviços:"
echo "   docker service ls"
echo ""
echo "4. Ver logs:"
echo "   docker service logs easypanel"
echo ""
echo "5. Verificar Docker Swarm:"
echo "   docker node ls"
echo ""
EOF
    
    chmod +x /root/easypanel-commands.sh
    echo -e "$verde✅ Script de comandos salvo em: /root/easypanel-commands.sh$reset"
    
    sleep 5
}

instalar_docker() {
    nome_instalando
    echo -e "$azul🐳 Instalando Docker (método oficial)...$reset"
    echo ""
    
    echo -e "$verde📋 Comando executado:$reset"
    echo -e "$branco   curl -sSL https://get.docker.com | sh$reset"
    echo ""
    
    # Usar o método oficial do Docker
    curl -sSL https://get.docker.com | sh
    
    if [ $? -eq 0 ]; then
        echo ""
        echo "1/3 - [ $verde OK $reset ] - Instalação Docker concluída com sucesso"
    else
        echo ""
        echo "1/3 - [ $vermelho ERRO $reset ] - Falha no script oficial"
        erro "Falha ao instalar Docker"
        return 1
    fi
    
    # Inicia e habilita Docker
    systemctl start docker
    systemctl enable docker > /dev/null 2>&1
    echo "2/3 - [ $verde OK $reset ] - Serviço Docker iniciado e habilitado"
    
    # Adicionar usuário atual ao grupo docker (se não for root)
    if [ "$SUDO_USER" ]; then
        usermod -aG docker $SUDO_USER > /dev/null 2>&1
        echo "3/3 - [ $verde OK $reset ] - Usuário adicionado ao grupo docker"
    else
        echo "3/3 - [ $amarelo SKIP $reset ] - Executando como root"
    fi
    
    echo ""
    echo -e "$verde✅ Docker instalado com sucesso!$reset"
    echo -e "$azul📋 Versão: $(docker --version)$reset"
    echo -e "$amarelo➡️  Próximo passo: Execute a opção 4 para instalar o Easypanel$reset"
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



verificar_servicos() {
    nome_instalando
    echo -e "$azul🔍 Verificando status dos serviços...$reset"
    echo ""
    
    # Verificar Docker
    if systemctl is-active --quiet docker; then
        echo "[ $verde OK $reset ] - Docker: Ativo"
        
        # Verificar Docker Swarm
        SWARM_STATUS=$(docker info --format '{{.Swarm.LocalNodeState}}' 2>/dev/null)
        if [ "$SWARM_STATUS" = "active" ]; then
            echo "[ $verde OK $reset ] - Docker Swarm: Ativo (configurado pelo Easypanel)"
        else
            echo "[ $amarelo INFO $reset ] - Docker Swarm: $SWARM_STATUS"
        fi
    else
        echo "[ $amarelo INFO $reset ] - Docker: Será instalado pelo Easypanel"
    fi
    
    # Verificar UFW (Firewall)
    if systemctl is-active --quiet ufw; then
        echo "[ $verde OK $reset ] - Firewall (UFW): Ativo"
    else
        echo "[ $amarelo INFO $reset ] - Firewall: Não configurado"
    fi
    
    # Verificar serviços Docker (Swarm)
    echo ""
    echo -e "$azul📦 Serviços Docker Swarm:$reset"
    if docker service ls 2>/dev/null | grep -q easypanel; then
        docker service ls --format "table {{.Name}}\t{{.Mode}}\t{{.Replicas}}\t{{.Image}}"
    else
        echo "Easypanel ainda não instalado ou inicializando..."
    fi
    
    # Verificar containers
    echo ""
    echo -e "$azul📦 Containers ativos:$reset"
    if docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" 2>/dev/null | grep -v NAMES; then
        docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
    else
        echo "Nenhum container ativo no momento"
    fi
    
    # Verificar portas em uso
    echo ""
    echo -e "$azul🔌 Status das portas importantes:$reset"
    
    if netstat -tuln 2>/dev/null | grep -q ':80 '; then
        echo "[ $verde OK $reset ] - Porta 80: Em uso (Easypanel)"
    else
        echo "[ $amarelo FREE $reset ] - Porta 80: Livre"
    fi
    
    if netstat -tuln 2>/dev/null | grep -q ':443 '; then
        echo "[ $verde OK $reset ] - Porta 443: Em uso (SSL)"
    else
        echo "[ $amarelo FREE $reset ] - Porta 443: Livre"
    fi
    
    echo ""
    echo -e "$azul🌐 Acessos disponíveis:$reset"
    echo -e "- Easypanel: http://$(curl -s ifconfig.me)"
    echo -e "- IP do servidor: $(curl -s ifconfig.me)"
    
    echo ""
    echo -e "$verde✅ Verificação concluída!$reset"
    echo -e "$amarelo💡 Para problemas, execute: journalctl -fu docker$reset"
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
    echo -e "$azul│  $branco 2$reset - Instalar Docker (método oficial)                           │"
    echo -e "$azul│  $branco 3$reset - Configurar Firewall                                       │"
    echo -e "$azul│  $branco 4$reset - Comandos úteis do Easypanel                               │"
    echo -e "$azul│  $branco 5$reset - Instalar Easypanel                                        │"
    echo -e "$azul│  $branco 6$reset - Configurar SSL (Certbot)                                  │"
    echo -e "$azul├─────────────────────────────────────────────────────────────────────┤$reset"
    echo -e "$azul│  $verde 7$reset - Configurar SSL para Domínio                                │"
    echo -e "$azul├─────────────────────────────────────────────────────────────────────┤$reset"
    echo -e "$azul│  $bege 8$reset - Instalação Completa (Docker + Easypanel + SSL)             │"
    echo -e "$azul│  $bege 9$reset - Verificar Status dos Serviços                              │"
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
    instalar_easypanel
    configurar_ssl_automatico
    
    echo ""
    echo -e "$verde🎉 Instalação completa finalizada!$reset"
    echo -e "$azul🌐 Easypanel: http://$(curl -s ifconfig.me)$reset"
    echo -e "$amarelo💡 Para usar domínio, execute a opção 7 do menu$reset"
    echo -e "$amarelo📝 Docker Swarm foi configurado automaticamente pelo Easypanel$reset"
    sleep 5
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
            instalar_docker
            ;;
        3)
            configurar_firewall
            ;;
        4)
            instalar_easypanel
            ;;
        5)
            instalacao_completa_automatica
            ;;
        9)
            verificar_servicos
            ;;
        0)
            clear
            echo -e "$verde✅ Script finalizado. Obrigado por usar o Easypanel Setup!$reset"
            echo -e "$amarelo📧 Criado por TechSites - Versão Oficial$reset"
            exit 0
            ;;
        *)
            clear
            echo -e "$vermelho❌ Opção inválida! Pressione Enter para continuar...$reset"
            read
            ;;
    esac
done
