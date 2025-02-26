# Borland Turbo Vision

Uma distribuição moderna do Turbo Vision 2.0, a clássica biblioteca de componentes para interfaces de usuário baseadas em texto. Agora a biblioteca suporta caracteres Unicode.

![tvedit in Konsole](https://user-images.githubusercontent.com/20713561/81506401-4fffdd80-92f6-11ea-8826-ee42612eb82a.png)

As contrubuições mais recentes a biblioteca foram:

* Fazer o Turbo Vision funcionar no Linux alterando a base de código legada o mínimo possível.
* Mantendo-o funcional no DOS/Windows.
* Ser o mais compatível possível no nível do código-fonte com aplicativos Turbo Vision antigos. Isso me levou o contribuidor [magiblot](https://github.com/magiblot) a implementar algumas das funções Borland C++ RTL, conforme explicado abaixo.

Em determinado momento, o contribuidor esclarece que pensou já ter feito o suficiente e que qualquer tentativa de reformular a biblioteca e superar suas limitações originais exigiria estender a API ou quebrar a compatibilidade com versões anteriores, e que uma grande reescrita seria provavelmente necessária.

No entanto, entre julho e agosto de 2020, foi encontrada a maneira de integrar suporte Unicode completo à arquitetura existente, e foi escrito o editor de texto [Turbo](https://github.com/magiblot/turbo) também disponibilizando, dessa forma, os novos recursos no Windows.

O local original do projeto do editor de texto "turbinado" é https://github.com/magiblot/tvision .

# Table of contents

* [What is Turbo Vision good for?](#what-for)
* [How do I use Turbo Vision?](#how-to)
* [Releases and downloads](#downloads)
* Build environment
    * [Linux](#build-linux)
    * [Windows (MSVC)](#build-msvc)
    * [Windows (MinGW)](#build-mingw)
    * [Windows/DOS (Borland C++)](#build-borland)
    * [Vcpkg](#build-vcpkg)
    * [Turbo Vision as a CMake dependency](#build-cmake)
* [Features](#features)
* [API changes](#apichanges)
* [Applications using Turbo Vision](#applications)
* [Unicode support](#unicode)
* [Clipboard interaction](#clipboard)
* [Extended color support](#color)

<div id="what-for"></div>

## Para que serve o Turbo Vision?

Muita coisa mudou desde que a Borland criou o Turbo Vision no início dos anos 90. Muitas ferramentas de GUI hoje separam a especificação de aparência da especificação de comportamento, usam linguagens mais seguras ou dinâmicas que não segfaultam em caso de erro e suportam programação paralela ou assíncrona, ou ambas.

O Turbo Vision não se destaca em nenhuma delas, mas certamente supera muitos dos problemas que os programadores ainda enfrentam hoje ao escrever aplicativos de terminal:

1. Esqueça os recursos do terminal e E/S direta do terminal. Ao escrever um aplicativo Turbo Vision, tudo o que você precisa se preocupar é com o comportamento e a aparência do seu aplicativo — não há necessidade de adicionar soluções alternativas no seu código. O Turbo Vision tenta o melhor para produzir os mesmos resultados em todos os ambientes. Por exemplo: para obter uma cor de fundo brilhante no console Linux, o atributo *blink* precisa ser definido. O Turbo Vision faz isso para você.

2. Reutilize o que já foi feito. O Turbo Vision fornece muitas classes de widget (também conhecidas como *views*), incluindo janelas redimensionáveis ​​e sobrepostas, menus suspensos, caixas de diálogo, botões, barras de rolagem, caixas de entrada, caixas de seleção e botões de opção. Você pode usar e estender esses; mas mesmo se preferir criar os seus próprios, o Turbo Vision já lida com o despacho de eventos, exibição de caracteres Unicode de largura total, etc.: você não precisa perder tempo reescrevendo nada disso.

3. Você consegue imaginar escrever uma interface baseada em texto que funcione tanto no Linux quanto no Windows (e, portanto, seja multiplataforma) pronta para uso, sem `#ifdef`s? O Turbo Vision torna isso possível. Primeiro: o Turbo Vision continua usando arrays `char` em vez de depender do `wchar_t` ou `TCHAR` definido pela implementação e dependente da plataforma. Segundo: graças ao suporte UTF-8 em `setlocale` em [versões recentes do RTL da Microsoft](https://docs.microsoft.com/en-us/cpp/c-runtime-library/reference/setlocale-wsetlocale#utf-8-support), um código como o seguinte funcionará conforme o esperado.
    ```c++
    std::ifstream f("コンピュータ.txt"); // On Windows, the RTL converts this to the system encoding on-the-fly.
    ```

<div id="how-to"></div>

## Como usar o Turbo Vision?

Você pode começar com o [Guia do usuário do Turbo Vision para C++](https://archive.org/details/BorlandTurboVisionForCUserSGuide/mode/1up) e ver os aplicativos de exemplo [`hello`](https://github.com/magiblot/tvision/blob/master/hello.cpp), [`tvdemo`](https://github.com/magiblot/tvision/tree/master/examples/tvdemo) e [`tvedit`](https://github.com/magiblot/tvision/tree/master/examples/tvdemo). Depois que você entender o básico,
sugiro que dê uma olhada no [Guia de programação do Turbo Vision 2.0](https://archive.org/details/bitsavers_borlandTurrogrammingGuide1992_25707423), que é, na minha opinião, mais intuitivo e fácil de entender, apesar de usar Pascal. Até lá, você provavelmente estará interessado no exemplo [`palette`](https://github.com/magiblot/tvision/tree/master/examples/palette), que contém uma descrição detalhada de como as paletas são usadas.

Não se esqueça de conferir também as seções <a href="#features">recursos</a> e <a href="#apichanges">alterações na API</a>.

<div id="downloads"></div>

## Releases e downloads

Este projeto não tem versões estáveis ​​no momento. Se você é um desenvolvedor, tente seguir o último commit e reporte quaisquer problemas que encontrar durante a atualização.

Se você só quer testar os aplicativos de demonstração:

*  Sistemas Unix: você terá que construir o Turbo Vision você mesmo. Você pode seguir as [instruções de construção](#build-linux) abaixo.
*  Windows: você pode encontrar binários atualizados na seção [Ações](https://github.com/magiblot/tvision/actions?query=branch:master+event:push). Clique no primeiro fluxo de trabalho bem-sucedido (com uma marca verde) na lista. Na parte inferior da página do fluxo de trabalho, desde que você tenha feito login no GitHub, você encontrará uma seção *Artifacts* com os seguintes arquivos:
* `examples-dos32.zip`: executáveis ​​de 32 bits construídos com Borland C++. Sem suporte a Unicode.
* `examples-x86.zip`: executáveis ​​de 32 bits criados com MSVC. Windows Vista ou posterior necessário.
* `examples-x64.zip`: executáveis ​​de 64 bits criados com MSVC. x64 Windows Vista ou posterior necessário.

## Ambiente de Compilação e Linkagem

<div id="build-linux"></div>

### Linux

O Turbo Vision pode ser criado como uma biblioteca estática com CMake e GCC/Clang.

```sh
cmake . -B ./build -DCMAKE_BUILD_TYPE=Release && # Could also be 'Debug', 'MinSizeRel' or 'RelWithDebInfo'.
cmake --build ./build # or `cd ./build; make`
```

Versões do CMake mais antigas que 3.13 podem não suportar a opção `-B`. Você pode tentar o seguinte:

```sh
mkdir -p build; cd build
cmake .. -DCMAKE_BUILD_TYPE=Release &&
cmake --build .
```

Os comandos acima produzem os seguintes arquivos:

*  O arquivo `libtvision.a` é a biblioteca estática do Turbo Vision.
*  Os aplicativos de demonstração `hello`, `tvdemo`, `tvedit`, `tvdir`, que foram empacotados com o Turbo Vision original (embora alguns deles tenham algumas melhorias).
*  Os aplicativos de demonstração `mmenu` e `palette` do Suporte Técnico da Borland.
* `tvhc`, o Turbo Vision Help Compiler.

A biblioteca e os executáveis ​​podem ser encontrados na pasta `./build`.

Os requisitos de compilação e linkagem são:

*  Um compilador com suporte a C++14.
*  `libncursesw` (note o 'w').
*  `libgpm` para suporte do mouse no console Linux (opcional).

Se sua distribuição fornece *pacotes de desenvolvimento* separados (por exemplo, `libncurses-dev`, `libgpm-dev` em distribuições baseadas em Debian), instale-os também.

<div id="build-linux-runtime"></div>

Os requisitos de tempo de execução são:

*  As aplicações`xsel` ou `xclip` (que compõem o kit X11) para suporte à área de transferência em ambientes X11.
* `wl-clipboard` para suporte à área de transferência em ambientes Wayland.

A linha de comando mínima necessária para construir um aplicativo Turbo Vision (por exemplo, `hello.cpp` com GCC) a partir da raiz deste projeto é:

```sh
g++ -std=c++14 -o hello hello.cpp ./build/libtvision.a -Iinclude -lncursesw -lgpm
```

Você também pode precisar de:

* `-Iinclude/tvision` se seu aplicativo usar o Turbo Vision 1.x includes (`#include <tv.h>` em vez de `#include <tvision/tv.h>`).

* `-Iinclude/tvision/compat/borland` se seu aplicativo incluir cabeçalhos Borland (`dir.h`, `iostream.h`, etc.).

* No Gentoo (e possivelmente outros): `-ltinfow` se `libtinfo.so` e `libtinfow.so` estiverem disponíveis no seu sistema. Caso contrário, você pode obter uma falha de segmentação ao executar aplicativos Turbo Vision ([#11](https://github.com/magiblot/tvision/issues/11)). Observe que `tinfo` é empacotado com `ncurses`.

`-lgpm` só é necessário se o Turbo Vision foi criado com suporte a `libgpm`.

Os cabeçalhos de compatibilidade com versões anteriores em `include/tvision/compat/borland` emulam o Borland C++ RTL. O código-fonte do Turbo Vision ainda depende deles, e eles podem ser úteis se estiver portando aplicativos antigos. Isso também significa que incluir `tvision/tv.h` trará vários nomes `std` para o namespace global.

<div id="build-msvc"></div>

### Windows (MSVC)

O processo de construção com MSVC é um pouco mais complexo, pois há mais opções para escolher. Observe que você precisará de diferentes diretórios de construção para diferentes arquiteturas de destino. Por exemplo, para gerar binários otimizados:

```sh
cmake . -B ./build && # Add '-A x64' (64-bit) or '-A Win32' (32-bit) to override the default platform.
cmake --build ./build --config Release # Could also be 'Debug', 'MinSizeRel' or 'RelWithDebInfo'.
```

No exemplo acima, `tvision.lib` e os aplicativos de exemplo serão colocados em `./build/Release`.

Se você deseja vincular o Turbo Vision estaticamente à biblioteca de tempo de execução da Microsoft (`/MT` em vez de `/MD`), habilite a opção `TV_USE_STATIC_RTL` (`-DTV_USE_STATIC_RTL=ON` ao chamar `cmake`).

Se você deseja vincular um aplicativo ao Turbo Vision, observe que o MSVC não permitirá que você misture `/MT` com `/MD` ou depure com binários não depuráveis. Todos os componentes devem ser vinculados ao RTL da mesma forma.

Se você desenvolver seu próprio aplicativo Turbo Vision, certifique-se de habilitar os seguintes sinalizadores do compilador, ou então você obterá erros de compilação ao incluir `<tvision/tv.h>`:

```
/permissive-
/Zc:__cplusplus
```

Se você usar [Turbo Vision como um submódulo CMake](#build-cmake), esses sinalizadores serão habilitados automaticamente.

**Observação:** o Turbo Vision usa `setlocale` para definir as [funções RTL no modo UTF-8](https://docs.microsoft.com/en-us/cpp/c-runtime-library/reference/setlocale-wsetlocale#utf-8-support). Isso não funcionará se você usar uma versão antiga do RTL.

Com o RTL vinculado estaticamente, e se o UTF-8 for suportado em `setlocale`, os aplicativos Turbo Vision são portáteis e funcionam por padrão no **Windows Vista e posterior**.

<div id="build-mingw"></div>

### Windows (MinGW)

Depois que seu ambiente MinGW estiver configurado corretamente, a compilação será feita de maneira semelhante ao Linux:
```sh
cmake . -B ./build -G "MinGW Makefiles" -DCMAKE_BUILD_TYPE=Release &&
cmake --build ./build
```
No exemplo acima, `libtvision.a` e todos os exemplos estão em `./build` se a opção `TV_BUILD_EXAMPLES` for `ON` (o padrão).

Se você deseja vincular um aplicativo ao Turbo Vision, basta adicionar `-L./build/lib -ltvision` ao seu vinculador e `-I./include` ao seu compilador

<div id="build-borland"></div>

### Windows/DOS (Borland C++)

O Turbo Vision ainda pode ser construído como uma biblioteca DOS ou Windows com Borland C++. Obviamente, não há suporte a Unicode aqui.

Posso confirmar que o processo de construção funciona com:

* Borland C++ 4.52 com o Borland PowerPack para DOS.
* Turbo Assembler 4.0.

Você pode enfrentar problemas diferentes dependendo do seu ambiente de construção. Por exemplo, o Turbo Assembler precisa de um patch para funcionar no Windows 95. No Windows XP, tudo parece funcionar bem. No Windows 10, o MAKE pode emitir o erro `Fatal: Argumentos de comando muito longos`, que pode ser corrigido atualizando o MAKE para o que vem com o Borland C++ 5.x.

Sim, isso funciona no Windows 10 de 64 bits. O que não funcionará é o instalador do Borland C++, que é um aplicativo de 16 bits. Você terá que executá-lo em outro ambiente ou tentar a sorte com [winevdm](https://github.com/otya128/winevdm).

Um Borland Makefile pode ser encontrado no diretório `project`. A construção pode ser feita fazendo:

```sh
cd project
make.exe <options>
```

Onde `<options>` pode ser:

* `-DDOS32` para aplicativos DPMI de 32 bits (que ainda funcionam no Windows de 64 bits).
* `-DWIN32` para aplicativos Win32 nativos de 32 bits (não é possível para TVDEMO, que depende de `farcoreleft()` e outras antiguidades).
* `-DDEBUG` para construir versões de depuração do aplicativo e da biblioteca.
* `-DTVDEBUG` para vincular os aplicativos à versão de depuração da biblioteca.
* `-DOVERLAY`, `-DALIGNMENT={2,4}`, `-DEXCEPTION`, `-DNO_STREAMABLE`, `-DNOTASM` para coisas que nunca usei, mas que apareceram nos makefiles originais.

Isso compilará a biblioteca em um diretório `LIB` ao lado de `project` e compilará executáveis ​​para os aplicativos de demonstração em seus respectivos diretórios `examples/*`.

Desculpe, o makefile raiz assume que ele é executado a partir do diretório `project`. Você ainda pode executar os makefiles originais diretamente (em `source/tvision` e `examples/*`) se quiser usar configurações diferentes.

<div id="build-vcpkg"></div>

### Vcpkg

O Turbo Vision pode ser criado e instalado usando o gerenciador de dependências [vcpkg](https://github.com/Microsoft/vcpkg/):

```sh
git clone https://github.com/Microsoft/vcpkg.git
cd vcpkg
./bootstrap-vcpkg.sh
./vcpkg integrate install
./vcpkg install tvision
```

A porta `tvision` no vcpkg é mantida atualizada pelos membros da equipe da Microsoft e pelos contribuidores da comunidade. Se você achar que ela está desatualizada, [crie um problema ou pull request](https://github.com/Microsoft/vcpkg) no repositório vcpkg.The `tvision` port in vcpkg is kept up to date by Microsoft team members and community contributors. If you find it to be out of date, please [create an issue or pull request](https://github.com/Microsoft/vcpkg) in the vcpkg repository.

<div id="build-cmake"></div>

### Turbo Vision como uma dependência do CMake (não Borland C++)

Se você escolher o sistema de compilação CMake para seu aplicativo, há duas maneiras principais de vincular ao Turbo Vision:

* Instalando o Turbo Vision e importando-o com `find_package`. A instalação depende do tipo de gerador:

    * Primeiro, decida um prefixo de instalação. O padrão funcionará imediatamente, mas geralmente requer privilégios de administrador. Em sistemas Unix, você pode usar `$HOME/.local` em vez disso. No Windows, você pode usar qualquer caminho personalizado que desejar, mas terá que adicioná-lo à variável de ambiente `CMAKE_PREFIX_PATH` ao construir seu aplicativo.
    * Para geradores mono-config (`Unix Makefiles`, `Ninja`...), você só precisa compilar e instalar uma vez:

        ```sh
        cmake . -B ./build # '-DCMAKE_INSTALL_PREFIX=...' to override the install prefix.
        cmake --build ./build
        cmake --install ./build
        ```
    * Para geradores multi-config (`Visual Studio`, `Ninja Multi-Config`...) você deve construir e instalar todas as configurações:

        ```sh
        cmake . -B ./build # '-DCMAKE_INSTALL_PREFIX=...' to override the install prefix.
        cmake --build ./build --config Release
        cmake --build ./build --config Debug --target tvision
        cmake --build ./build --config RelWithDebInfo --target tvision
        cmake --build ./build --config MinSizeRel --target tvision
        cmake --install ./build --config Release
        cmake --install ./build --config Debug --component library
        cmake --install ./build --config RelWithDebInfo --component library
        cmake --install ./build --config MinSizeRel --component library
        ```
    Então, no `CMakeLists.txt` do seu aplicativo, você pode importá-lo assim:
    ```cmake
    find_package(tvision CONFIG)
    target_link_libraries(my_application tvision::tvision)
    ```

* Tenha o Turbo Vision em um submódulo no seu repositório e importe-o com `add_subdirectory`:


    ```cmake
    add_subdirectory(tvision) # Supondo que o Turbo Vision esteja no diretório 'tvision'.
    target_link_libraries(my_application tvision)
    ```

Em ambos os casos, `<tvision/tv.h>` estará disponível no caminho de inclusão do seu aplicativo durante a compilação, e seu aplicativo será vinculado às bibliotecas necessárias (Ncurses, GPM...) automaticamente.

<div id="features"></div>

## Recursos

### Plataformas modernas (não Borland C++)

* Suporte a UTF-8. Você pode experimentar no aplicativo `tvedit`.
* Suporte a cores de 24 bits (acima das 16 cores originais).
* As caixas de diálogo 'Abrir arquivo' aceitam caminhos de arquivo no estilo Unix e Windows e podem expandir `~/` para `$HOME`.
* O redirecionamento de `stdin`/`stdout`/`stderr` não interfere na E/S do terminal.
* Compatibilidade com arquivos de ajuda de 32 bits.

Existem algumas variáveis ​​de ambiente que afetam o comportamento de todos os aplicativos Turbo Vision:

* `TVISION_MAX_FPS`: taxa de atualização máxima, padrão `60`. Isso pode ajudar a manter a suavidade em emuladores de terminal com tratamento ineficiente de caracteres de desenho de caixa. Valores especiais para esta opção são `0`, para desabilitar a limitação da taxa de atualização, e `-1`, para realmente desenhar no terminal em cada chamada para `THardwareInfo::screenWrite` (útil ao depurar).

* `TVISION_CODEPAGE`: o conjunto de caracteres usado internamente pelo Turbo Vision para traduzir *ASCII estendido* para Unicode. Os valores válidos no momento são `437` e `850`, com `437` sendo o padrão, embora adicionar mais exija muito pouco esforço.

### Unix

* Suporte a terminal baseado em Ncurses.
* Suporte extensivo a mouse e teclado:
* Suporte para codificações de mouse X10 e SGR.
* Suporte para [*modifyOtherKeys*](https://invisible-island.net/xterm/manpage/xterm.html#VT100-Widget-Resources:modifyOtherKeys) do Xterm.
* Suporte para [*fixterms*](http://www.leonerd.org.uk/hacks/fixterms/) de Paul Evans e [protocolo de teclado](https://sw.kovidgoyal.net/kitty/keyboard-protocol/) do Kitty.
* Suporte para [`win32-input-mode`](https://github.com/microsoft/terminal/blob/37b0cfd32ba0aa54e0fe50bb158154d906472a89/doc/specs/%234999%20-%20Improved%20keyboard%20handling%20in%20Conpty.md) do Conpty (disponível no WSL).
* Suporte para extensões de terminal do [far2l](https://github.com/elfmz/far2l).
* Suporte para modificadores de tecla (via `TIOCLINUX`) e mouse (via GPM) no console Linux.
* Manipulador de sinal personalizado que restaura o estado do terminal antes que o programa trave.
* Quando `stderr` é um tty, as mensagens escritas nele são redirecionadas para um buffer para evitar que elas baguncem a exibição e são eventualmente impressas no console ao sair ou suspender o aplicativo.
* O buffer usado para esse propósito tem um tamanho limitado, então as gravações em `stderr` falharão quando o buffer estiver cheio. Se você deseja preservar todo o `stderr`, apenas redirecione-o para um arquivo a partir da linha de comando com `2>`.

As seguintes variáveis ​​de ambiente também são levadas em conta:

* `TERM`: Ncurses usa para determinar as capacidades do terminal. É definido automaticamente pelo emulador de terminal.
* `COLORTERM`: quando definido como `truecolor` ou `24bit`, o Turbo Vision assumirá que o emulador de terminal suporta cores de 24 bits. É definido automaticamente pelos emuladores de terminal que o suportam.
* `ESCDELAY`: o número de milissegundos a esperar após receber um pressionamento de tecla ESC, padrão `10`. Se outra tecla for pressionada durante esse atraso, será interpretado como uma combinação Alt+Tecla. Usar um valor maior é útil quando o terminal não suporta a tecla Alt.
* `TVISION_USE_STDIO`: quando não está vazio, a E/S do terminal é realizada por meio de `stdin`/`stdout`, para que possa ser redirecionada do shell. Por padrão, o Turbo Vision executa E/S de terminal por meio de `/dev/tty`, permitindo que o usuário redirecione `stdin`, `stdout` e `stderr` conforme suas necessidades, sem afetar a estabilidade do aplicativo.

	Por exemplo, o seguinte deixará `out.txt` vazio:

    ```sh
    tvdemo | tee out.txt
    ```

	Enquanto o seguinte despejará todas as sequências de escape e o texto impresso pelo aplicativo em `out.txt`:

    ```sh
    TVISION_USE_STDIO=1 tvdemo | tee out.txt
    ```

### Windows

* Compatível apenas com a API do console Win32. Em emuladores de terminal que não oferecem suporte a isso, o Turbo Vision abrirá automaticamente uma janela de console separada.
* Os aplicativos se ajustam ao tamanho da janela do console em vez do tamanho do buffer (nenhuma barra de rolagem é visível) e o buffer do console é restaurado ao sair ou suspender o Turbo Vision.

O seguinte não está disponível ao compilar com Borland C++:

* A página de código do console é definida como UTF-8 na inicialização e restaurada na saída.
* As funções de tempo de execução C da Microsoft são definidas automaticamente para o modo UTF-8, então você, como desenvolvedor, não precisa usar as variantes `wchar_t`.
* Se o console travar, um novo será alocado automaticamente.

**Observação:** O Turbo Vision grava texto UTF-8 diretamente no console do Windows. Se o console estiver definido no modo legado e a fonte bitmap estiver sendo usada, os caracteres Unicode não serão exibidos corretamente ([foto](https://user-images.githubusercontent.com/20713561/91917174-7a1f4600-ecbf-11ea-8c7a-2ec80d31d2ca.png)). Para evitar isso, o Turbo Vision detecta essa situação e tenta alterar a fonte do console para `Consolas` ou `Lucida Console`.

### Todas as plataformas

Os seguintes são novos recursos não disponíveis na versão Turbo Vision da Borland ou em ports de código aberto anteriores (Sigala, SET):

* Suporte ao botão do meio do mouse e à roda do mouse.
* Suporte a tamanho de tela arbitrário (até 32.767 linhas ou colunas) e tratamento elegante de eventos de redimensionamento de tela.
* As janelas podem ser redimensionadas a partir do canto inferior esquerdo.
* As janelas podem ser arrastadas de áreas vazias com o botão do meio do mouse.
* Usabilidade aprimorada dos menus: eles podem ser fechados clicando novamente no item de menu pai.
* Usabilidade aprimorada das barras de rolagem: arrastá-las também rola a página. Clicar em uma área vazia da barra de rolagem move o polegar para a direita abaixo do cursor. Eles respondem por padrão aos eventos da roda do mouse.
* `TInputLine`s não rolam mais a exibição de texto em foco/desfoque, permitindo que o texto relevante permaneça visível.
* Suporte para terminações de linha LF em `TFileViewer` (`tvdemo`) e `TEditor` (`tvedit`). `TEditor` preserva a terminação de linha ao salvar o arquivo, mas todos os arquivos recém-criados usam CRLF por padrão.
* `TEditor`: menu de contexto no clique direito.
* `TEditor`: arraste e role com o botão do meio do mouse.
* `TEditor`, `TInputLine`: exclua palavras inteiras com `kbAltBack`, `kbCtrlBack` e `kbCtrlDel`.
* `TEditor`: a tecla Home alterna entre o início da linha e o início do texto recuado.
* `TEditor`: suporte para arquivos maiores que 64 KiB em compilações de 32 ou 64 bits.
* `tvdemo`: applet visualizador de eventos útil para depuração de eventos.
* `tvdemo`: opção para alterar o padrão de fundo.

<div id="apichanges"></div>

## Alterações na API

* As gravações de tela são armazenadas em buffer e geralmente são enviadas ao terminal uma vez para cada iteração do loop de eventos ativo (veja também `TVISION_MAX_FPS`). Se você precisar atualizar a tela durante um loop ocupado, você pode usar `TScreen::flushScreen()`.
* `TDrawBuffer` não é mais um array de comprimento fixo e seus métodos impedem acessos ao array após o fim. Portanto, o código antigo contendo comparações com `sizeof(TDrawBuffer)/sizeof(ushort)` não é mais válido; tais verificações devem ser removidas.
* `TApplication` agora fornece `dosShell()`, `cascade()` e `tile()`, e manipula `cmDosShell`, `cmCascade` e `cmTile` por padrão. Essas funções podem ser personalizadas substituindo `getTileRect()` e `writeShellMsg()`. Este é o mesmo comportamento da versão Pascal.
* Suporte à roda do mouse: novo evento de mouse `evMouseWheel`. A direção da roda é especificada no novo campo `event.mouse.wheel`, cujos valores possíveis são `mwUp`, `mwDown`, `mwLeft` ou `mwRight`.
* Suporte ao botão do meio do mouse: novo sinalizador de botão do mouse `mbMiddleButton`.
* O campo `buttons` em eventos `evMouseUp` não está mais vazio. Agora ele indica qual botão foi liberado.
* Suporte a clique triplo: novo sinalizador de evento do mouse `meTripleClick`.
* Os métodos `TRect` `move`, `grow`, `intersect` e `Union` agora retornam `TRect&` em vez de `void` para que possam ser encadeados.
* `TOutlineViewer` agora permite que o nó raiz tenha irmãos.
* Nova função `ushort popupMenu(TPoint where, TMenuItem &aMenu, TGroup *receiver=0)` que gera um `TMenuPopup` na área de trabalho. Veja `source/tvision/popupmnu.cpp`.
* Novo método virtual `TMenuItem& TEditor::initContextMenu(TPoint p)` que determina as entradas do menu de contexto do botão direito em `TEditor`.
* `fexpand` agora pode receber um segundo parâmetro `relativeTo`.
* Nova classe `TStringView`, inspirada em `std::string_view`.
* Muitas funções que originalmente tinham parâmetros de string terminados em nulo agora recebem `TStringView`. `TStringView` é compatível com `std::string_view`, `std::string` e `const char *` (até mesmo `nullptr`).
* Nova classe `TSpan<T>`, inspirada em `std::span`.
* Novas classes `TDrawSurface` e `TSurfaceView`, veja `<tvision/surface.h>`.
* Os subsistemas de integração do sistema (`THardwareInfo`, `TScreen`, `TEventQueue`...) agora são inicializados ao construir um `TApplication` pela primeira vez, em vez de antes de `main`. Eles ainda são destruídos ao sair de `main`.
* Novo método `TVMemMgr::reallocateDiscardable()` que pode ser usado junto com `allocateDiscardable` e `freeDiscardable`.
* Novo método `TView::textEvent()` que permite receber texto de forma eficiente, veja [Interação da área de transferência](#clipboard).
* Nova classe `TClipboard`, veja [Interação da área de transferência](#clipboard).
* Suporte a Unicode, veja [Unicode](#unicode).
* Suporte a True Color, veja [cores estendidas](#color).
* Novo método `static void TEventQueue::waitForEvents(int timeoutMs)` que pode bloquear por até `timeoutMs` milissegundos esperando por eventos de entrada. Um `timeoutMs` negativo pode ser usado para esperar indefinidamente. Se bloquear, tem o efeito colateral de liberar atualizações de tela (via `TScreen::flushScreen()`). É invocado por `TProgram::getEvent()` com `static int TProgram::eventTimeoutMs` (padrão `20`) como argumento para que o loop de eventos não se transforme em um loop ocupado consumindo 100% da CPU.
* Novo método `static void TEventQueue::wakeUp()` que faz com que o loop de eventos retome a execução se for bloqueado em `TEventQueue::waitForEvents()`. Este método é thread-safe, pois seu propósito é desbloquear o loop de eventos de threads secundárias.
* Novo método `void TView::getEvent(TEvent &, int timeoutMs)` que permite esperar por um evento com um tempo limite fornecido pelo usuário (em vez de `TProgram::eventTimeoutMs`).
* Agora é possível especificar uma largura máxima de texto ou contagem máxima de caracteres em `TInputLine`. Isso é feito por meio de um novo parâmetro no construtor de `TInputLine`, `ushort limitMode`, que controla como o segundo parâmetro do construtor, `uint limit`, deve ser tratado. As constantes `ilXXXX` definem os valores possíveis de `limitMode`:
	* `ilMaxBytes` (o padrão): o texto pode ter até `limit` bytes de comprimento, incluindo o terminador nulo.
	* `ilMaxWidth`: o texto pode ter até `limit` colunas de largura.
	* `ilMaxChars`: o texto pode conter até `limit` caracteres não combináveis ​​ou grafemas.
* Novas funções que permitem obter os nomes das constantes do Turbo Vision em tempo de execução (por exemplo, `evCommand`, `kbShiftIns`, etc.):
    ```c++
    void printKeyCode(ostream &, ushort keyCode);
    void printControlKeyState(ostream &, ushort controlKeyState);
    void printEventCode(ostream &, ushort eventCode);
    void printMouseButtonState(ostream &, ushort buttonState);
    void printMouseWheelState(ostream &, ushort wheelState);
    void printMouseEventFlags(ostream &, ushort eventFlags);
    ```
* Nova classe `TKey` que pode ser usada para definir novas combinações de teclas (por exemplo, `Shift+Alt+Up`) especificando um código de tecla e uma máscara de modificadores de tecla:
    ```c++
    auto kbShiftAltUp = TKey(kbUp, kbShift | kbAltShift);
    assert(kbCtrlA == TKey('A', kbCtrlShift));
    assert(TKey(kbCtrlTab, kbShift) == TKey(kbTab, kbShift | kbCtrlShift));
    // Create menu hotkeys.
    new TMenuItem("~R~estart", cmRestart, TKey(kbDel, kbCtrlShift | kbAltShift), hcNoContext, "Ctrl-Alt-Del")
    // Examine KeyDown events:
    if (event.keyDown == TKey(kbEnter, kbShift))
        doStuff();
    ```
* Novos métodos que permitem usar eventos temporizados:
    ```c++
    TTimerId TView::setTimer(uint timeoutMs, int periodMs = -1);
    void TView::killTimer(TTimerId id);
    ```
	`setTimer` inicia um timer que primeiro expirará em `timeoutMs` milissegundos e depois a cada `periodMs` milissegundos.

	Se `periodMs` for negativo, o timer expirará apenas uma vez e será limpo automaticamente. Caso contrário, ele continuará expirando periodicamente até que `killTimer` seja invocado.

	Quando um timer expira, um evento `evBroadcast` com o comando `cmTimerExpired` é emitido, e `message.infoPtr` é definido como o `TTimerId` do timer expirado.

	Eventos de tempo limite são gerados em `TProgram::idle()`. Portanto, eles são processados ​​apenas quando nenhum evento de teclado ou mouse estiver disponível.

## Telas de alguns exemplos

Você encontrará algumas capturas de tela [aqui](https://github.com/magiblot/tvision/issues/7). Sinta-se à vontade para adicionar as suas!

## Contribuindo

Se você conhece algum aplicativo Turbo Vision cujo código-fonte não foi perdido e que poderia se beneficiar disso, me avise.

<div id="applications"></div>

## Aplicações que estão usando o Borland Turbo Vision

Se sua inscrição for baseada neste projeto e você quiser que ele apareça na lista a seguir, é só me avisar.

* [Turbo](https://github.com/magiblot/turbo) by [magiblot](https://github.com/magiblot), um editor de texto de prova de conceito.
* [tvterm](https://github.com/magiblot/tvterm) by [magiblot](https://github.com/magiblot), um emulador de terminal de prova de conceito.
* [TMBASIC](https://github.com/electroly/tmbasic) by [Brian Luft](https://github.com/electroly), uma linguagem de programação para criar aplicativos de console.

<div id="unicode"></div>

# Suporte a caracteres Unicode

A API do Turbo Vision foi estendida para permitir o recebimento de entrada Unicode e a exibição de texto Unicode. A codificação suportada é UTF-8, por uma série de razões:

* É compatível com tipos de dados já presentes (`char *`), portanto, não requer modificações intrusivas no código existente.
* É a mesma codificação usada para E/S de terminal, portanto, conversões redundantes são evitadas.
* Conformidade com o [Manifesto UTF-8 Everywhere](http://utf8everywhere.org/), que expõe muitas outras vantagens.

Observe que, quando construído com Borland C++, o Turbo Vision não suporta Unicode. No entanto, isso não afeta a maneira como os aplicativos do Turbo Vision são escritos, pois as extensões da API são projetadas para permitir código independente de codificação.

## Reading Unicode input

A maneira tradicional de obter texto de um evento de pressionamento de tecla é a seguinte:

```c++
// 'ev' is a TEvent, and 'ev.what' equals 'evKeyDown'.
switch (ev.keyDown.keyCode) {
    // Key shortcuts are usually checked first.
    // ...
    default: {
        // The character is encoded in the current codepage
        // (CP437 by default).
        char c = ev.keyDown.charScan.charCode;
        // ...
    }
}
```

Algumas das classes Turbo Vision existentes que lidam com entrada de texto ainda dependem dessa metodologia, que não mudou. Caracteres de byte único, quando representáveis ​​na página de código atual, continuam disponíveis em `ev.keyDown.charScan.charCode`.

O suporte Unicode consiste em dois novos campos em `ev.keyDown` (que é um `struct KeyDownEvent`):

* `char text[4]`, que pode conter o que foi lido do terminal: geralmente uma sequência UTF-8, mas possivelmente qualquer tipo de dado bruto.
* `uchar textLength`, que é o número de bytes de dados disponíveis em `text`, de 0 a 4.

Observe que a string `text` não é terminada em nulo.
Você pode obter um `TStringView` de um `KeyDownEvent` com o método `getText()`.

Portanto, um caractere Unicode pode ser recuperado de `TEvent` da seguinte maneira:

```c++
switch (ev.keyDown.keyCode) {
    // ...
    default: {
        std::string_view sv = ev.keyDown.getText();
        processText(sv);
    }
}
```

Vamos ver de outra perspectiva. Se o usuário digitar `ñ`, um `TEvent` é gerado com a seguinte struct `keyDown`:

```c++
KeyDownEvent {
    union {
        .keyCode = 0xA4,
        .charScan = CharScanType {
            .charCode = 164 ('ñ'), // In CP437
            .scanCode = 0
        }
    },
    .controlKeyState = 0x200 (kbInsState),
    .text = {'\xC3', '\xB1'}, // In UTF-8
    .textLength = 2
}
```

Entretanto, se eles digitarem `€` o seguinte acontecerá:

```c++
KeyDownEvent {
    union {
        .keyCode = 0x0 (kbNoKey), // '€' not part of CP437
        .charScan = CharScanType {
            .charCode = 0,
            .scanCode = 0
        }
    },
    .controlKeyState = 0x200 (kbInsState),
    .text = {'\xE2', '\x82', '\xAC'}, // In UTF-8
    .textLength = 3
}
```

Se um atalho de tecla for pressionado, `text` estará vazio:

```c++
KeyDownEvent {
    union {
        .keyCode = 0xB (kbCtrlK),
        .charScan = CharScanType {
            .charCode = 11 ('♂'),
            .scanCode = 0
        }
    },
    .controlKeyState = 0x20C (kbCtrlShift | kbInsState),
    .text = {},
    .textLength = 0
}
```
Então, resumindo: as visualizações projetadas sem a entrada Unicode em mente continuarão a funcionar exatamente como antes, e as visualizações que desejam ser compatíveis com Unicode não terão problemas em fazê-lo.

## Exibindo texto Unicode

O design original do Turbo Vision usa 16 bits para representar uma *célula de tela* — 8 bits para um caractere e 8 bits para [atributos de cor do BIOS](https://en.wikipedia.org/wiki/BIOS_color_attributes).

Um novo tipo `TScreenCell` é definido em `<tvision/scrncell.h>` que é capaz de conter um número limitado de pontos de código UTF-8, além de atributos estendidos (negrito, sublinhado, itálico...). No entanto, você não deve escrever texto em um `TScreenCell` diretamente, mas usar funções de API compatíveis com Unicode.

### Regras de exibição de texto

Um caractere fornecido como argumento para qualquer uma das funções da API do Turbo Vision que lidam com a exibição de texto é interpretado da seguinte forma:

* Caracteres não imprimíveis no intervalo `0x00` a `0xFF` são interpretados como caracteres na página de código ativa. Por exemplo, `0x7F` é exibido como `⌂` e `0xF0` como `≡` se estiver usando CP437. Como exceção, `0x00` é sempre exibido como um espaço regular. Esses caracteres têm todos uma coluna de largura.
* Sequências de caracteres que não são UTF-8 válidas são interpretadas como sequências de caracteres na página de código atual, como no caso acima.
* Sequências UTF-8 válidas com uma largura de exibição diferente de um são tratadas de uma maneira especial, veja abaixo.

Por exemplo, a string `"╔[\xFE]╗"` pode ser exibida como `╔[■]╗`. Isso significa que caracteres de desenho de caixa podem ser misturados com UTF-8 em geral, o que é útil para compatibilidade com versões anteriores. Se você confiar nesse comportamento, no entanto, poderá obter resultados inesperados: por exemplo, `"\xC4\xBF"` é uma sequência UTF-8 válida e é exibida como `Ŀ` em vez de `─┐`.

Um dos problemas do suporte Unicode é a existência de caracteres [double-width](https://convertcase.net/vaporwave-wide-text-generator/) e caracteres [combining](https://en.wikipedia.org/wiki/Combining_Diacritical_Marks). Isso entra em conflito com a suposição original da Turbo Vision de que a tela é uma grade de células ocupadas por um único caractere cada. No entanto, esses casos são tratados da seguinte maneira:

* Caracteres de largura dupla podem ser desenhados em qualquer lugar da tela e nada de ruim acontece se eles se sobrepõem parcialmente a outros caracteres.
* Caracteres de largura zero sobrepõem o caractere anterior. Por exemplo, a sequência `में` consiste no caractere de largura única `म` e nos caracteres de combinação `े` e `ं`. Neste caso, três pontos de código Unicode são ajustados na mesma célula.

O `ZERO WIDTH JOINER` (`U+200D`) é sempre omitido, pois complica muito as coisas. Por exemplo, ele pode transformar uma string como `"👩👦"` (4 colunas de largura) em `"👩‍👦"` (2 colunas de largura). Nem todos os emuladores de terminal respeitam o ZWJ, então, para produzir resultados previsíveis, o Turbo Vision imprimirá `"👩👦"` e `"👩‍👦"` como `👩👦`.
	* Nenhuma falha gráfica notável ocorrerá, desde que seu emulador de terminal respeite as larguras dos caracteres medidas por `wcwidth`.

Aqui está um exemplo desses caracteres no editor de texto [Turbo](https://github.com/magiblot/turbo):
![Exibição ampla de caracteres](https://user-images.githubusercontent.com/20713561/103179253-51344980-488a-11eb-9a29-79b9acb1b4b9.png)

### Funções de API compatíveis com Unicode

A maneira usual de escrever na tela é usando `TDrawBuffer`. Alguns métodos foram adicionados e outros mudaram seus significados:

```c++
void TDrawBuffer::moveChar(ushort indent, char c, TColorAttr attr, ushort count);
void TDrawBuffer::putChar(ushort indent, char c);
```

`c` é sempre interpretado como um caractere na página de código ativa.

```c++
ushort TDrawBuffer::moveStr(ushort indent, TStringView str, TColorAttr attr);
ushort TDrawBuffer::moveCStr(ushort indent, TStringView str, TAttrPair attrs);
```

`str` é interpretado de acordo com as regras expostas anteriormente.

```c++
ushort TDrawBuffer::moveStr(ushort indent, TStringView str, TColorAttr attr, ushort maxWidth, ushort strOffset = 0); // New
ushort TDrawBuffer::moveCStr(ushort indent, TStringView str, TColorAttr attr, ushort maxWidth, ushort strOffset = 0); // New
```

`str` é interpretado de acordo com as regras expostas anteriormente, mas:
* `maxWidth` especifica a quantidade máxima de texto que deve ser copiada de `str`, medida em largura de texto (não em bytes).
* `strOffset` especifica a posição inicial em `str` de onde copiar, medida em largura de texto (não em bytes). Isso é útil para rolagem horizontal. Se `strOffset` apontar para o meio de um caractere de largura dupla, um espaço será copiado em vez da metade direita do caractere de largura dupla, já que não é possível fazer tal coisa.

Os valores de retorno são o número de células no buffer que foram realmente preenchidas com texto (que é o mesmo que a largura do texto copiado).

```c++
void TDrawBuffer::moveBuf(ushort indent, const void *source, TColorAttr attr, ushort count);
```
O nome desta função é enganoso. Mesmo em sua implementação original, `source` é tratado como uma string. Então é equivalente a `moveStr(indent, TStringView((const char*) source, count), attr)`.

Existem outras funções úteis que reconhecem Unicode:

```c++
int cstrlen(TStringView s);
```
Retorna o comprimento exibido de `s` de acordo com as regras mencionadas acima, descartando caracteres `~`.

```c++
int strwidth(TStringView s); // New
```
Returns the displayed length of `s`.

On Borland C++, these methods assume a single-byte encoding and all characters being one column wide. This makes it possible to write encoding-agnostic `draw()` and `handleEvent()` methods that work on both platforms without a single `#ifdef`.

The functions above are implemented using the functions from the `TText` namespace, another API extension. You will have to use them directly if you want to fill `TScreenCell` objects with text manually. To give an example, below are some of the `TText` functions. You can find all of them with complete descriptions in `<tvision/ttext.h>`.

```c++
size_t TText::next(TStringView text);
size_t TText::prev(TStringView text, size_t index);
void TText::drawChar(TSpan<TScreenCell> cells, char c);
size_t TText::drawStr(TSpan<TScreenCell> cells, size_t indent, TStringView text, int textIndent);
bool TText::drawOne(TSpan<TScreenCell> cells, size_t &i, TStringView text, size_t &j);
```

For drawing `TScreenCell` buffers into a view, the following methods are available:

```c++
void TView::writeBuf(short x, short y, short w, short h, const TScreenCell *b); // New
void TView::writeLine(short x, short y, short w, short h, const TScreenCell *b); // New
```

### Example: Unicode text in menus and status bars

It's as simple as it can be. Let's modify `hello.cpp` as follows:

```c++
TMenuBar *THelloApp::initMenuBar( TRect r )
{
    r.b.y = r.a.y+1;
    return new TMenuBar( r,
      *new TSubMenu( "~Ñ~ello", kbAltH ) +
        *new TMenuItem( "階~毎~料入報最...", GreetThemCmd, kbAltG ) +
        *new TMenuItem( "五劫~の~擦り切れ", cmYes, kbNoKey, hcNoContext ) +
        *new TMenuItem( "העברית ~א~ינטרנט", cmNo, kbNoKey, hcNoContext ) +
         newLine() +
        *new TMenuItem( "E~x~it", cmQuit, cmQuit, hcNoContext, "Alt-X" )
        );
}

TStatusLine *THelloApp::initStatusLine( TRect r )
{
    r.a.y = r.b.y-1;
    return new TStatusLine( r,
        *new TStatusDef( 0, 0xFFFF ) +
            *new TStatusItem( "~Alt-Ç~ Exit", kbAltX, cmQuit ) +
            *new TStatusItem( 0, kbF10, cmMenu )
            );
}
```
Here is what it looks like:

![Unicode Hello](https://user-images.githubusercontent.com/20713561/103179255-5396a380-488a-11eb-88ad-0192adbe233e.png)

### Example: writing Unicode-aware `draw()` methods

The following is an excerpt from an old implementation of `TFileViewer::draw()` (part of the `tvdemo` application), which does not draw Unicode text properly:

```c++
if (delta.y + i < fileLines->getCount()) {
    char s[maxLineLength+1];
    p = (char *)(fileLines->at(delta.y+i));
    if (p == 0 || strlen(p) < delta.x)
        s[0] = EOS;
    else
        strnzcpy(s, p+delta.x, maxLineLength+1);
    b.moveStr(0, s, c);
}
writeBuf( 0, i, size.x, 1, b );
```
All it does is move part of a string in `fileLines` into `b`, which is a `TDrawBuffer`. `delta` is a `TPoint` representing the scroll offset in the text view, and `i` is the index of the visible line being processed. `c` is the text color. A few issues are present:

* `TDrawBuffer::moveStr(ushort, const char *, TColorAttr)` takes a null-terminated string. In order to pass a substring of the current line, a copy is made into the array `s`, at the risk of a [buffer overrun](https://github.com/magiblot/tvision/commit/8aa2bf4af4474b85e86e340b08d7c56081b68986). The case where the line does not fit into `s` is not handled, so at most `maxLineLenght` characters will be copied. What's more, a multibyte character near position `maxLineLength` could be copied incompletely and be displayed as garbage.
* `delta.x` is the first visible column. With multibyte-encoded text, it is no longer true that such column begins at position `delta.x` in the string.

Below is a corrected version of the code above that handles Unicode properly:

```c++
if (delta.y + i < fileLines->getCount()) {
    p = (char *)(fileLines->at(delta.y+i));
    if (p)
        b.moveStr(0, p, c, size.x, delta.x);
}
writeBuf( 0, i, size.x, 1, b );
```
The overload of `moveStr` used here is `TDrawBuffer::moveStr(ushort indent, TStringView str, TColorAttr attr, ushort width, ushort begin)`. This function not only provides Unicode support, but also helps us write cleaner code and overcome some of the limitations previously present:

* The intermediary copy is avoided, so the displayed text is not limited to `maxLineLength` bytes.
* `moveStr` takes care of printing the string starting at column `delta.x`. We do not even need to worry about how many bytes correspond to `delta.x` columns.
* Similarly, `moveStr` is instructed to copy at most `size.x` columns of text without us having to care about how many bytes that is nor dealing with edge cases. The code is written in an encoding-agnostic way and will work whether multibyte characters are being considered or not.
* In case you hadn't realized yet, the intermediary copy in the previous version was completely unnecessary. It would have been necessary only if we had needed to trim the end of the line, but that was not the case: text occupies all of the view's width, and `TView::writeBuf` already takes care of not writing beyond it. Yet it is interesting to see how an unnecessary step not only was limiting functionality but also was prone to bugs.

## Unicode support across standard views

Support for creating Unicode-aware views is in place, and most views in the original Turbo Vision library have been adapted to handle Unicode.

The following views can display Unicode text properly. Some of them also do horizontal scrolling or word wrapping; all of that should work fine.

- [x] `TStaticText` ([`7b15d45d`](https://github.com/magiblot/tvision/commit/7b15d45da231f75f2677454021c2e34ad1149ca8)).
- [x] `TFrame` ([`81066ee5`](https://github.com/magiblot/tvision/commit/81066ee5c05496612dfcd9cf75df5702cbfb9679)).
- [x] `TStatusLine` ([`477b3ae9`](https://github.com/magiblot/tvision/commit/477b3ae91fd84eb1487dca18a87b3f7b8699c576)).
- [x] `THistoryViewer` ([`81066ee5`](https://github.com/magiblot/tvision/commit/81066ee5c05496612dfcd9cf75df5702cbfb9679)).
- [x] `THelpViewer` ([`81066ee5`](https://github.com/magiblot/tvision/commit/81066ee5c05496612dfcd9cf75df5702cbfb9679), [`8c7dac2a`](https://github.com/magiblot/tvision/commit/8c7dac2a61000f17e09cc31ebbb58b030f95c0e5), [`20f331e3`](https://github.com/magiblot/tvision/commit/20f331e362255d45859c36050ff75ffab078c3ab)).
- [x] `TListViewer` ([`81066ee5`](https://github.com/magiblot/tvision/commit/81066ee5c05496612dfcd9cf75df5702cbfb9679)).
- [x] `TMenuBox` ([`81066ee5`](https://github.com/magiblot/tvision/commit/81066ee5c05496612dfcd9cf75df5702cbfb9679)).
- [x] `TTerminal` ([`ee821b69`](https://github.com/magiblot/tvision/commit/ee821b69c5dd81c565fe1add1ac6f0a2f8a96a01)).
- [x] `TOutlineViewer` ([`6cc8cd38`](https://github.com/magiblot/tvision/commit/6cc8cd38da5841201544d6ba103f9662d7675213)).
- [x] `TFileViewer` (from the `tvdemo` application) ([`068bbf7a`](https://github.com/magiblot/tvision/commit/068bbf7a0a13482bda91f9f3411ec614f9a1e6ff)).
- [x] `TFilePane` (from the `tvdir` application) ([`9bcd897c`](https://github.com/magiblot/tvision/commit/9bcd897cb7cf010ef34d0281d42e9ea58345ce53)).

The following views can, in addition, process Unicode text or user input:

- [x] `TInputLine` ([`81066ee5`](https://github.com/magiblot/tvision/commit/81066ee5c05496612dfcd9cf75df5702cbfb9679), [`cb489d42`](https://github.com/magiblot/tvision/commit/cb489d42d522f7515c870942bcaa8f0f3dea3f35)).
- [x] `TEditor` ([`702114dc`](https://github.com/magiblot/tvision/commit/702114dc03a13ebce2b52504eb122c97f9892de9)). Instances are in UTF-8 mode by default. You may switch back to single-byte mode by pressing `Ctrl+P`. This only changes how the document is displayed and the encoding of user input; it does not alter the document. This class is used in the `tvedit` application; you may test it there.

Views not in this list may not have needed any corrections or I simply forgot to fix them. Please submit an issue if you notice anything not working as expected.

Use cases where Unicode is not supported (not an exhaustive list):

- [ ] Highlighted key shortcuts, in general (e.g. `TMenuBox`, `TStatusLine`, `TButton`...).

<div id="clipboard"></div>

# Clipboard interaction

Originally, Turbo Vision offered no integration with the system clipboard, since there was no such thing on MS-DOS.

It did offer the possibility of using an instance of `TEditor` as an internal clipboard, via the `TEditor::clipboard` static member. However, `TEditor` was the only class able to interact with this clipboard. It was not possible to use it with `TInputLine`, for example.

Turbo Vision applications are now most likely to be ran in a graphical environment through a terminal emulator. In this context, it would be desirable to interact with the system clipboard in the same way as a regular GUI application would do.

To deal with this, a new class `TClipboard` has been added which allows accessing the system clipboard. If the system clipboard is not accessible, it will instead use an internal clipboard.

## Enabling clipboard support

On Windows (including WSL) and macOS, clipboard integration is supported out-of-the-box.

On Unix systems other than macOS, it is necessary to install some external dependencies. See [runtime requirements](#build-linux-runtime).

For applications running remotely (e.g. through SSH), clipboard integration is supported in the following situations:

* When X11 forwarding over SSH is enabled (`ssh -X`).
* When your terminal emulator supports far2l's terminal extensions ([far2l](https://github.com/elfmz/far2l), [putty4far2l](https://github.com/ivanshatsky/putty4far2l)).
* When your terminal emulator supports OSC 52 escape codes:
    * [alacritty](https://github.com/alacritty/alacritty), [kitty](https://github.com/kovidgoyal/kitty), [foot](https://codeberg.org/dnkl/foot).
    * [xterm](https://invisible-island.net/xterm/), if the `allowWindowOps` option is enabled.
    * A few other terminals only support the Copy action.

Additionally, it is always possible to paste text using your terminal emulator's own Paste command (usually `Ctrl+Shift+V` or `Cmd+V`).

## API usage

To use the `TClipboard` class, define the macro `Uses_TClipboard` before including `<tvision/tv.h>`.

### Writing to the clipboard

```c++
static void TClipboard::setText(TStringView text);
```

Sets the contents of the system clipboard to `text`. If the system clipboard is not accessible, an internal clipboard is used instead.

### Reading the clipboard

```c++
static void TClipboard::requestText();
```

Requests the contents of the system clipboard asynchronously, which will be later received in the form of regular `evKeyDown` events. If the system clipboard is not accessible, an internal clipboard is used instead.

### Processing Paste events

A Turbo Vision application may receive a Paste event for two different reasons:

* Because `TClipboard::requestText()` was invoked.
* Because the user pasted text through the terminal.

In both cases the application will receive the clipboard contents in the form of regular `evKeyDown` events. These events will have a `kbPaste` flag in `keyDown.controlKeyState` so that they can be distinguished from regular key presses.

Therefore, if your view can handle user input it will also handle Paste events by default. However, if the user pastes 5000 characters, the application will behave as if the user pressed the keyboard 5000 times. This involves drawing views, completing the event loop, updating the screen..., which is far from optimal if your view is a text editing component, for example.

For the purpose of dealing with this situation, another function has been added:

```c++
bool TView::textEvent(TEvent &event, TSpan<char> dest, size_t &length);
```

`textEvent()` attempts to read text from consecutive `evKeyDown` events and stores it in a user-provided buffer `dest`. It returns `false` when no more events are available or if a non-text event is found, in which case this event is saved with `putEvent()` so that it can be processed in the next iteration of the event loop. Finally, it calls `clearEvent(event)`.

The exact number of bytes read is stored in the output parameter `length`, which will never be larger than `dest.size()`.

Here is an example on how to use it:

```c++
// 'ev' is a TEvent, and 'ev.what' equals 'evKeyDown'.
// If we received text from the clipboard...
if (ev.keyDown.controlKeyState & kbPaste) {
    char buf[512];
    size_t length;
    // Fill 'buf' with the text in 'ev' and in
    // upcoming events from the input queue.
    while (textEvent(ev, buf, length)) {
        // Process 'length' bytes of text in 'buf'...
    }
}
```

### Enabling application-wide clipboard usage

The standard views `TEditor` and `TInputLine` react to the `cmCut`, `cmCopy` and `cmPaste` commands. However, your application first has to be set up to use these commands. For example:

```c++
TStatusLine *TMyApplication::initStatusLine( TRect r )
{
    r.a.y = r.b.y - 1;
    return new TStatusLine( r,
        *new TStatusDef( 0, 0xFFFF ) +
            // ...
            *new TStatusItem( 0, kbCtrlX, cmCut ) +
            *new TStatusItem( 0, kbCtrlC, cmCopy ) +
            *new TStatusItem( 0, kbCtrlV, cmPaste ) +
            // ...
    );
}
```

`TEditor` and `TInputLine` automatically enable and disable these commands. For example, if a `TEditor` or `TInputLine` is focused, the `cmPaste` command will be enabled. If there is selected text, the `cmCut` and `cmCopy` commands will also be enabled. If no `TEditor` or `TInputLine`s are focused, then these commands will be disabled.

<div id="color"></div>

# Extended color support

The Turbo Vision API has been extended to allow more than the original 16 colors.

Colors can be specified using any of the following formats:

* [BIOS color attributes](https://en.wikipedia.org/wiki/BIOS_color_attributes) (4-bit), the format used originally on MS-DOS.
* RGB (24-bit).
* `xterm-256color` palette indices (8-bit).
* The *terminal default* color. This is the color used by terminal emulators when no display attributes (bold, color...) are enabled (usually white for foreground and black for background).

Although Turbo Vision applications are likely to be ran in a terminal emulator, the API makes no assumptions about the display device. That is to say, the complexity of dealing with terminal emulators is hidden from the programmer and managed by Turbo Vision itself.

For example: color support varies among terminals. If the programmer uses a color format not supported by the terminal emulator, Turbo Vision will quantize it to what the terminal can display. The following images represent the quantization of a 24-bit RGB picture to 256, 16 and 8 color palettes:

| 24-bit color (original) | 256 colors |
|:-:|:-:|
|![mpv-shot0005](https://user-images.githubusercontent.com/20713561/111095336-7c4f4080-853d-11eb-8331-798898a2af68.png)|![mpv-shot0002](https://user-images.githubusercontent.com/20713561/111095333-7b1e1380-853d-11eb-8c4d-989fe24d0498.png)|

| 16 colors | 8 colors (bold as bright) |
|:-:|:-:|
|![mpv-shot0003](https://user-images.githubusercontent.com/20713561/111095334-7bb6aa00-853d-11eb-9a3f-e7decc0bac7d.png)|![mpv-shot0004](https://user-images.githubusercontent.com/20713561/111095335-7bb6aa00-853d-11eb-9098-38d6f6c3c1da.png)|

Extended color support basically comes down to the following:
* Turbo Vision has originally used [BIOS color attributes](https://en.wikipedia.org/wiki/BIOS_color_attributes) stored in an `uchar`. `ushort` is used to represent attribute pairs. This is still the case when using Borland C++.
* In modern platforms a new type `TColorAttr` has been added which replaces `uchar`. It specifies a foreground and background color and a style. Colors can be specified in different formats (BIOS color attributes, 24-bit RGB...). Styles are the typical ones (bold, italic, underline...). There's also `TAttrPair`, which replaces `ushort`.
* `TDrawBuffer`'s methods, which used to take `uchar` or `ushort` parameters to specify color attributes, now take `TColorAttr` or `TAttrPair`.
* `TPalette`, which used to contain an array of `uchar`, now contains an array of `TColorAttr`. The `TView::mapColor` method also returns `TColorAttr` instead of `uchar`.
* `TView::mapColor` has been made virtual so that the palette system can be bypassed without having to rewrite any `draw` methods.
* `TColorAttr` and `TAttrPair` can be initialized with and casted into `uchar` and `ushort` in a way such that legacy code still compiles out-of-the-box without any change in functionality.

Below is a more detailed explanation aimed at developers.

## Data Types

In the first place we will explain the data types the programmer needs to know in order to take advantage of the extended color support. To get access to them, you may have to define the macro `Uses_TColorAttr` before including `<tvision/tv.h>`.

All the types described in this section are *trivial*. This means that they can be `memset`'d and `memcpy`'d. But variables of these types are *uninitialized* when declared without initializer, just like primitive types. So make sure you don't manipulate them before initializing them.

### Color format types

Several types are defined which represent different color formats.
The reason why these types exist is to allow distinguishing color formats using the type system. Some of them also have public fields which make it easier to manipulate individual bits.

* `TColorBIOS` represents a BIOS color. It allows accessing the `r`, `g`, `b` and `bright` bits individually, and can be casted implicitly into/from `uint8_t`.

    The memory layout is:

    * Bit 0: Blue (field `b`).
    * Bit 1: Green (field `g`).
    * Bit 2: Red (field `r`).
    * Bit 3: Bright (field `bright`).
    * Bits 4-7: unused.

    Examples of `TColorBIOS` usage:
    ```c++
    TColorBIOS bios = 0x4;  // 0x4: red.
    bios.bright = 1;        // 0xC: light red.
    bios.b = bios.r;        // 0xD: light magenta.
    bios = bios ^ 3;        // 0xE: yellow.
    uint8_t c = bios;       // Implicit conversion to integer types.
    ```

    In terminal emulators, BIOS colors are mapped to the basic 16 ANSI colors.

* `TColorRGB` represents a color in 24-bit RGB. It allows accessing the `r`, `g` and `b` bit fields individually, and can be casted implicitly into/from `uint32_t`.

    The memory layout is:

    * Bits 0-7: Blue (field `b`).
    * Bits 8-15: Green (field `g`).
    * Bits 16-23: Red (field `r`).
    * Bits 24-31: unused.

    Examples of `TColorRGB` usage:
    ```c++
    TColorRGB rgb = 0x9370DB;   // 0xRRGGBB.
    rgb = {0x93, 0x70, 0xDB};   // {R, G, B}.
    rgb = rgb ^ 0xFFFFFF;       // Negated.
    rgb.g = rgb.r & 0x88;       // Access to individual components.
    uint32_t c = rgb;           // Implicit conversion to integer types.
    ```

* `TColorXTerm` represents an index into the `xterm-256color` color palette. It can be casted into and from `uint8_t`.

### `TColorDesired`

`TColorDesired` represents a color which the programmer intends to show on screen, encoded in any of the supported color types.

A `TColorDesired` can be initialized in the following ways:

* As a BIOS color: with a `char` literal or a `TColorBIOS` object:

    ```c++
    TColorDesired bios1 = '\xF';
    TColorDesired bios2 = TColorBIOS(0xF);
    ```
* As a RGB color: with an `int` literal or a `TColorRGB` object:

    ```c++
    TColorDesired rgb1 = 0xFF7700; // 0xRRGGBB.
    TColorDesired rgb2 = TColorRGB(0xFF, 0x77, 0x00); // {R, G, B}.
    TColorDesired rgb3 = TColorRGB(0xFF7700); // 0xRRGGBB.
    ```
* As an XTerm palette index: with a `TColorXTerm` object.
* As the *terminal default* color: through zero-initialization:

    ```c++
    TColorDesired def1 {};
    // Or with 'memset':
    TColorDesired def2;
    memset(&def2, 0, sizeof(def2));
    ```

`TColorDesired` has methods to query the contained color, but you will usually not need to use them. See the struct definition in `<tvision/colors.h>` for more information.

Trivia: the name is inspired by [Scintilla](https://www.scintilla.org/index.html)'s `ColourDesired`.

### `TColorAttr`

`TColorAttr` describes the color attributes of a screen cell. This is the type you are most likely to interact with if you intend to change the colors in a view.

A `TColorAttr` is composed of:

* A foreground color, of type `TColorDesired`.
* A background color, of type `TColorDesired`.
* A style bitmask containing a combination of the following flags:

    * `slBold`.
    * `slItalic`.
    * `slUnderline`.
    * `slBlink`.
    * `slReverse`.
    * `slStrike`.

    These flags are based on the basic display attributes selectable through [ANSI escape codes](https://en.wikipedia.org/wiki/ANSI_escape_code#SGR_(Select_Graphic_Rendition)_parameters). The results may vary between terminal emulators. `slReverse` is probably the least reliable of them: prefer using the `TColorAttr reverseAttribute(TColorAttr attr)` free function over setting this flag.

The most straight-forward way to create a `TColorAttr` is by means of the `TColorAttr(TColorDesired fg, TColorDesired bg, ushort style=0)` and `TColorAttr(int bios)` constructors:

```c++
// Foreground: RGB 0x892312
// Background: RGB 0x7F00BB
// Style: Normal.
TColorAttr a1 = {TColorRGB(0x89, 0x23, 0x12), TColorRGB(0x7F, 0x00, 0xBB)};

// Foreground: BIOS 0x7.
// Background: RGB 0x7F00BB.
// Style: Bold, Italic.
TColorAttr a2 = {'\x7', 0x7F00BB, slBold | slItalic};

// Foreground: Terminal default.
// Background: BIOS 0xF.
// Style: Normal.
TColorAttr a3 = {{}, TColorBIOS(0xF)};

// Foreground: Terminal default.
// Background: Terminal default.
// Style: Normal.
TColorAttr a4 = {};

// Foreground: BIOS 0x0
// Background: BIOS 0x7
// Style: Normal
TColorAttr a5 = 0x70;
```

The fields of a `TColorAttr` can be accessed with the following free functions:

```c++
TColorDesired getFore(const TColorAttr &attr);
TColorDesired getBack(const TColorAttr &attr);
ushort getStyle(const TColorAttr &attr);
void setFore(TColorAttr &attr, TColorDesired fg);
void setBack(TColorAttr &attr, TColorDesired bg);
void setStyle(TColorAttr &attr, ushort style);
```

### `TAttrPair`

`TAttrPair` is a pair of `TColorAttr`, used by some API functions to pass two attributes at once.

You may initialize a `TAttrPair` with the `TAttrPair(const TColorAttrs &lo, const TColorAttrs &hi)` constructor:

```c++
TColorAttr cNormal = {0x234983, 0x267232};
TColorAttr cHigh = {0x309283, 0x127844};
TAttrPair attrs = {cNormal, cHigh};
TDrawBuffer b;
b.moveCStr(0, "Normal text, ~Highlighted text~", attrs);
```

The attributes can be accessed with the `[0]` and `[1]` subindices:

```c++
TColorAttr lo = {0x892343, 0x271274};
TColorAttr hi = '\x93';
TAttrPair attrs = {lo, hi};
assert(lo == attrs[0]);
assert(hi == attrs[1]);
```

## Changing the appearance of a `TView`

Views are commonly drawn by means of a `TDrawBuffer`. Most `TDrawBuffer` member functions take color attributes by parameter. For example:

```c++
ushort TDrawBuffer::moveStr(ushort indent, TStringView str, TColorAttr attr);
ushort TDrawBuffer::moveCStr(ushort indent, TStringView str, TAttrPair attrs);
void TDrawBuffer::putAttribute(ushort indent, TColorAttr attr);
```

However, the views provided with Turbo Vision usually store their color information in palettes. A view's palette can be queried with the following member functions:

```c++
TColorAttr TView::mapColor(uchar index);
TAttrPair TView::getColor(ushort indices);
```

* `mapColor` looks up a single color attribute in the view's palette, given an index into the palette. Remember that the palette indices for each view class can be found in the Turbo Vision headers. For example, `<tvision/views.h>` says the following about `TScrollBar`:

    ```c++
    /* ---------------------------------------------------------------------- */
    /*      class TScrollBar                                                  */
    /*                                                                        */
    /*      Palette layout                                                    */
    /*        1 = Page areas                                                  */
    /*        2 = Arrows                                                      */
    /*        3 = Indicator                                                   */
    /* ---------------------------------------------------------------------- */
    ```

* `getColor` is a helper function that allows querying two cell attributes at once. Each byte in the `indices` parameter contains an index into the palette. The `TAttrPair` result contains the two cell attributes.

    For example, the following can be found in the `draw` method of `TMenuBar`:

    ```c++
    TAttrPair cNormal = getColor(0x0301);
    TAttrPair cSelect = getColor(0x0604);
    ```

    Which would be equivalent to this:

    ```c++
    TAttrPair cNormal = {mapColor(1), mapColor(3)};
    TAttrPair cSelect = {mapColor(4), mapColor(6)};
    ```

As an API extension, the `mapColor` method has been made `virtual`. This makes it possible to override Turbo Vision's hierarchical palette system with a custom solution without having to rewrite the `draw()` method.

So, in general, there are three ways to use extended colors in views:

1. By returning extended color attributes from an overridden `mapColor` method:

```c++
// The 'TMyScrollBar' class inherits from 'TScrollBar' and overrides 'TView::mapColor'.
TColorAttr TMyScrollBar::mapColor(uchar index) noexcept
{
    // In this example the values are hardcoded,
    // but they could be stored elsewhere if desired.
    switch (index)
    {
        case 1:     return {0x492983, 0x826124}; // Page areas.
        case 2:     return {0x438939, 0x091297}; // Arrows.
        case 3:     return {0x123783, 0x329812}; // Indicator.
        default:    return errorAttr;
    }
}
```

2. By providing extended color attributes directly to `TDrawBuffer` methods, if the palette system is not being used. For example:

    ```c++
    // The 'TMyView' class inherits from 'TView' and overrides 'TView::draw'.
    void TMyView::draw()
    {
        TDrawBuffer b;
        TColorAttr color {0x1F1C1B, 0xFAFAFA, slBold};
        b.moveStr(0, "This is bold black text over a white background", color);
        /* ... */
    }
    ```

3. By modifying the palettes. There are two ways to do this:

    1. By modifying the application palette after it has been built. Note that the palette elements are `TColorAttr`. For example:

    ```c++
    void updateAppPalette()
    {
        TPalette &pal = TProgram::application->getPalete();
        pal[1] = {0x762892, 0x828712};              // TBackground.
        pal[2] = {0x874832, 0x249838, slBold};      // TMenuView normal text.
        pal[3] = {{}, {}, slItalic | slUnderline};  // TMenuView disabled text.
        /* ... */
    }
    ```

    2. By using extended color attributes in the application palette definition:

    ```c++
    static const TColorAttr cpMyApp[] =
    {
        {0x762892, 0x828712},               // TBackground.
        {0x874832, 0x249838, slBold},       // TMenuView normal text.
        {{}, {}, slItalic | slUnderline},   // TMenuView disabled text.
        /* ... */
    };

    // The 'TMyApp' class inherits from 'TApplication' and overrides 'TView::getPalette'.
    TPalette &TMyApp::getPalette() const
    {
        static TPalette palette(cpMyApp);
        return palette;
    }
    ```

## Display capabilities

`TScreen::screenMode` exposes some information about the display's color support:

* If `(TScreen::screenMode & 0xFF) == TDisplay::smMono`, the display is monocolor (only relevant in DOS).
* If `(TScreen::screenMode & 0xFF) == TDisplay::smBW80`, the display is grayscale (only relevant in DOS).
* If `(TScreen::screenMode & 0xFF) == TDisplay::smCO80`, the display supports at least 16 colors.
    * If `TScreen::screenMode & TDisplay::smColor256`, the display supports at least 256 colors.
    * If `TScreen::screenMode & TDisplay::smColorHigh`, the display supports even more colors (e.g. 24-bit color). `TDisplay::smColor256` is also set in this case.

## Backward-compatibility of color types

The types defined previously represent concepts that are also important when developing for Borland C++:

| Concept | Layout in Borland C++ | Layout in modern platforms |
|:-:|:-:|:-:|
| Color Attribute | `uchar`. A BIOS color attribute. | `struct TColorAttr`. |
| Color | A 4-bit number. | `struct TColorDesired`. |
| Attribute Pair | `ushort`. An attribute in each byte. | `struct TAttrPair`. |

One of this project's key principles is that the API should be used in the same way both in Borland C++ and modern platforms, that is to say, without the need for `#ifdef`s. Another principle is that legacy code should compile out-of-the-box, and adapting it to the new features should increase complexity as little as possible.

Backward-compatibility is accomplished in the following way:

* In Borland C++, `TColorAttr` and `TAttrPair` are `typedef`'d to `uchar` and `ushort`, respectively.
* In modern platforms, `TColorAttr` and `TAttrPair` can be used in place of `uchar` and `ushort`, respectively, since they are able to hold any value that fits into them and can be casted implicitly into/from them.

    A `TColorAttr` initialized with `uchar` represents a BIOS color attribute. When converting back to `uchar`, the following happens:

    * If `fg` and `bg` are BIOS colors, and `style` is cleared, the resulting `uchar` represents the same BIOS color attribute contained in the `TColorAttr` (as in the code above).
    * Otherwise, the conversion results in a color attribute that stands out, i.e. white on magenta, meaning that the programmer should consider replacing `uchar`/`ushort` with `TColorAttr`/`TAttrPair` if they intend to support the extended color attributes.

    The same goes for `TAttrPair` and `ushort`, considering that it is composed of two `TColorAttr`.

A use case of backward-compatibility within Turbo Vision itself is the `TPalette` class, core of the palette system. In its original design, it used a single data type (`uchar`) to represent different things: array length, palette indices or color attributes.

The new design simply replaces `uchar` with `TColorAttr`. This means there are no changes in the way `TPalette` is used, yet `TPalette` is now able to store extended color attributes.

`TColorDialog` hasn't been remodeled, and thus it can't be used to pick extended color attributes at runtime.

### Example: adding extended color support to legacy code

The following pattern of code is common across `draw` methods of views:

```c++
void TMyView::draw()
{
    ushort cFrame, cTitle;
    if (state & sfDragging)
    {
        cFrame = 0x0505;
        cTitle = 0x0005;
    }
    else
    {
        cFrame = 0x0503;
        cTitle = 0x0004;
    }
    cFrame = getColor(cFrame);
    cTitle = getColor(cTitle);
    /* ... */
}
```

In this case, `ushort` is used both as a pair of palette indices and as a pair of color attributes. `getColor` now returns a `TAttrPair`, so even though this compiles out-of-the-box, extended attributes will be lost in the implicit conversion to `ushort`.

The code above still works just like it did originally. It's only non-BIOS color attributes that don't produce the expected result. Because of the compatibility between `TAttrPair` and `ushort`, the following is enough to enable support for extended color attributes:

```diff
-    ushort cFrame, cTitle;
+    TAttrPair cFrame, cTitle;
```

Nothing prevents you from using different variables for palette indices and color attributes, which is what should actually be done. The point of backward-compatibility is the ability to support new features without changing the program's logic, that is to say, minimizing the risk of increasing code complexity or introducing bugs.
