# Gerenciamento de Usuários Azure

Uma abordagem modularizada usando Terraform para Azure

## Visão Geral

Este projeto automatiza o gerenciamento de múltiplos usuários e o provisionamento de recursos necessários no Azure usando Terraform.

### Funcionalidades Principais

#### 1. Gerenciamento de Usuários e Grupos
- Criação automática de usuários no Azure AD
- Configuração de grupo de segurança para treinamento
- Atribuição de funções do Azure AD (se suportado pela licença do tenant)

#### 2. Provisionamento de Recursos por Usuário
Cada usuário recebe:
- **Resource Groups**: Um ou mais grupos de recursos com funções associadas
- **Storage Account**: Conta de armazenamento com File Share para CloudShell
- **Funções RBAC**: Contributor e User Access Administrator no Resource Group

#### 3. Infraestrutura de Bastion (Opcional)
Um bastion host e VM (Linux ou Windows) são provisionados quando:
- `bastion_host_support` = `true` em locals
- Atributo `bastion` = `true` no mapa resource_groups
- `bastion_host_type` = `"lin"` (Linux) ou `"win"` (Windows)

**Componentes do Bastion:**
- Virtual Network com subnets (AzureBastionSubnet e utility)
- Network Security Group com regras de firewall
- Public IPs para bastion e acesso a serviços
- VM Linux (Ubuntu 18.04) ou Windows (Windows 10 Pro)

> 📋 Revise `locals_user_environment_setup.tf` para configurações detalhadas

#### 4. Service Principals por Usuário (Opcional)
Um Service Principal por usuário é criado quando:
- `per_user_service_principal` = `true`
- **Obrigatório** para suporte a Bastion Shareable Links
- Os links compartilháveis são criados usando o Service Principal de cada usuário

**Configuração de Função:**
```hcl
per_user_service_principal_role = "Owner"  # ou outra função
```

## Configuração e Uso

### Pré-requisitos
1. Terraform >= 1.0.0
2. Azure CLI configurado
3. Permissões adequadas no Azure AD e Subscription

### Clonagem do Repositório
⚠️ **Importante**: Sempre use a flag `--recurse-submodules`:
```bash
git clone --recurse-submodules <repository-url>
git pull --recurse-submodules
```

### Configuração Inicial
1. Copie `terraform.tfvars_example` para `terraform.tfvars`
2. Configure as variáveis necessárias:
   - `user_principal_name_ext`: Domínio do tenant
   - `training_group_owners`: Proprietários do grupo
   - `user_password`: Senha padrão dos usuários
   - `user_prefix`: Prefixo dos nomes de usuário
   - `user_count` e `user_start`: Quantidade e numeração inicial

### Estrutura de Arquivos Importantes
- `locals_user_environment_setup.tf`: Configurações principais
- `terraform.tfvars`: Variáveis de ambiente
- `scripts/`: Scripts auxiliares para bastion links
- Módulos `module_*`: Recursos Azure organizados por tipo

### Outputs Gerados
- Arquivo CSV com credenciais dos usuários
- Scripts para criação de Bastion Shareable Links
- Informações de recursos provisionados
