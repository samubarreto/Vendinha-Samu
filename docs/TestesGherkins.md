# FRONTEND

##### Funcionalidade: Criar Cliente

Cenário: Usuário insere dados válidos para um novo cliente
> Dado que o usuário acessa a página de criação de cliente
> Quando ele insere "Nome Completo", "CPF válido", "Data de Nascimento" e "Email"
> E clica no botão "Salvar"
> Então o cliente é criado e aparece na lista de clientes
> RESULTADO OBTIDO: RESULTADO ESPERADO

Cenário: Usuário insere dados válidos para um novo cliente
Dado que o usuário acessa a página de criação de cliente
Quando ele insere "Nome Completo", "CPF válido" e "Data de Nascimento"
E clica no botão "Salvar"
Então o cliente é criado e aparece na lista de clientes mesmo sem Email, pois email é nullable

Cenário: Usuário insere um CPF inválido
Dado que o usuário acessa a página de criação de cliente
Quando ele insere "Nome Completo", "CPF inválido", "Data de Nascimento" e "Email"
E clica no botão "Salvar"
Então uma mensagem de erro "CPF inválido" é exibida

Cenário: Usuário insere um Email inválido
Dado que o usuário acessa a página de criação de cliente
Quando ele insere "Nome Completo", "CPF inválido", "Data de Nascimento" e "Email"
E clica no botão "Salvar"
Então uma mensagem de erro "Email inválido" é exibida

Cenário: Usuário insere um Email já utilizado
Dado que o usuário acessa a página de criação de cliente
Quando ele insere "Nome Completo", "CPF inválido", "Data de Nascimento" e "Email"
E clica no botão "Salvar"
Então uma mensagem de erro "Email já utilizado" é exibida

Cenário: Usuário insere um CPF já utilizado
Dado que o usuário acessa a página de criação de cliente
Quando ele insere "Nome Completo", "CPF inválido", "Data de Nascimento" e "Email"
E clica no botão "Salvar"
Então uma mensagem de erro "CPF já utilizado" é exibida

##### Funcionalidade: Editar Cliente

Cenário: Usuário atualiza os dados de um cliente existente com dados válidos
Dado que o usuário acessa a página de edição de um cliente existente
Quando ele insere "Nome Completo atualizado", "CPF válido", "Data de Nascimento" e "Email"
E clica no botão "Salvar"
Então os dados do cliente são atualizados na lista

Cenário: Usuário atualiza os dados de um cliente existente com dados válidos
Dado que o usuário acessa a página de edição de um cliente existente
Quando ele insere "Nome Completo atualizado", "CPF válido" e "Data de Nascimento"
E clica no botão "Salvar"
Então os dados do cliente são atualizados na lista, o email é nullable

Cenário: Usuário tenta atualizar o cliente com um email inválido
Dado que o usuário acessa a página de edição de um cliente existente
Quando ele insere "Nome Completo", "CPF válido", "Data de Nascimento" e "Email inválido"
E clica no botão "Salvar"
Então uma mensagem de erro "Email inválido" é exibida

Cenário: Usuário tenta atualizar o cliente com um CPF inválido
Dado que o usuário acessa a página de edição de um cliente existente
Quando ele insere "Nome Completo", "CPF inválido", "Data de Nascimento" e "Email válido"
E clica no botão "Salvar"
Então uma mensagem de erro "CPF inválido" é exibida

Cenário: Usuário tenta atualizar o cliente com um CPF já utilizado
Dado que o usuário acessa a página de edição de um cliente existente
Quando ele insere "Nome Completo", "CPF já usado", "Data de Nascimento" e "Email válido"
E clica no botão "Salvar"
Então uma mensagem de erro "CPF já utilizado" é exibida

Cenário: Usuário tenta atualizar o cliente com um Email já utilizado
Dado que o usuário acessa a página de edição de um cliente existente
Quando ele insere "Nome Completo", "CPF", "Data de Nascimento" e "Email usado"
E clica no botão "Salvar"
Então uma mensagem de erro "Email já utilizado" é exibida

##### Funcionalidade: Excluir Cliente

Cenário: Usuário exclui um cliente da lista
Dado que o usuário acessa a lista de clientes
Quando ele seleciona um cliente e clica no botão "Excluir"
E confirma a exclusão
Então o cliente é removido da lista

##### Funcionalidade: Listar Clientes

Cenário: Usuário acessa a lista de clientes
Dado que o usuário acessa a página de listagem de clientes
Então a lista de clientes é exibida ordenada pelo maior valor de dívida TOTAL ao menor

Cenário: Existem mais de 10 clientes cadastrados
Dado que o usuário acessa a página de listagem de clientes
E existem mais de 10 clientes cadastrados
Então apenas 10 clientes são exibidos por página do grid, ordenados pelo maior valor de dívida TOTAL ao menor

##### Funcionalidade: Buscar Cliente

Cenário: Usuário busca um cliente pelo nome, cpf ou email
Dado que o usuário acessa a página de listagem de clientes
Quando ele insere o nome, cpf ou email do cliente na barra de busca
Então a lista de clientes é filtrada com os nomes, cpfs ou emails correspondentes

##### Funcionalidade: Campo Obrigatório

Cenário: Usuário tenta criar ou editar um cliente sem preencher todos os campos obrigatórios (nome, cpf, data de nascimento)
Dado que o usuário está na página de criação ou edição de cliente
Quando ele deixa um ou mais campos obrigatórios em branco
E clica no botão "Salvar"
Então uma mensagem de erro é exibida indicando quais campos faltam ser preenchidos

##### Funcionalidade: Formatação de CPF

Cenário: Usuário insere um CPF inválido
Dado que o usuário está na página de criação ou edição de cliente
Quando ele insere um CPF com dígitos inválidos
E clica no botão "Salvar"
Então uma mensagem de erro "CPF inválido" é exibida

##### Funcionalidade: Listar Dívidas por Cliente

Cenário: Usuário visualiza a lista de dívidas de um cliente específico
Dado que o usuário acessa a lista de clientes
Quando ele seleciona um cliente do grid de clientes
Então um novo grid com as dívidas do cliente selecionado é exibido
E um botão para voltar para o grid principal é exibido

##### Funcionalidade: Dar Baixa em Pagamento de Dívidas

Cenário: Usuário marca uma dívida como paga
Dado que o usuário acessa a lista de dívidas de um cliente
Quando ele seleciona uma dívida
E marca como paga
Então a situação da dívida é atualizada para "Pago"
E o registro da dívida vai para o fim da listagem de dívidas

##### Funcionalidade: Validar Limite de Dívidas

Cenário: Usuário tenta adicionar uma dívida que excede o limite de 200 reais
Dado que o usuário está na página de criação de dívida
Quando ele insere um valor total de dívidas maior que 200 reais
E clica no botão "Salvar"
Então uma mensagem de erro "Limite de dívida excedido" é exibida

# BACKEND API

##### Funcionalidade: Criação de Cliente

Cenário: Criação de um cliente com dados válidos
Dado que o sistema recebe um POST no endpoint "/clientes" com JSON contendo "Nome Completo", "CPF", "Data de Nascimento" e "Email"
Quando o JSON é válido
Então o sistema retorna status 200 Ok
E o cliente é salvo no banco de dados

Cenário: Tentativa de criação de um cliente com CPF inválido
Dado que o sistema recebe um POST no endpoint "/clientes" com JSON contendo um "CPF inválido"
Quando o JSON é processado
Então o sistema retorna status 402 Unprocessable Entity
E uma mensagem de erro "CPF inválido" é exibida

##### Funcionalidade: Listagem de Clientes

Cenário: Listagem de todos os clientes
Dado que o sistema recebe um GET no endpoint "/clientes"
Quando a requisição é processada
Então o sistema retorna status 200 OK
E uma lista de clientes em ordem decrescente de valor da dívida

##### Funcionalidade: Atualização de Cliente

Cenário: Atualização dos dados de um cliente existente
Dado que o sistema recebe um PUT no endpoint "/clientes/{id}" com JSON contendo dados atualizados
Quando o JSON é válido
Então o sistema retorna status 200 OK
E os dados do cliente são atualizados

##### Funcionalidade: Exclusão de Cliente

Cenário: Exclusão de um cliente
Dado que o sistema recebe um DELETE no endpoint "/clientes/{id}"
Quando a requisição é processada
Então o sistema retorna status 200 OK
E o cliente é removido do banco de dados

##### Funcionalidade: Criação de Dívida

Cenário: Criação de uma dívida com dados válidos
Dado que o sistema recebe um POST no endpoint "/dividas" com JSON contendo "Valor", "Descrição", "DataCriação"
Quando o JSON é válido
Então o sistema retorna status 201 Created
E a dívida é salva no banco de dados

Cenário: Tentativa de criação de uma dívida com valor total superior a 200 reais
Dado que o sistema recebe um POST no endpoint "/dividas" com JSON contendo um valor que excede o limite
Quando o JSON é processado
Então o sistema retorna status 400 Bad Request
E uma mensagem de erro "Limite de dívida excedido" é exibida

##### Funcionalidade: Marcar Dívida como Paga

Cenário: Marcar uma dívida como paga
Dado que o sistema recebe um PUT no endpoint "/dividas/{id}" com JSON contendo o status "Pago"
Quando o JSON é válido
Então o sistema retorna status 200 OK
E a situação da dívida é atualizada para "Pago"

##### Funcionalidade: Listagem de Dívidas por Cliente

Cenário: Listagem de todas as dívidas de um cliente
Dado que o sistema recebe um GET no endpoint "/dividas/cliente/{idCliente}"
Quando a requisição é processada
Então o sistema retorna status 200 OK
E uma lista de dívidas do cliente é exibida

# BANCO DE DADOS

##### Funcionalidade: Persistência de Dados

Cenário: Verificar se os dados de cliente e dívidas são persistidos corretamente
Dado que dados de clientes e dívidas são inseridos através da API
Quando os dados são verificados no banco de dados
Então eles devem estar corretamente inseridos nas tabelas correspondentes

##### Funcionalidade: Validação de Integridade

Cenário: Verificar se as restrições de integridade estão funcionando
Dado que o sistema recebe uma tentativa de inserir dois clientes com o mesmo CPF
Quando a segunda inserção é processada
Então o sistema deve retornar um erro de violação de integridade

##### Funcionalidade: Fluxo Completo de Criação e Listagem

Cenário: Criar um cliente e adicionar dívidas, depois listar clientes e dívidas
Dado que um cliente é criado e dívidas são adicionadas a ele
Quando o usuário lista os clientes e dívidas
Então os dados devem estar consistentes entre frontend, API e banco de dados

##### Funcionalidade: Atualização e Consistência

Cenário: Atualizar dados de um cliente e verificar se a atualização reflete em todas as camadas
Dado que os dados de um cliente são atualizados
Quando os dados são verificados no frontend, API e banco de dados
Então os dados devem estar corretamente atualizados em todas as camadas