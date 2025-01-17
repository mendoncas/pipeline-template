# Pipeline básica para um serviço em Go

Para o funcionamento, é necessário configurar os seguintes segredos no repositório:
* AWS_ACCESS_KEY_ID e AWS_SECRET_ACCESS_KEY com as credenciais para um usuário AMI da AWS
* DOCKERHUB_USER e DOCKERHUB_PASS com nome de usuário e um token de acesso para o docker hub
* EC2_PRIVATE_KEY e EC2_PUBLIC_KEY com as chaves RSA públicas e privadas a serem instaladas nas instâncias

Além dos segredos, as seguintes variáveis:
* BUCKET_NAME com o nome de um bucket s3 da AWS
* AWS_REGION com a região em que os recursos da AWS serão alocados

# Workflows
## CI
Esteira que constrói a Docker e realiza o pull nas instâncias utilizando Ansible. É engatilhada com todo commit.

## Create resources
Ação manual para criar as instâncias ec2. Os endereços públicos das instâncias podem ser consultados na pipeline, na etapa "print inventory".
O arquivo inventory gerado é salvo num bucket ec2 para ser utilizado posteriormente.

## Destroy resources
Ação manual para destruir as instâncias ec2. Utiliza o inventory gerado na ação de criar.

