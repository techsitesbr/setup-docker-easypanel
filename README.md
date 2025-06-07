Instalação Automática de Docker Compose e Easypanel
Este repositório contém um script para instalar o Docker, Docker Compose e Easypanel automaticamente em uma VPS com Ubuntu.
Como Executar o Instalador
Para instalar as ferramentas de forma simples, execute o seguinte comando na terminal da sua VPS:
bash <(curl -sSL https://raw.githubusercontent.com/techsitesbr/setup-docker-easypanel/main/install_docker_easypanel.sh)

Depois, aguarde alguns instantes enquanto o script atualiza o sistema, instala as ferramentas e configura o Easypanel. Ao final, o endereço para acessar o painel (ex.: http://<IP_DA_VPS>:80) será exibido.
Pré-requisitos

VPS com Ubuntu 22.04 ou superior.
Acesso SSH com privilégios de root ou sudo.
Conexão à internet.

O que o Script Faz?

Atualiza o sistema.
Instala o Docker e o Docker Compose.
Configura o Easypanel automaticamente.
Abre as portas 80 e 443 no firewall (se ufw estiver ativo).
Exibe o endereço para acessar o painel do Easypanel.

Notas

Para usar um domínio com SSL, configure um registro DNS tipo A apontando para o IP da VPS e ajuste no painel do Easypanel.
Mantenha o sistema atualizado para maior segurança.

Solução de Problemas

Se o Easypanel não for acessível, verifique o status do Docker:sudo systemctl status docker


Confirme que as portas 80 e 443 estão abertas:sudo ufw status



Agradecimentos
Agradecimentos a Gabriel Bezerra pela criação deste projeto.
Referências

Easypanel Documentation
Docker Compose Installation
