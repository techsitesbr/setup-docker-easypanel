#!/bin/bash
# Script para instalar Docker, Docker Compose e Easypanel automaticamente em uma VPS com Ubuntu

# Verifica se o script está sendo executado como root
if [ "$EUID" -ne 0 ]; then
  echo "Erro: Execute este script como root ou com sudo."
  exit 1
fi

# Função para exibir mensagens
log() {
  echo "[INFO] $1"
}

# Função para verificar erros
check_error() {
  if [ $? -ne 0 ]; then
    echo "[ERRO] $1"
    exit 1
  fi
}

# Atualiza o sistema
log "Atualizando o sistema..."
apt update && apt upgrade -y
check_error "Falha ao atualizar o sistema."

# Instala o Docker
log "Instalando o Docker..."
apt install -y docker.io
check_error "Falha ao instalar o Docker."
systemctl start docker
systemctl enable docker
log "Docker instalado: $(docker --version)"

# Instala o Docker Compose
log "Instalando o Docker Compose..."
curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
check_error "Falha ao baixar o Docker Compose."
chmod +x /usr/local/bin/docker-compose
log "Docker Compose instalado: $(docker-compose --version)"

# Instala o Easypanel
log "Instalando o Easypanel..."
docker run --rm -v /etc/easypanel:/etc/easypanel -v /var/run/docker.sock:/var/run/docker.sock:ro easypanel/easypanel setup
check_error "Falha ao instalar o Easypanel."

# Verifica se o Easypanel foi instalado
if [ -d "/etc/easypanel" ]; then
  log "Easypanel instalado com sucesso!"
  log "Acesse o painel em: http://$(curl -s ifconfig.me):80"
  log "Siga as instruções no painel para configurar e-mail e senha."
else
  echo "[ERRO] Falha na instalação do Easypanel."
  exit 1
fi

# Configura o firewall (se ufw estiver ativo)
if command -v ufw &> /dev/null; then
  log "Configurando firewall (portas 80 e 443)..."
  ufw allow 80
  ufw allow 443
fi

log "Instalação concluída! Acesse o Easypanel no navegador."
log "Agradecimentos a [SEU_NOME] pela criação deste projeto."
