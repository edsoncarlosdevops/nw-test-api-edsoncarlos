# nw-test-api-edsoncarlos
Test interview - New Way

Este repositório contém uma API simples construída em Python, que é provisionada automaticamente usando Terraform e AWS ECS (Fargate), com pipelines configurados para CI/CD através do GitHub Actions.
![nw-api-test-edsoncarlos drawio](https://github.com/user-attachments/assets/34ccd5a4-d78b-46f4-b2f5-a5db252cda5c)


## Arquitetura
A aplicação é provisionada utilizando os seguintes serviços da AWS:

	•	ECS (Elastic Container Service) rodando em Fargate para o gerenciamento de containers.
	•	ALB (Application Load Balancer) para distribuir o tráfego para as tarefas da ECS.
	•	VPC, Subnets, SG para o isolamento e seguranca da rede.
 	•	Bucket S3 para salvar o arquivo de estado do terraform.


## Componentes do Projeto

	1.	App.py: O código da API escrita em Python.
	2.	Dockerfile: Arquivo de configuração que define a imagem Docker usada para rodar a aplicação.
	3.	Terraform: Utilizado para provisionar a infraestrutura na AWS.
	4.	GitHub Actions: Automação de CI/CD para fazer o deploy e destruição da infraestrutura.
	5.	Requirements.txt: Dependências do projeto Python que são instaladas no container Docker.


## Como Funciona

Este repositório possui dois fluxos automatizados:

1. Deploy da API com Docker e Terraform

Toda vez que uma mudança é feita na branch master, o workflow do GitHub Actions é acionado para:

	•	Fazer o build da nova imagem Docker.
	•	Publicar essa imagem no Docker Hub.
	•	Atualizar a infraestrutura na AWS utilizando Terraform, criando ou modificando os recursos necessários na ECS, ALB, etc.

2. Destruir a Infraestrutura

A infraestrutura provisionada pode ser destruída automaticamente ao realizar um push em uma branch específica (definida como **delete** no workflow). Isso garante que os recursos da AWS sejam removidos corretamente, evitando custos desnecessários.

3. Backend

Para salvar os arquivos de estado do backend **terraform.tfstate** e necessario que ja exista um bucket e descreva ele no ditetorio intra/backend, definindo tambem o diretorio onde sera versionado:

 ```
terraform {
  backend "s3" {
    bucket  = "nw-test-edsoncarlos-terraform-state"  # Nesse caso, vc pode criar e adicionar o bucket aqui
    region  = "us-east-1"
    key     = "ecs-fargate/terraform.tfstate"  # Diretorio onde o arquivo de estado sera guardado e versionado dentro do bucket
    encrypt = true
  }
  required_version = ">=0.13.0"
  required_providers {
    aws = {
      version = ">= 2.7.0"
      source  = "hashicorp/aws"
    }
  }
}

```
 

## Como Usar Este Repositório

### Pré-requisitos

	1.	AWS Account com permissões para criar recursos no ECS, VPC, ALB, etc.
	2.	Terraform instalado.
	3.	Docker instalado e configurado para build e push de imagens.
	4.	Conta no Docker Hub.
	5.	GitHub Actions configurado com Secrets para as credenciais AWS e Docker Hub.

## Passos para Subir a Aplicação

**Clone o Repositório**
 ```
git clone https://github.com/edsoncarlosdevops/nw-test-api-edsoncarlos.git
cd nw-test-api-edsoncarlos
```

**Configure os Segredos no GitHub Actions**

Certifique-se de adicionar os seguintes secrets no GitHub Actions:

```
AWS_ACCESS_KEY_ID: Chave de acesso para sua conta AWS.
AWS_SECRET_ACCESS_KEY: Chave secreta da AWS.
DOCKERHUB_USERNAME: Seu nome de usuário do Docker Hub.
DOCKERHUB_TOKEN: Seu token de autenticação do Docker Hub.
```

**Executar o CI/CD**
Faça um push ou pull request na branch master e o GitHub Actions iniciará o workflow de deploy.
Após o build, a API será acessível no DNS gerado pelo ALB na AWS.

 
**Testar a API**

Acesse a URL da API gerada pelo Application Load Balancer na AWS.
 ```
curl http://<alb-dns>/  # Substitua pelo DNS do ALB
```
**Destruir a Infraestrutura**
Faça um push na branch cleanup para destruir toda a infraestrutura criada com Terraform.

 ```
curl http://localhost:5000
```


**Como Fazer o Build da Imagem**

Você pode construir e testar a imagem Docker localmente:
 ```
docker build -t <seu-usuario>/nw-test-api .
docker run -d -p 5000:5000 <seu-usuario>/nw-test-api
```

Verifique se a API está rodando:
 ```
curl http://localhost:5000
```

**Comandos Terraform**

Para provisionar manualmente:
 ```
cd infra
terraform init
terraform apply -auto-approve
```

Para destruir a infraestrutura:
 ```
cd infra
terraform destroy -auto-approve
```


**O que poderia ser implementado para refatorar e melhorar a entrega do codigo e seguranca**

Uma melhoria significativa que poderia ser implementada no projeto seria a adoção de uma imagem Distroless para o Docker. Isso reduziria a quantidade de camadas desnecessárias e aumentaria a segurança da aplicação, já que imagens distroless contêm apenas as dependências essenciais para a execução da aplicação, diminuindo a superfície de ataque.

Além disso, seria interessante adicionar uma etapa no pipeline de CI/CD para analisar a imagem Docker usando o Trivy. O Trivy é uma ferramenta que faz a varredura em busca de vulnerabilidades nos pacotes e bibliotecas usados na imagem, garantindo que a aplicação atenda a padrões de segurança antes de ser implantada.

Outro ponto a ser considerado é a migração da execução do ECS para subnets privadas, aumentando a segurança, já que a aplicação ficaria isolada da internet pública, acessível apenas por meio de um Load Balancer ou Gateway NAT.

Por fim, ao invés de utilizar o Docker Hub, uma melhoria seria fazer o push da imagem Docker para o ECR (Elastic Container Registry) da AWS. Isso integraria de maneira mais eficiente com o ECS e proporcionaria um controle mais granular de permissões e gerenciamento das imagens, além de melhorar a integração e segurança geral do processo de deploy.


