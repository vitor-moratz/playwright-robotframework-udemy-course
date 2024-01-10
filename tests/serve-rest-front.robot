*** Settings ***
Resource              ../resources/serve-rest-front.resource
Suite Setup           Cadastrando um novo usuário
Suite Teardown        Close Browser     ALL


*** Test Cases ***
Login com sucesso Serve Rest Front
    Abrir o navegador
    Ir para o site Serve Rest Front
    Preencher os dados do novo usuário e cadastrar
    Conferir usuário cadastrado com sucesso

Desafio: Conferir se o novo usuário é mostrado na listagem de usuários
    Cadastrando um novo usuário
    Acessando a lista de usuários
    Validando que o usuário aparece na listagem        vitor.morato80@gmail.com

Cadastro e Consulta de Produtos
    Cadastrando um novo usuário
    Cadastrar um novo produto
    Conferir que o produto aparece na listagem

Exemplo utilizando Requisições HTTP
    Abrir o navegador
    Ir para o site Serve Rest Front
    Criar usuário via API
    Logar com o usuário cadastrado via API