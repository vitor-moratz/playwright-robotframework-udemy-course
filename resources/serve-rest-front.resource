*** Settings ***
Library                      Browser
Library                      FakerLibrary
Library    DateTime

*** Variables ***
${BROWSER}                   chromium
${HEADLESS}                  ${false}
${SITE_SERVE_REST}           https://front.serverest.dev/

*** Keywords ***
Abrir o navegador
    New Browser              browser=${BROWSER}
    ...                      headless=${HEADLESS}
    
    ${TRACE_NAME}            FakerLibrary.Uuid 4
    ${NOW}                   Get Current Date    result_format=%d-%m-%Y_%H%M%S
    New Context              viewport={'width': 1200, 'height': 800}
    ...                      tracing=${OUTPUT_DIR}/evidencias/traces/${NOW}/${TRACE_NAME}.zip
    ...                      recordVideo=${'dir':'${OUTPUT_DIR}/evidencias/videos/${NOW}'}

Ir para o site Serve Rest Front
    New Page                 url=${SITE_SERVE_REST}
    ${title}       Get Title  ==  Front - ServeRest
    Log  ${title}

Preencher os dados do novo usuário e cadastrar
    # Record Selector
    # Click                 css=.btn-link
    # Click                 text="Cadastre-se"
    Click                   css=a[data-testid='cadastrar']
    ${EMAIL}                FakerLibrary.Email
    Fill Text               css=input[data-testid='nome']       Vitor Morato
    Fill Text               css=input[data-testid='email']      ${EMAIL}
    Fill Text               css=input[data-testid='password']   moratz
    Check Checkbox          css=input[data-testid='checkbox']
    # Click                 css=button[data-testid='cadastrar']
    Click                   xpath=//*[@id="root"]//button >> text="Cadastrar"

Conferir usuário cadastrado com sucesso
    Wait For Elements State    h1   visible
    Get Text                h1  ==  Bem Vindo Vitor Morato
    Get Element States      css=button[data-testid='logout']  validate  value & visible

Cadastrando um novo usuário
    # Aqui estarei utilizando as keywords criada acima
    Abrir o navegador
    Ir para o site Serve Rest Front
    Preencher os dados do novo usuário e cadastrar
    Conferir usuário cadastrado com sucesso

Acessando a lista de usuários
    # Realizando clica para abrir listagem de usuários
    Click        css=a[data-testid='listarUsuarios']

Validando que o usuário aparece na listagem
    # Definindo o variável que validará o e-mail na listagem
    [Arguments]                ${EMAIL}
    ${elemento}      Get Table Cell Element    css=table    "Nome"    "${EMAIL}"
    ${usuario_nome}  Get Text  ${elemento}  ==  Vitor Morato
    Highlight Elements         ${elemento}
    Take Screenshot    

Cadastrar um novo produto
  Click              css=a[data-testid='cadastrarProdutos']
  ${NOME_PRODUTO}    FakerLibrary.Word
  Set Test Variable  ${NOME_PRODUTO}
  Fill Text          css=input[data-testid='nome']          ${NOME_PRODUTO}
  Fill Text          css=input[data-testid='preco']         10
  Fill Text          css=textarea[data-testid='descricao']  Produto Teste Robot Framework
  Fill Text          css=input[data-testid='quantity']      5
  Click              text="Cadastrar"

Conferir que o produto aparece na listagem
  ${elemento}   Get Table Cell Element    css=table    "Descrição"    "${NOME_PRODUTO}"
  ${descricao}  Get Text  ${elemento}  ==  Produto Teste Robot Framework
  Highlight Elements    ${elemento}
  Take Screenshot       fullPage=${true}

Criar usuário via API
    ${EMAIL}  FakerLibrary.Email
    Set Test Variable    ${EMAIL}

    ${resposta}  Http    url=https://serverest.dev/usuarios
    ...                  method=POST
    ...                  body={"nome": "Mayara Fernandes","email": "${EMAIL}","password": "123456","administrador": "true"}   

    Should Be Equal As Integers    ${resposta["status"]}    201

Logar com o usuário cadastrado via API
    ${resposta}  Http    url=https://serverest.dev/login
    ...                  method=POST
    ...                  body={"email": "${EMAIL}","password": "123456"}
    
    Should Be Equal As Integers    ${resposta["status"]}    200

    LocalStorage Set Item    serverest/userEmail    ${EMAIL}
    LocalStorage Set Item    serverest/userToken    ${resposta["body"]["authorization"]}
    LocalStorage Set Item    serverest/userNome     Mayara Fernandes

    Go To    url=https://front.serverest.dev/admin/home

    Take Screenshot