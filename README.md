# Cat Breeds

Esse projeto é um aplicativo simple que consome uma API com informações de raças de gatos e exibe essas informações em uma lista. A lista irá conter o nome da raça e uma foto (ilustrativa) do gato. Para atualizar a lista, arraste a lista pra baixo até que a animação de carregamento execute.

## Arquitetura

O aplicativo demonstra o uso de uma aquitetura MVVM e uso de UIKit para construção da View. Cada pasta pode representar um módulo em uma arquitura modula. E o módulo mais interno é totalmente independente de modulos externos. Seguindo a seguinte ordem:

_[Mais interno]_  **Networking** ---> **Services** ---> **Domain** ---> **Presentation**  _[Mais externo]_

O app ainda poderá conter um módulo global **"App"** que compartilha classes e modelos entre todos os módulos. 

O Wrapper de injeção de independência, por exemplo, segue o formato de compartilhamento. Esse compartilhamento deverá ficar restritito e estruturação do wrapper. As injeções em si são restrita ao protocolos que o módulo consegue exergar de forma que uma classe do módulo Networking não terá visão para injetar algo do módulo de serviço. Isso mantem o isolamento módular e que um módulo externo não saiba detalhes de implementação de um módulo interno.

Apesar do "over-engineering" para um aplicativo tão simples, o objetivo é demonstrar uma opção viável de um aplicativo escalável, dinâmico e de fácil manuteção.

## Dados

O aplicativo consome de uma API para Mocks: "https://66e998e387e41760944a1b25.mockapi.io/cats/breeds"

## Melhorias futuras

- O projeto conta com um componente "AsyncImageView" utilizado é carregada de forma asincróna. No entanto, ela realiza informações fora do seu escopo de arquitetura. O componente deverá ser atualizado para realizar o load da imagem através de um use case que vai descendo camadas até pegar os dados na camada de networking. Além disso, uma implementação mais elaborada da busca envovendo cache pode deixar a busca mais eficiente.


- Injeção de indepedência: no momento, o projeto conta com injeção de forma a registrar apenas singletons e sem parametros. Em um sistema mais completos a injeção deve utilizar o padrão de factories para gerar a instâncias quando for usado. Isso é um problema principalmente se a instância depende de outro paramêtros definidos no fluxo do aplicativo. Para isso, uma mudança mais complexa se faz necessária para permitir tais mudanças. O uso do framework "Swinject" é uma alternativa viável.

- Adição de botão "favorito para marcar raça de gato favorita. A função seria utilizada para uma demonstração de uso de armazenamento local com o uso de CoreData para marcar os favoritos. A demonstração poderia ser feita utilizando UserDefaults. No entanto, devo notar que esse não é o uso ideal do UserDefaults já que não foi feito para armazenar dados massivos, e sim preferencias de personalização/comportamentos do uso do aplicativo em si.

### Testes

- Testes unitários foram escritos para a classe de NetworkClient. Melhorias futuras incluem definir testes mais abrangentes e testes para outras classes e métodos.
