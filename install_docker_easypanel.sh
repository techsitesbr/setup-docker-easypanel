#!/bin/bash

##
## EASYPANEL QUICK INSTALL - TechSites
## Versão: 3.2 - FIXED
##

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
RESET='\033[0m'

# Verificar se é root
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}❌ Execute este script como root: sudo $0${RESET}"
    exit 1
fi

# Banner
clear
echo -e "${CYAN}
╔══════════════════════════════════════════════════════════════════════╗
║                         EASYPANEL INSTALLER                         ║
║                           TechSites - v3.2                          ║
╚══════════════════════════════════════════════════════════════════════╝
${RESET}"

# Função de log
log() {
    echo -e "${GREEN}[INFO]${RESET} $1"
}

error() {
    echo -e "${RED}[ERRO]${RESET} $1"
}

warning() {
    echo -e "${YELLOW}[AVISO]${RESET} $1"
}

# Verificar Ubuntu
check_ubuntu() {
    if ! grep -q 'Ubuntu' /etc/os-release 2>/dev/null; then
        warning "Este script foi testado no Ubuntu. Continuar? (s/n)"
        read -r resposta
        if [[ $resposta != "s" && $resposta != "S" ]]; then
            exit 1
        fi
    fi
}

# Função para atualizar sistema
update_system() {
    log "🔄 Atualizando sistema Ubuntu..."
    echo ""
    
    # Atualizar lista de pacotes
    log "1/2 - Atualizando lista de pacotes (apt update)..."
    apt update -y
    
    if [ $? -eq 0 ]; then
        echo -e "   ${GREEN}✓${RESET} apt update concluído"
    else
        error "Falha no apt update"
        return 1
    fi
    
    # Atualizar pacotes
    log "2/2 - Atualizando pacotes (apt upgrade)..."
    apt upgrade -y
    
    if [ $? -eq 0 ]; then
        echo -e "   ${GREEN}✓${RESET} apt upgrade concluído"
        log "✅ Sistema Ubuntu atualizado com sucesso!"
    else
        error "Falha no apt upgrade"
        return 1
    fi
    
    echo ""
    sleep 2
}

# Função principal de instalação
install_easypanel_official() {
    log "🚀 Iniciando instalação do Easypanel via script oficial..."
    echo ""
    
    log "📋 Este processo irá:"
    echo -e "   ${GREEN}✓${RESET} Atualizar sistema Ubuntu"
    echo -e "   ${GREEN}✓${RESET} Instalar Docker automaticamente"
    echo -e "   ${GREEN}✓${RESET} Configurar Docker Swarm"
    echo -e "   ${GREEN}✓${RESET} Instalar Easypanel"
    echo -e "   ${GREEN}✓${RESET} Configurar todas as dependências"
    echo ""
    
    # Confirmar instalação
    echo -e "${YELLOW}Deseja continuar com a instalação? (s/n):${RESET} "
    read -r confirm
    if [[ $confirm != "s" && $confirm != "S" ]]; then
        error "Instalação cancelada pelo usuário."
        exit 1
    fi
    
    echo ""
    
    # Atualizar sistema primeiro
    update_system
    
    log "🔄 Executando: curl -sSL https://get.easypanel.io | sh"
    echo ""
    
    # Executar instalação oficial
    curl -sSL https://get.easypanel.io | sh
    
    # Verificar se a instalação foi bem-sucedida
    if [ $? -eq 0 ]; then
        echo ""
        echo -e "${GREEN}🎉 INSTALAÇÃO CONCLUÍDA COM SUCESSO! 🎉${RESET}"
        echo ""
        
        # Aguardar inicialização
        log "⏱️  Aguardando inicialização dos serviços (30 segundos)..."
        sleep 30
        
        # Obter IP público
        PUBLIC_IP=$(curl -s ifconfig.me 2>/dev/null || curl -s icanhazip.com 2>/dev/null || echo "SEU_IP")
        
        echo ""
        echo -e "${CYAN}🌐 INFORMAÇÕES DE ACESSO:${RESET}"
        echo -e "   ${WHITE}URL:${RESET} http://$PUBLIC_IP"
        echo -e "   ${WHITE}IP:${RESET} $PUBLIC_IP"
        echo ""
        
        echo -e "${YELLOW}📝 PRÓXIMOS PASSOS:${RESET}"
        echo -e "   ${GREEN}1.${RESET} Acesse http://$PUBLIC_IP no seu navegador"
        echo -e "   ${GREEN}2.${RESET} Configure email e senha no primeiro acesso"
        echo -e "   ${GREEN}3.${RESET} Para domínios, aponte seu DNS para: $PUBLIC_IP"
        echo ""
        
        echo -e "${CYAN}💡 DICAS IMPORTANTES:${RESET}"
        echo -e "   ${WHITE}•${RESET} Para SSL, configure diretamente no painel do Easypanel"
        echo -e "   ${WHITE}•${RESET} Para verificar serviços: docker service ls"
        echo -e "   ${WHITE}•${RESET} Para logs: docker service logs easypanel"
        echo ""
        
    else
        echo ""
        error "❌ Falha na instalação do Easypanel"
        echo ""
        echo -e "${YELLOW}Possíveis soluções:${RESET}"
        echo -e "   ${WHITE}1.${RESET} Verificar conexão com a internet"
        echo -e "   ${WHITE}2.${RESET} Tentar novamente em alguns minutos"
        echo -e "   ${WHITE}3.${RESET} Verificar se as portas 80 e 443 estão livres"
        echo ""
        exit 1
    fi
}

# Função para instalação manual passo a passo
install_manual() {
    log "🔧 Instalação manual passo a passo..."
    echo ""
    
    # 1. Atualizar sistema
    log "1/5 - Atualizando sistema..."
    apt update -y >/dev/null 2>&1
    apt upgrade -y >/dev/null 2>&1
    
    # 2. Instalar dependências
    log "2/5 - Instalando dependências..."
    apt install -y curl wget git sudo apt-transport-https ca-certificates gnupg lsb-release >/dev/null 2>&1
    
    # 3. Instalar Docker
    log "3/5 - Instalando Docker..."
    curl -sSL https://get.docker.com | sh >/dev/null 2>&1
    systemctl start docker
    systemctl enable docker >/dev/null 2>&1
    
    # 4. Configurar Firewall
    log "4/5 - Configurando firewall..."
    ufw --force reset >/dev/null 2>&1
    ufw default deny incoming >/dev/null 2>&1
    ufw default allow outgoing >/dev/null 2>&1
    ufw allow ssh >/dev/null 2>&1
    ufw allow 80 >/dev/null 2>&1
    ufw allow 443 >/dev/null 2>&1
    ufw --force enable >/dev/null 2>&1
    
    # 5. Instalar Easypanel
    log "5/5 - Instalando Easypanel..."
    docker run --rm -it \
        -v /etc/easypanel:/etc/easypanel \
        -v /var/run/docker.sock:/var/run/docker.sock:ro \
        easypanel/easypanel setup
    
    if [ $? -eq 0 ]; then
        PUBLIC_IP=$(curl -s ifconfig.me 2>/dev/null)
        echo ""
        echo -e "${GREEN}✅ Instalação manual concluída!${RESET}"
        echo -e "${CYAN}🌐 Acesse: http://$PUBLIC_IP${RESET}"
    else
        error "❌ Falha na instalação manual"
        exit 1
    fi
}

# Função para verificar status
check_status() {
    log "🔍 Verificando status dos serviços..."
    echo ""
    
    # Docker
    if systemctl is-active --quiet docker; then
        echo -e "${GREEN}✓${RESET} Docker: Ativo"
        
        # Docker Swarm
        SWARM_STATUS=$(docker info --format '{{.Swarm.LocalNodeState}}' 2>/dev/null)
        if [ "$SWARM_STATUS" = "active" ]; then
            echo -e "${GREEN}✓${RESET} Docker Swarm: Ativo"
        else
            echo -e "${YELLOW}!${RESET} Docker Swarm: $SWARM_STATUS"
        fi
    else
        echo -e "${RED}✗${RESET} Docker: Inativo"
    fi
    
    # Easypanel
    if docker service ls 2>/dev/null | grep -q easypanel; then
        echo -e "${GREEN}✓${RESET} Easypanel: Ativo (Swarm mode)"
        docker service ls --format "table {{.Name}}\t{{.Mode}}\t{{.Replicas}}"
    elif docker ps | grep -q easypanel; then
        echo -e "${GREEN}✓${RESET} Easypanel: Ativo (Container mode)"
    else
        echo -e "${YELLOW}!${RESET} Easypanel: Não encontrado ou inicializando"
    fi
    
    # Portas
    echo ""
    log "Status das portas:"
    if netstat -tuln 2>/dev/null | grep -q ':80 '; then
        echo -e "${GREEN}✓${RESET} Porta 80: Em uso"
    else
        echo -e "${YELLOW}!${RESET} Porta 80: Livre"
    fi
    
    if netstat -tuln 2>/dev/null | grep -q ':443 '; then
        echo -e "${GREEN}✓${RESET} Porta 443: Em uso"
    else
        echo -e "${YELLOW}!${RESET} Porta 443: Livre"
    fi
    
    # IP
    PUBLIC_IP=$(curl -s ifconfig.me 2>/dev/null)
    echo ""
    echo -e "${CYAN}🌐 IP Público: $PUBLIC_IP${RESET}"
    echo -e "${CYAN}🔗 Easypanel: http://$PUBLIC_IP${RESET}"
}

# Menu principal
show_menu() {
    clear
    echo -e "${CYAN}
╔══════════════════════════════════════════════════════════════════════╗
║                         EASYPANEL INSTALLER                         ║
║                        TechSites - v3.2 FIXED                       ║
╚══════════════════════════════════════════════════════════════════════╝
${RESET}"
    
    echo -e "${BLUE}┌─────────────────────────────────────────────────────────────────────┐${RESET}"
    echo -e "${BLUE}│                        OPÇÕES DE INSTALAÇÃO                         │${RESET}"
    echo -e "${BLUE}├─────────────────────────────────────────────────────────────────────┤${RESET}"
    echo -e "${BLUE}│  ${WHITE}1${RESET} - Instalação Automática (Recomendado)                        │"
    echo -e "${BLUE}│  ${WHITE}2${RESET} - Instalação Manual (Passo a passo)                          │"
    echo -e "${BLUE}│  ${WHITE}3${RESET} - Apenas Atualizar Sistema Ubuntu                            │"
    echo -e "${BLUE}│  ${WHITE}4${RESET} - Verificar Status dos Serviços                              │"
    echo -e "${BLUE}├─────────────────────────────────────────────────────────────────────┤${RESET}"
    echo -e "${BLUE}│  ${RED}0${RESET} - Sair                                                       │"
    echo -e "${BLUE}└─────────────────────────────────────────────────────────────────────┘${RESET}"
    echo ""
    echo -ne "${YELLOW}Escolha uma opção: ${RESET}"
}

# Função principal
main() {
    # Verificações iniciais
    check_ubuntu
    
    while true; do
        show_menu
        read -r opcao
        
        case $opcao in
            1)
                install_easypanel_official
                echo ""
                echo -e "${YELLOW}Pressione Enter para continuar...${RESET}"
                read
                ;;
            2)
                install_manual
                echo ""
                echo -e "${YELLOW}Pressione Enter para continuar...${RESET}"
                read
                ;;
            3)
                update_system
                echo ""
                echo -e "${YELLOW}Pressione Enter para continuar...${RESET}"
                read
                ;;
            4)
                check_status
                echo ""
                echo -e "${YELLOW}Pressione Enter para continuar...${RESET}"
                read
                ;;
            0)
                clear
                echo -e "${GREEN}✅ Obrigado por usar o Easypanel Installer!${RESET}"
                echo -e "${CYAN}📧 Criado por TechSites${RESET}"
                exit 0
                ;;
            *)
                clear
                error "❌ Opção inválida! Pressione Enter para continuar..."
                read
                ;;
        esac
    done
}

# Executar função principal
main
