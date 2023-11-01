# createEditBox - Função de Caixa de Edição Personalizada em Lua

A função `createEditBox` é uma ferramenta poderosa para criar caixas de edição personalizadas em Lua, com funcionalidades de inserção de texto, seleção, desenho na tela e manipulação de eventos. Essa função é especialmente útil para criar interfaces de usuário interativas em jogos ou aplicativos.

## Como Usar

Para criar uma caixa de edição personalizada, siga estas etapas:

1. Inclua a função `createEditBox` em seu projeto Lua.

2. Chame a função `createEditBox` e forneça os parâmetros necessários:

```lua
local editBox = createEditBox(x, y, width, height, text, maxLength, font, colors, fieldType)
```


- Personalize os parâmetros de acordo com suas necessidades:
  - `x` e `y`: Defina as coordenadas (x, y) da caixa de edição.
  - `width` e `height`: Especifique a largura e altura da caixa de edição.
  - `text`: Configure o texto inicial da caixa de edição.
  - `maxLength`: Limite a quantidade máxima de texto que pode ser inserida.
  - `font`: Escolha a fonte e o tamanho do texto.
  - `colors`: Defina cores para o texto, borda e seleção.
  - `fieldType`: Escolha entre "text" para texto normal ou "password" para ocultar o texto.


- Para manipular eventos, use os métodos disponíveis:
  - `addEventHandler(eventName, handlerFunction)`: Adicione manipuladores de eventos para responder a ações do usuário, como cliques do mouse e teclas pressionadas.
  - `destroy()`: Remova todos os manipuladores de eventos quando a caixa de edição não for mais necessária.

- Use o método `draw` para desenhar a caixa de edição na tela. É possível especificar um nível de transparência opcional:
  - `alpha`: Controle a transparência da caixa de edição.
```lua
editBox:draw(255)
```


- Manipule eventos, como cliques do mouse e entradas de teclado, com os métodos específicos fornecidos na função `createEditBox`.

- Integre a caixa de edição personalizada em seu projeto Lua e utilize-a para criar interfaces de usuário interativas.

## Exemplo de Uso

Aqui está um exemplo simples de como criar e usar a caixa de edição personalizada:

```lua
local editBox = createEditBox(100, 100, 200, 30, "Digite aqui", 10, "default", {textColor = {255, 255, 255, 1}, borderColor = {10, 10, 10, 1}}, "text")
-- Desenhe a caixa de edição na tela
addEventHandler("onClientRender", root, function()
    editBox:draw(255)
end)
```



## Contribuições

Sinta-se à vontade para contribuir com melhorias ou correções para esta função `createEditBox`. Caso encontre problemas ou tenha sugestões, crie uma "Issue" neste repositório.

## Licença

Este projeto é licenciado sob a [Licença MIT](LICENSE). Você é livre para usar, modificar e distribuir este código de acordo com os termos da licença.

## Autor

Mickael junio - *Discord*: mickaeljr

## Agradecimentos

Agradeça a outros colaboradores ou projetos que tenham inspirado ou ajudado na criação desta função.
