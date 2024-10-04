# nw-test-api-edsoncarlos
Test interview - New Way
![Texto Alternativo](https://drive.google.com/open?id=1l0kJsntsp7uIqdxoq-RSJF0lkBeSSuGG&usp=drive_copy)

Este repositório contém uma API simples construída em Python, que é provisionada automaticamente usando Terraform e AWS ECS (Fargate), com pipelines configurados para CI/CD através do GitHub Actions.

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

A infraestrutura provisionada pode ser destruída automaticamente ao realizar um push em uma branch específica (definida como cleanup no workflow). Isso garante que os recursos da AWS sejam removidos corretamente, evitando custos desnecessários.

## Como Usar Este Repositório

### Pré-requisitos

	1.	AWS Account com permissões para criar recursos no ECS, VPC, ALB, etc.
	2.	Terraform instalado.
	3.	Docker instalado e configurado para build e push de imagens.
	4.	Conta no Docker Hub.
	5.	GitHub Actions configurado com Secrets para as credenciais AWS e Docker Hub.

Passos para Subir a Aplicação

	1.	Clone o Repositório
 ```
git clone https://github.com/edsoncarlosdevops/nw-test-api-edsoncarlos.git
cd nw-test-api-edsoncarlos
```

	2.	Configure os Segredos no GitHub Actions
Certifique-se de adicionar os seguintes secrets no GitHub Actions:
	•	**AWS_ACCESS_KEY_ID:** Chave de acesso para sua conta AWS.
	•	**AWS_SECRET_ACCESS_KEY:** Chave secreta da AWS.
	•	**DOCKERHUB_USERNAME:** Seu nome de usuário do Docker Hub.
	•	**DOCKERHUB_TOKEN:** Seu token de autenticação do Docker Hub.
	3.	**Executar o CI/CD**
	•	Faça um push ou pull request na branch master e o GitHub Actions iniciará o workflow de deploy.
	•	Após o build, a API será acessível no DNS gerado pelo ALB na AWS.
	4.	**Testar a API**
Acesse a URL da API gerada pelo Application Load Balancer na AWS.
 ```
curl http://<alb-dns>/  # Substitua pelo DNS do ALB
```
5.	Destruir a Infraestrutura
	•	Faça um push na branch cleanup para destruir toda a infraestrutura criada com Terraform.

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

Comandos Terraform

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



