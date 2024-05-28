### 1. Casos de Teste para a Interface Web (Frontend)

#### CRUD de Cliente

1. **Criar Cliente**

   * **Cenário:** O usuário insere dados válidos para um novo cliente.
     * **Entrada:** Nome Completo, CPF válido, Data de Nascimento, Email.
     * **Resultado Esperado:** Cliente é criado e aparece na lista de clientes.
       * **RESULTADO OBTIDO:**
   * **Cenário:** O usuário insere um CPF inválido.
     * **Entrada:** Nome Completo, CPF inválido, Data de Nascimento, Email.
     * **Resultado Esperado:** Mensagem de erro "CPF inválido" é exibida.
       * **RESULTADO OBTIDO:**
2. **Editar Cliente**

   * **Cenário:** O usuário atualiza os dados de um cliente existente com dados válidos.

     * **Entrada:** Nome Completo atualizado, CPF válido, Data de Nascimento, Email.
     * **Resultado Esperado:** Dados do cliente são atualizados na lista.
       * **RESULTADO OBTIDO:**
   * **Cenário:** O usuário tenta atualizar o cliente com um email inválido.

     * **Entrada:** Nome Completo, CPF válido, Data de Nascimento, Email inválido.
     * **Resultado Esperado:** Mensagem de erro "Email inválido" é exibida.
       * **RESULTADO OBTIDO:**
   * **Cenário:** O usuário tenta atualizar o cliente com um CPF inválido.

     * **Entrada:** Nome Completo, CPF inválido, Data de Nascimento, Email válido.
     * **Resultado Esperado:** Mensagem de erro "CPF inválido" é exibida.

       * **RESULTADO OBTIDO:**
3. **Excluir Cliente**

   * **Cenário:** O usuário exclui um cliente da lista.
     * **Entrada:** Selecionar cliente e confirmar exclusão.
     * **Resultado Esperado:** Cliente é removido da lista.
       * **RESULTADO OBTIDO:**
4. **Listar Clientes**

   * **Cenário:** O usuário acessa a lista de clientes.
     * **Entrada:** Acesso à página de listagem de clientes.
     * **Resultado Esperado:** Lista de clientes ordenada pelo maior valor de dívida ao menor.
       * **RESULTADO OBTIDO:**
   * **Cenário:** O usuário acessa a lista de clientes
     * **Entrada:** Existem >10 clientes cadastrados
     * **Resultado Esperado:** Devem ser exibidos apenas 10 clientes por página do grid
       * **RESULTADO OBTIDO:**
5. **Buscar Cliente**

   * **Cenário:** O usuário busca um cliente pelo nome.
     * **Entrada:** Nome do cliente.
     * **Resultado Esperado:** Lista filtrada de clientes com o nome correspondente.
       * **RESULTADO OBTIDO:**

#### Validações

1. **Campo Obrigatório**
   * **Cenário:** O usuário tenta criar ou editar um cliente sem preencher todos os campos (todos os campos são obrigatórios aparentemente).
     * **Entrada:** Campos em branco.
     * **Resultado Esperado:** Mensagem de erro indicando quais campos faltam ser preenchidos.
       * **RESULTADO OBTIDO:**
2. **Formatação de CPF**
   * **Cenário:** O usuário insere um CPF inválido.
     * **Entrada:** CPF com formatação correta, mas com dígitos inválidos.
     * **Resultado Esperado:** Mensagem de erro "CPF inválido".
       * **RESULTADO OBTIDO:**
   * **Cenário:** O usuário insere um CPF válido, mas com a formatação parcialmente incorreta
     * **Entrada:** CPF sem máscara/com máscara/com máscara parcial/com espaços no começo/fim do texto...
     * **Resultado Esperado:** Cliente cadastrado, o sistema deve corrigir erros de formatação do CPF. Barrar apenas cpfs inválidos.
       * **RESULTADO OBTIDO:**

#### Dívidas

1. **Listar Dívidas por Cliente**
   * **Cenário:** O usuário visualiza a lista de dívidas de um cliente específico.
     * **Entrada:** Selecionar um cliente do grid de clientes.
     * **Resultado Esperado:** Novo grid apenas de dívidas do cliente selecionado, com um botão para voltar para o grid principal.
       * **RESULTADO OBTIDO:**
2. **Dar Baixa em Pagamento de Dívidas**
   * **Cenário:** O usuário marca uma dívida como paga.
     * **Entrada:** Selecionar dívida, selecionar (FORMA DE PGTO) e marcar como paga.
     * **Resultado Esperado:** Situação da dívida é atualizada para "Pago", a forma de pagamento ficará numa coluna ao lado e o registro da dívida irá para o fim da listagem de dívidas.
       * **RESULTADO OBTIDO:**
3. **Validar Limite de Dívidas**
   * **Cenário:** O usuário tenta adicionar uma dívida que excede o limite de 200 reais.
     * **Entrada:** Valor total das dívidas maior que 200 reais.
     * **Resultado Esperado:** Mensagem de erro "Limite de dívida excedido".
       * **RESULTADO OBTIDO:**

### 2. Casos de Teste para a API REST (Backend)

#### Endpoints de Cliente

1. **POST /clientes**
   * **Cenário:** Criação de um cliente com dados válidos.
     * **Entrada:** JSON com Nome Completo, CPF, Data de Nascimento, Email.
     * **Resultado Esperado:** Status 200 Created, cliente é salvo no banco de dados.
       * **RESULTADO OBTIDO:**
   * **Cenário:** Tentativa de criação de um cliente com CPF inválido.
     * **Entrada:** JSON com CPF inválido.
     * **Resultado Esperado:** Status 400 Bad Request, mensagem de erro "CPF inválido".
       * **RESULTADO OBTIDO:**
2. **GET /clientes**
   * **Cenário:** Listagem de todos os clientes.
     * **Entrada:** Nenhuma.
     * **Resultado Esperado:** Status 200 OK, lista de clientes em ordem decrescente de valor da dívida.
       * **RESULTADO OBTIDO:**
3. **PUT /clientes/{id}**
   * **Cenário:** Atualização dos dados de um cliente existente.
     * **Entrada:** JSON com dados atualizados.
     * **Resultado Esperado:** Status 200 OK, dados do cliente atualizados.
       * **RESULTADO OBTIDO:**
4. **DELETE /clientes/{id}**
   * **Cenário:** Exclusão de um cliente.
     * **Entrada:** ID do cliente.
     * **Resultado Esperado:** Status 200 OK, cliente removido do banco de dados.
       * **RESULTADO OBTIDO:**
5. Qualquer outro caso além dos de sucesso acima devem retornar 400 bad request ou 404 not found.

#### Endpoints de Dívidas

1. **POST /dividas**
   * **Cenário:** Criação de uma dívida com dados válidos.
     * **Entrada:** JSON com Valor, Descrição, DataCriação.
     * **Resultado Esperado:** Status 201 Created, dívida salva no banco de dados.
       * **RESULTADO OBTIDO:**
   * **Cenário:** Tentativa de criação de uma dívida com valor total superior a 200 reais.
     * **Entrada:** JSON com valor que excede o limite.
     * **Resultado Esperado:** Status 400 Bad Request, mensagem de erro "Limite de dívida excedido".
       * **RESULTADO OBTIDO:**
2. **PUT /dividas/{id}**
   * **Cenário:** Marcar uma dívida como paga.
     * **Entrada:** ID da dívida.
     * **Resultado Esperado:** Status 200 OK, situação da dívida atualizada para "Pago".
       * **RESULTADO OBTIDO:**
3. **GET /dividas/cliente/{idCliente}**
   * **Cenário:** Listagem de todas as dívidas de um cliente.
     * **Entrada:** ID do cliente.
     * **Resultado Esperado:** Status 200 OK, lista de dívidas do cliente.
       * **RESULTADO OBTIDO:**

### 3. Casos de Teste para o Banco de Dados

1. **Persistência de Dados**
   * **Cenário:** Verificar se os dados de cliente e dívidas são persistidos corretamente.
     * **Ação:** Inserir dados através da API e verificar no banco de dados.
     * **Resultado Esperado:** Dados inseridos corretamente nas tabelas correspondentes.
       * **RESULTADO OBTIDO:**
2. **Validação de Integridade**
   * **Cenário:** Verificar se as restrições de integridade estão funcionando (ex: CPF único).
     * **Ação:** Tentar inserir dois clientes com o mesmo CPF.
     * **Resultado Esperado:** Erro de violação de integridade.
       * **RESULTADO OBTIDO:**

### 4. Casos de Teste de Integração

1. **Fluxo Completo de Criação e Listagem**
   * **Cenário:** Criar um cliente e adicionar dívidas, depois listar clientes e dívidas.
     * **Ação:** Passar por todos os passos do CRUD e listagem.
     * **Resultado Esperado:** Dados consistentes entre frontend, API e banco de dados.
       * **RESULTADO OBTIDO:**
2. **Atualização e Consistência**
   * **Cenário:** Atualizar dados de um cliente e verificar se a atualização reflete em todas as camadas.
     * **Ação:** Atualizar dados de um cliente e verificar no frontend, API e banco de dados.
     * **Resultado Esperado:** Dados atualizados corretamente em todas as camadas.
       * **RESULTADO OBTIDO:**
