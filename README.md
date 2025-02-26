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

* [Para que serve o Turbo Vision?](#what-for)
* [Como usar o Turbo Vision?](#how-to)
* [Releases e downloads](#downloads)
* Build environment
    * [Linux](#build-linux)
    * [Windows (MSVC)](#build-msvc)
    * [Windows (MinGW)](#build-mingw)
    * [Windows/DOS (Borland C++)](#build-borland)
    * [Vcpkg](#build-vcpkg)
    * [Turbo Vision as a CMake dependency](#build-cmake)
* [Recursos](#features)
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
ushort TDrawBuffer::moveStr(ushort indent, TStringView str, TColorAttr attr, ushort maxWidth, ushort strOffset = 0); // Novidade
ushort TDrawBuffer::moveCStr(ushort indent, TStringView str, TColorAttr attr, ushort maxWidth, ushort strOffset = 0); // Novidade
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
int strwidth(TStringView s); // Novidade
```
Retorna o comprimento exibido de `s`.

No Borland C++, esses métodos assumem uma codificação de byte único e todos os caracteres tendo uma coluna de largura. Isso torna possível escrever métodos `draw()` e `handleEvent()` agnósticos de codificação que funcionam em ambas as plataformas sem um único `#ifdef`.

As funções acima são implementadas usando as funções do namespace `TText`, outra extensão de API. Você terá que usá-las diretamente se quiser preencher objetos `TScreenCell` com texto manualmente. Para dar um exemplo, abaixo estão algumas das funções `TText`. Você pode encontrar todas elas com descrições completas em `<tvision/ttext.h>`.

```c++
size_t TText::next(TStringView text);
size_t TText::prev(TStringView text, size_t index);
void TText::drawChar(TSpan<TScreenCell> cells, char c);
size_t TText::drawStr(TSpan<TScreenCell> cells, size_t indent, TStringView text, int textIndent);
bool TText::drawOne(TSpan<TScreenCell> cells, size_t &i, TStringView text, size_t &j);
```

Para desenhar buffers `TScreenCell` em uma visualização, os seguintes métodos estão disponíveis:

```c++
void TView::writeBuf(short x, short y, short w, short h, const TScreenCell *b); // New
void TView::writeLine(short x, short y, short w, short h, const TScreenCell *b); // New
```

### Example: Unicode text in menus and status bars

É tão simples quanto pode ser. Vamos modificar `hello.cpp` como segue:

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

Veja como é:

![Unicode Hello](https://user-images.githubusercontent.com/20713561/103179255-5396a380-488a-11eb-88ad-0192adbe233e.png)

### Exemplo: escrevendo métodos `draw()` compatíveis com Unicode

O seguinte é um trecho de uma implementação antiga de `TFileViewer::draw()` (parte do aplicativo `tvdemo`), que não desenha texto Unicode corretamente:

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
Tudo o que ele faz é mover parte de uma string em `fileLines` para `b`, que é um `TDrawBuffer`. `delta` é um `TPoint` que representa o deslocamento de rolagem na visualização de texto, e `i` é o índice da linha visível sendo processada. `c` é a cor do texto. Alguns problemas estão presentes:

* `TDrawBuffer::moveStr(ushort, const char *, TColorAttr)` recebe uma string terminada em nulo. Para passar uma substring da linha atual, uma cópia é feita no array `s`, correndo o risco de um [buffer overrun](https://github.com/magiblot/tvision/commit/8aa2bf4af4474b85e86e340b08d7c56081b68986). O caso em que a linha não se encaixa em `s` não é tratado, então no máximo caracteres `maxLineLenght` serão copiados. Além disso, um caractere multibyte próximo à posição `maxLineLength` pode ser copiado de forma incompleta e exibido como lixo.
* `delta.x` é a primeira coluna visível. Com texto codificado em multibyte, não é mais verdade que tal coluna começa na posição `delta.x` na string.

Abaixo está uma versão corrigida do código acima que manipula Unicode corretamente:

```c++
if (delta.y + i < fileLines->getCount()) {
    p = (char *)(fileLines->at(delta.y+i));
    if (p)
        b.moveStr(0, p, c, size.x, delta.x);
}
writeBuf( 0, i, size.x, 1, b );
```
A sobrecarga de `moveStr` usada aqui é `TDrawBuffer::moveStr(ushort indent, TStringView str, TColorAttr attr, ushort width, ushort begin)`. Esta função não só fornece suporte a Unicode, mas também nos ajuda a escrever código mais limpo e superar algumas das limitações presentes anteriormente:

* A cópia intermediária é evitada, então o texto exibido não é limitado a bytes `maxLineLength`.
* `moveStr` cuida de imprimir a string começando na coluna `delta.x`. Nós nem precisamos nos preocupar com quantos bytes correspondem às colunas `delta.x`.
* Similarmente, `moveStr` é instruído a copiar no máximo colunas `size.x` de texto sem que tenhamos que nos preocupar com quantos bytes são ou lidar com casos extremos. O código é escrito de uma forma independente de codificação e funcionará se caracteres multibyte estiverem sendo considerados ou não.
* Caso você ainda não tenha percebido, a cópia intermediária na versão anterior era completamente desnecessária. Teria sido necessária apenas se tivéssemos precisado cortar o final da linha, mas esse não foi o caso: o texto ocupa toda a largura da visualização, e `TView::writeBuf` já cuida de não escrever além dela. Ainda assim, é interessante ver como uma etapa desnecessária não apenas estava limitando a funcionalidade, mas também estava propensa a bugs.

## Suporte Unicode em visualizações padrão

O suporte para criar visualizações compatíveis com Unicode está em vigor, e a maioria das visualizações na biblioteca Turbo Vision original foi adaptada para lidar com Unicode.

As visualizações a seguir podem exibir texto Unicode corretamente. Algumas delas também fazem rolagem horizontal ou quebra de linha; tudo isso deve funcionar bem.

- [x] `TStaticText` ([`7b15d45d`](https://github.com/magiblot/tvision/commit/7b15d45da231f75f2677454021c2e34ad1149ca8)).
- [x] `TFrame` ([`81066ee5`](https://github.com/magiblot/tvision/commit/81066ee5c05496612dfcd9cf75df5702cbfb9679)).
- [x] `TStatusLine` ([`477b3ae9`](https://github.com/magiblot/tvision/commit/477b3ae91fd84eb1487dca18a87b3f7b8699c576)).
- [x] `THistoryViewer` ([`81066ee5`](https://github.com/magiblot/tvision/commit/81066ee5c05496612dfcd9cf75df5702cbfb9679)).
- [x] `THelpViewer` ([`81066ee5`](https://github.com/magiblot/tvision/commit/81066ee5c05496612dfcd9cf75df5702cbfb9679), [`8c7dac2a`](https://github.com/magiblot/tvision/commit/8c7dac2a61000f17e09cc31ebbb58b030f95c0e5), [`20f331e3`](https://github.com/magiblot/tvision/commit/20f331e362255d45859c36050ff75ffab078c3ab)).
- [x] `TListViewer` ([`81066ee5`](https://github.com/magiblot/tvision/commit/81066ee5c05496612dfcd9cf75df5702cbfb9679)).
- [x] `TMenuBox` ([`81066ee5`](https://github.com/magiblot/tvision/commit/81066ee5c05496612dfcd9cf75df5702cbfb9679)).
- [x] `TTerminal` ([`ee821b69`](https://github.com/magiblot/tvision/commit/ee821b69c5dd81c565fe1add1ac6f0a2f8a96a01)).
- [x] `TOutlineViewer` ([`6cc8cd38`](https://github.com/magiblot/tvision/commit/6cc8cd38da5841201544d6ba103f9662d7675213)).
- [x] `TFileViewer` (da aplicação `tvdemo` ) ([`068bbf7a`](https://github.com/magiblot/tvision/commit/068bbf7a0a13482bda91f9f3411ec614f9a1e6ff)).
- [x] `TFilePane` (da aplicação `tvdir`) ([`9bcd897c`](https://github.com/magiblot/tvision/commit/9bcd897cb7cf010ef34d0281d42e9ea58345ce53)).

As seguintes visualizações podem, além disso, processar texto Unicode ou entrada do usuário:

- [x] `TInputLine` ([`81066ee5`](https://github.com/magiblot/tvision/commit/81066ee5c05496612dfcd9cf75df5702cbfb9679), [`cb489d42`](https://github.com/magiblot/tvision/commit/cb489d42d522f7515c870942bcaa8f0f3dea3f35)).
- [x] `TEditor` ([`702114dc`](https://github.com/magiblot/tvision/commit/702114dc03a13ebce2b52504eb122c97f9892de9)). As instâncias estão no modo UTF-8 por padrão. Você pode voltar para o modo de byte único pressionando `Ctrl+P`. Isso apenas altera como o documento é exibido e a codificação da entrada do usuário; não altera o documento. Esta classe é usada no aplicativo `tvedit`; você pode testá-la lá.

Visualizações que não estão nesta lista podem não ter precisado de nenhuma correção ou eu simplesmente esqueci de corrigi-las. Envie um problema se notar que algo não está funcionando como esperado.

Casos de uso em que Unicode não é suportado (não é uma lista exaustiva):


- [ ] Atalhos de teclado destacados, em geral (por exemplo, `TMenuBox`, `TStatusLine`, `TButton`...).

<div id="clipboard"></div>

# Interação com a área de transferência

Originalmente, o Turbo Vision não oferecia integração com a área de transferência do sistema, já que não havia tal coisa no MS-DOS.

Ele oferecia a possibilidade de usar uma instância do `TEditor` como uma área de transferência interna, por meio do membro estático `TEditor::clipboard`. No entanto, `TEditor` era a única classe capaz de interagir com esta área de transferência. Não era possível usá-lo com `TInputLine`, por exemplo.

Os aplicativos do Turbo Vision agora são mais propensos a serem executados em um ambiente gráfico por meio de um emulador de terminal. Nesse contexto, seria desejável interagir com a área de transferência do sistema da mesma forma que um aplicativo GUI regular faria.

Para lidar com isso, uma nova classe `TClipboard` foi adicionada, que permite acessar a área de transferência do sistema. Se a área de transferência do sistema não estiver acessível, ela usará uma área de transferência interna.

## Habilitando suporte à área de transferência

No Windows (incluindo WSL) e macOS, a integração da área de transferência é suportada imediatamente.

Em sistemas Unix diferentes do macOS, é necessário instalar algumas dependências externas. Veja [requisitos de tempo de execução](#build-linux-runtime).

Para aplicativos em execução remotamente (por exemplo, por meio de SSH), a integração da área de transferência é suportada nas seguintes situações:

* Quando o encaminhamento X11 por SSH está habilitado (`ssh -X`).
* Quando seu emulador de terminal suporta extensões de terminal do far2l ([far2l](https://github.com/elfmz/far2l), [putty4far2l](https://github.com/ivanshatsky/putty4far2l)).
* Quando seu emulador de terminal suporta códigos de escape OSC 52:
	* [alacritty](https://github.com/alacritty/alacritty), [kitty](https://github.com/kovidgoyal/kitty), [foot](https://codeberg.org/dnkl/foot).
	* [xterm](https://invisible-island.net/xterm/), se a opção `allowWindowOps` estiver habilitada.
	* Alguns outros terminais suportam apenas a ação Copiar.

Além disso, é sempre possível colar texto usando o comando Colar do seu emulador de terminal (geralmente `Ctrl+Shift+V` ou `Cmd+V`).

## Uso da API

Para usar a classe `TClipboard`, defina a macro `Uses_TClipboard` antes de incluir `<tvision/tv.h>`.

### Escrevendo para a área de transferência

```c++
static void TClipboard::setText(TStringView text);
```

Define o conteúdo da área de transferência do sistema para `text`. Se a área de transferência do sistema não estiver acessível, uma área de transferência interna será usada em vez disso.

### Lendo a área de transferência

```c++
static void TClipboard::requestText();
```

Solicita o conteúdo da área de transferência do sistema de forma assíncrona, que será posteriormente recebido na forma de eventos `evKeyDown` regulares. Se a área de transferência do sistema não estiver acessível, uma área de transferência interna será usada em vez disso.

### Processando eventos de colagem

Um aplicativo Turbo Vision pode receber um evento Paste por dois motivos diferentes:

* Porque `TClipboard::requestText()` foi invocado.
* Porque o usuário colou texto pelo terminal.


Em ambos os casos, o aplicativo receberá o conteúdo da área de transferência na forma de eventos `evKeyDown` regulares. Esses eventos terão um sinalizador `kbPaste` em `keyDown.controlKeyState` para que possam ser distinguidos de pressionamentos de tecla regulares.

Portanto, se sua visualização puder manipular a entrada do usuário, ela também manipulará eventos Paste por padrão. No entanto, se o usuário colar 5000 caracteres, o aplicativo se comportará como se o usuário tivesse pressionado o teclado 5000 vezes. Isso envolve desenhar visualizações, concluir o loop de eventos, atualizar a tela..., o que está longe de ser o ideal se sua visualização for um componente de edição de texto, por exemplo.

Para lidar com essa situação, outra função foi adicionada:


```c++
bool TView::textEvent(TEvent &event, TSpan<char> dest, size_t &length);
```

`textEvent()` tenta ler texto de eventos `evKeyDown` consecutivos e o armazena em um buffer `dest` fornecido pelo usuário. Ele retorna `false` quando não há mais eventos disponíveis ou se um evento não textual é encontrado, em cujo caso esse evento é salvo com `putEvent()` para que possa ser processado na próxima iteração do loop de eventos. Finalmente, ele chama `clearEvent(event)`.

O número exato de bytes lidos é armazenado no parâmetro de saída `length`, que nunca será maior que `dest.size()`.

Aqui está um exemplo de como usá-lo:

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

### Habilitando o uso da área de transferência em todo o aplicativo

As visualizações padrão `TEditor` e `TInputLine` reagem aos comandos `cmCut`, `cmCopy` e `cmPaste`. No entanto, seu aplicativo primeiro precisa ser configurado para usar esses comandos. Por exemplo:

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

`TEditor` e `TInputLine` habilitam e desabilitam automaticamente esses comandos. Por exemplo, se um `TEditor` ou `TInputLine` estiver em foco, o comando `cmPaste` será habilitado. Se houver texto selecionado, os comandos `cmCut` e `cmCopy` também serão habilitados. Se nenhum `TEditor` ou `TInputLine` estiver em foco, esses comandos serão desabilitados.

<div id="color"></div>

# Suporte estendido de cores

A API do Turbo Vision foi estendida para permitir mais do que as 16 cores originais.

As cores podem ser especificadas usando qualquer um dos seguintes formatos:

* [Atributos de cor do BIOS](https://en.wikipedia.org/wiki/BIOS_color_attributes) (4 bits), o formato usado originalmente no MS-DOS.
* RGB (24 bits).
* Índices da paleta `xterm-256color` (8 bits).
* A cor *padrão do terminal*. Esta é a cor usada pelos emuladores de terminal quando nenhum atributo de exibição (negrito, cor...) está habilitado (geralmente branco para primeiro plano e preto para segundo plano).

Embora os aplicativos Turbo Vision provavelmente sejam executados em um emulador de terminal, a API não faz suposições sobre o dispositivo de exibição. Ou seja, a complexidade de lidar com emuladores de terminal é ocultada do programador e gerenciada pelo próprio Turbo Vision.

Por exemplo: o suporte a cores varia entre os terminais. Se o programador usar um formato de cor não suportado pelo emulador de terminal, o Turbo Vision irá quantizá-lo para o que o terminal pode exibir. As imagens a seguir representam a quantização de uma imagem RGB de 24 bits para paletas de 256, 16 e 8 cores:

| 24-bit color (original) | 256 colors |
|:-:|:-:|
|![mpv-shot0005](https://user-images.githubusercontent.com/20713561/111095336-7c4f4080-853d-11eb-8331-798898a2af68.png)|![mpv-shot0002](https://user-images.githubusercontent.com/20713561/111095333-7b1e1380-853d-11eb-8c4d-989fe24d0498.png)|

| 16 colors | 8 colors (bold as bright) |
|:-:|:-:|
|![mpv-shot0003](https://user-images.githubusercontent.com/20713561/111095334-7bb6aa00-853d-11eb-9a3f-e7decc0bac7d.png)|![mpv-shot0004](https://user-images.githubusercontent.com/20713561/111095335-7bb6aa00-853d-11eb-9098-38d6f6c3c1da.png)|

O suporte estendido de cores basicamente se resume ao seguinte:
* O Turbo Vision usou originalmente [atributos de cor do BIOS](https://en.wikipedia.org/wiki/BIOS_color_attributes) armazenados em um `uchar`. `ushort` é usado para representar pares de atributos. Este ainda é o caso ao usar Borland C++.
* Em plataformas modernas, um novo tipo `TColorAttr` foi adicionado, que substitui `uchar`. Ele especifica uma cor de primeiro e segundo plano e um estilo. As cores podem ser especificadas em diferentes formatos (atributos de cor do BIOS, RGB de 24 bits...). Os estilos são os típicos (negrito, itálico, sublinhado...). Há também `TAttrPair`, que substitui `ushort`.
* Os métodos `TDrawBuffer`, que costumavam usar os parâmetros `uchar` ou `ushort` para especificar atributos de cor, agora usam `TColorAttr` ou `TAttrPair`.
* `TPalette`, que costumava conter uma matriz de `uchar`, agora contém uma matriz de `TColorAttr`. O método `TView::mapColor` também retorna `TColorAttr` em vez de `uchar`.
* `TView::mapColor` foi tornado virtual para que o sistema de paleta possa ser ignorado sem ter que reescrever nenhum método `draw`.
* `TColorAttr` e `TAttrPair` podem ser inicializados com e convertidos em `uchar` e `ushort` de uma forma tal que o código legado ainda compila pronto para uso sem nenhuma alteração na funcionalidade.


Abaixo está uma explicação mais detalhada destinada aos desenvolvedores.

## Tipos de Dados

Em primeiro lugar, explicaremos os tipos de dados que o programador precisa saber para aproveitar o suporte estendido de cores. Para ter acesso a eles, você pode ter que definir a macro `Uses_TColorAttr` antes de incluir `<tvision/tv.h>`.

Todos os tipos descritos nesta seção são *triviais*. Isso significa que eles podem ser `memset`' e `memcpy`'. Mas variáveis ​​desses tipos são *não inicializadas* quando declaradas sem inicializador, assim como tipos primitivos. Portanto, certifique-se de não manipulá-los antes de inicializá-los.

### Tipos de formato de cor

Vários tipos são definidos que representam diferentes formatos de cor.
A razão pela qual esses tipos existem é para permitir distinguir formatos de cor usando o sistema de tipos. Alguns deles também têm campos públicos que facilitam a manipulação de bits individuais.

* `TColorBIOS` representa uma cor do BIOS. Ele permite acessar os bits `r`, `g`, `b` e `bright` individualmente, e pode ser convertido implicitamente em/de `uint8_t`.

	O layout da memória é:

	* Bit 0: Azul (campo `b`).
	* Bit 1: Verde (campo `g`).
	* Bit 2: Vermelho (campo `r`).
	* Bit 3: Brilhante (campo `bright`).
	* Bits 4-7: não utilizados.

	Exemplos de uso de `TColorBIOS`:
    ```c++
    TColorBIOS bios = 0x4;  // 0x4: Vermelho.
    bios.bright = 1;        // 0xC: Vermelho resplandescente.
    bios.b = bios.r;        // 0xD: Magenta resplandescente.
    bios = bios ^ 3;        // 0xE: Amarelo.
    uint8_t c = bios;       // Conversão implícita para tipos inteiros.
    ```

    Em emuladores de terminal, as cores do BIOS são mapeadas para as 16 cores ANSI básicas.

* `TColorRGB` representa uma cor em RGB de 24 bits. Ele permite acessar os campos de bits `r`, `g` e `b` individualmente, e pode ser convertido implicitamente em/de `uint32_t`.

	O layout da memória é:

	* Bits 0-7: Azul (campo `b`).
	* Bits 8-15: Verde (campo `g`).
	* Bits 16-23: Vermelho (campo `r`).
	* Bits 24-31: não utilizado.

    Exemplos de uso de `TColorRGB`:
    ```c++
    TColorRGB rgb = 0x9370DB;   // 0xRRGGBB.
    rgb = {0x93, 0x70, 0xDB};   // {R, G, B}.
    rgb = rgb ^ 0xFFFFFF;       // Negado.
    rgb.g = rgb.r & 0x88;       // Acesso a componentes individuais.
    uint32_t c = rgb;           // Conversão implícita para tipos inteiros.
    ```

* `TColorXTerm` representa um índice na paleta de cores `xterm-256color`. Ele pode ser convertido em e a partir de `uint8_t`.

### `TColorDesired`

`TColorDesired` representa uma cor que o programador pretende mostrar na tela, codificada em qualquer um dos tipos de cores suportados.

Um `TColorDesired` pode ser inicializado das seguintes maneiras:

* Como uma cor do BIOS: com um literal `char` ou um objeto `TColorBIOS`:

    ```c++
    TColorDesired bios1 = '\xF';
    TColorDesired bios2 = TColorBIOS(0xF);
    ```
* Como uma cor RGB: com um literal `int` ou um objeto `TColorRGB`:

    ```c++
    TColorDesired rgb1 = 0xFF7700; // 0xRRGGBB.
    TColorDesired rgb2 = TColorRGB(0xFF, 0x77, 0x00); // {R, G, B}.
    TColorDesired rgb3 = TColorRGB(0xFF7700); // 0xRRGGBB.
    ```
* Como um índice de paleta XTerm: com um objeto `TColorXTerm`.
* Como a cor *padrão do terminal*: por meio de inicialização zero:

    ```c++
    TColorDesired def1 {};
    // Or with 'memset':
    TColorDesired def2;
    memset(&def2, 0, sizeof(def2));
    ```

`TColorDesired` tem métodos para consultar a cor contida, mas normalmente você não precisará usá-los. Veja a definição de struct em `<tvision/colors.h>` para mais informações.

Curiosidade: o nome é inspirado em `ColourDesired` de [Scintilla](https://www.scintilla.org/index.html).

### `TColorAttr`

`TColorAttr` descreve os atributos de cor de uma célula de tela. Este é o tipo com o qual você provavelmente irá interagir se pretender alterar as cores em uma visualização.

Um `TColorAttr` é composto de:

* Uma cor de primeiro plano, do tipo `TColorDesired`.
* Uma cor de fundo, do tipo `TColorDesired`.
* Uma máscara de bits de estilo contendo uma combinação dos seguintes sinalizadores:

    * `slBold`.
    * `slItalic`.
    * `slUnderline`.
    * `slBlink`.
    * `slReverse`.
    * `slStrike`.

    Esses sinalizadores são baseados nos atributos básicos de exibição selecionáveis ​​por meio de [códigos de escape ANSI](https://en.wikipedia.org/wiki/ANSI_escape_code#SGR_(Select_Graphic_Rendition)_parameters). Os resultados podem variar entre emuladores de terminal. `slReverse` é provavelmente o menos confiável deles: prefira usar a função livre `TColorAttr reverseAttribute(TColorAttr attr)` em vez de definir este sinalizador.

A maneira mais direta de criar um `TColorAttr` é por meio dos construtores `TColorAttr(TColorDesired fg, TColorDesired bg, ushort style=0)` e `TColorAttr(int bios)`:

```c++
// Primeiro plano: RGB 0x892312
// Plano de fundo: RGB 0x7F00BB
// Estilo: Normal.
TColorAttr a1 = {TColorRGB(0x89, 0x23, 0x12), TColorRGB(0x7F, 0x00, 0xBB)};

// Primeiro plano: BIOS 0x7.
// Plano de fundo: RGB 0x7F00BB.
// Estilo: Bold, Italic.
TColorAttr a2 = {'\x7', 0x7F00BB, slBold | slItalic};

// Primeiro plano: Terminal default.
// Plano de fundo: BIOS 0xF.
// Estilo: Normal.
TColorAttr a3 = {{}, TColorBIOS(0xF)};

// Primeiro plano: Terminal default.
// Plano de fundo: Terminal default.
// Estilo: Normal.
TColorAttr a4 = {};

// Primeiro plano: BIOS 0x0
// Plano de fundo: BIOS 0x7
// Estilo: Normal
TColorAttr a5 = 0x70;
```

Os campos de um `TColorAttr` podem ser acessados ​​com as seguintes funções gratuitas:

```c++
TColorDesired getFore(const TColorAttr &attr);
TColorDesired getBack(const TColorAttr &attr);
ushort getStyle(const TColorAttr &attr);
void setFore(TColorAttr &attr, TColorDesired fg);
void setBack(TColorAttr &attr, TColorDesired bg);
void setStyle(TColorAttr &attr, ushort style);
```

### `TAttrPair`

`TAttrPair` é um par de `TColorAttr`, usado por algumas funções de API para passar dois atributos de uma vez.

Você pode inicializar um `TAttrPair` com o construtor `TAttrPair(const TColorAttrs &lo, const TColorAttrs &hi)`:

```c++
TColorAttr cNormal = {0x234983, 0x267232};
TColorAttr cHigh = {0x309283, 0x127844};
TAttrPair attrs = {cNormal, cHigh};
TDrawBuffer b;
b.moveCStr(0, "Normal text, ~Highlighted text~", attrs);
```

Os atributos podem ser acessados ​​com os subíndices `[0]` e `[1]`:

```c++
TColorAttr lo   = {0x892343, 0x271274};
TColorAttr hi   = '\x93';
TAttrPair attrs = {lo, hi};
assert(lo == attrs[0]);
assert(hi == attrs[1]);
```

## Alterando a aparência de um `TView`

As visualizações são comumente desenhadas por meio de um `TDrawBuffer`. A maioria das funções membro `TDrawBuffer` recebem atributos de cor por parâmetro. Por exemplo:

```c++
ushort TDrawBuffer::moveStr(ushort indent, TStringView str, TColorAttr attr);
ushort TDrawBuffer::moveCStr(ushort indent, TStringView str, TAttrPair attrs);
void TDrawBuffer::putAttribute(ushort indent, TColorAttr attr);
```

No entanto, as visualizações fornecidas com o Turbo Vision geralmente armazenam suas informações de cor em paletas. A paleta de uma visualização pode ser consultada com as seguintes funções de membro:

```c++
TColorAttr TView::mapColor(uchar index);
TAttrPair TView::getColor(ushort indices);
```

* `mapColor` procura um único atributo de cor na paleta da visualização, dado um índice na paleta. Lembre-se de que os índices de paleta para cada classe de visualização podem ser encontrados nos cabeçalhos do Turbo Vision. Por exemplo, `<tvision/views.h>` diz o seguinte sobre `TScrollBar`:

    ```c++
    /* ---------------------------------------------------------------------- */
    /*      classe TScrollBar                                                 */
    /*                                                                        */
    /*      Layout da Paleta                                                  */
    /*        1 = Page areas                                                  */
    /*        2 = Arrows                                                      */
    /*        3 = Indicator                                                   */
    /* ---------------------------------------------------------------------- */
    ```

* `getColor` é uma função auxiliar que permite consultar dois atributos de célula de uma só vez. Cada byte no parâmetro `indices` contém um índice na paleta. O resultado `TAttrPair` contém os dois atributos de célula.

Por exemplo, o seguinte pode ser encontrado no método `draw` de `TMenuBar`:

    ```c++
    TAttrPair cNormal = getColor(0x0301);
    TAttrPair cSelect = getColor(0x0604);
    ```

    O que seria equivalente a isto:

    ```c++
    TAttrPair cNormal = {mapColor(1), mapColor(3)};
    TAttrPair cSelect = {mapColor(4), mapColor(6)};
    ```

Como uma extensão de API, o método `mapColor` foi tornado `virtual`. Isso torna possível substituir o sistema de paleta hierárquica do Turbo Vision por uma solução personalizada sem precisar reescrever o método `draw()`.

Então, em geral, há três maneiras de usar cores estendidas em visualizações:

1. Retornando atributos de cor estendidos de um método `mapColor` substituído:

```c++
// A classe 'TMyScrollBar' herda de 'TScrollBar' e substitui 'TView::mapColor'.
TColorAttr TMyScrollBar::mapColor(uchar index) noexcept
{
	// Neste exemplo, os valores são codificados,
	// mas eles podem ser armazenados em outro lugar, se desejado.
    switch (index)
    {
        case 1:     return {0x492983, 0x826124}; // Page areas.
        case 2:     return {0x438939, 0x091297}; // Arrows.
        case 3:     return {0x123783, 0x329812}; // Indicator.
        default:    return errorAttr;
    }
}
```

2. Fornecendo atributos de cor estendidos diretamente para métodos `TDrawBuffer`, se o sistema de paleta não estiver sendo usado. Por exemplo:

    ```c++
	// A classe 'TMyView' herda de 'TView' e substitui 'TView::draw'.
    void TMyView::draw()
    {
        TDrawBuffer b;
        TColorAttr color {0x1F1C1B, 0xFAFAFA, slBold};
        b.moveStr(0, "Isto é texto preto em negrito sobre um fundo branco", color);
        /* ... */
    }
    ```

3. Modificando as paletas. Há duas maneiras de fazer isso:

    1. Modificando a paleta do aplicativo após ela ter sido construída. Note que os elementos da paleta são `TColorAttr`. Por exemplo:

    ```c++
    void updateAppPalette()
    {
        TPalette &pal = TProgram::application->getPalete();
        pal[1] = {0x762892, 0x828712};              // TBackground.
        pal[2] = {0x874832, 0x249838, slBold};      // TMenuView texto normal.
        pal[3] = {{}, {}, slItalic | slUnderline};  // TMenuView texto desabilitado.
        /* ... */
    }
    ```

	2. Usando atributos de cor estendidos na definição da paleta do aplicativo:

    ```c++
    static const TColorAttr cpMyApp[] =
    {
        {0x762892, 0x828712},               // TBackground.
        {0x874832, 0x249838, slBold},       // TMenuView texto normal.
        {{}, {}, slItalic | slUnderline},   // TMenuView texto desabilitado.
        /* ... */
    };

    // A classe 'TMyApp' herda de 'TApplication' e substitui 'TView::getPalette'.
    TPalette &TMyApp::getPalette() const
    {
        static TPalette palette(cpMyApp);
        return palette;
    }
    ```

## Capacidades de exibição

`TScreen::screenMode` expõe algumas informações sobre o suporte de cores da exibição:

* Se `(TScreen::screenMode & 0xFF) == TDisplay::smMono`, a exibição é monocolorida (relevante apenas no DOS).
* Se `(TScreen::screenMode & 0xFF) == TDisplay::smBW80`, a exibição é em tons de cinza (relevante apenas no DOS).
* Se `(TScreen::screenMode & 0xFF) == TDisplay::smCO80`, a exibição suporta pelo menos 16 cores.
	* Se `TScreen::screenMode & TDisplay::smColor256`, o display suporta pelo menos 256 cores.
	* Se `TScreen::screenMode & TDisplay::smColorHigh`, o display suporta ainda mais cores (por exemplo, cor de 24 bits). `TDisplay::smColor256` também é definido neste caso.

## Compatibilidade com versões anteriores de tipos de cores

Os tipos definidos anteriormente representam conceitos que também são importantes no desenvolvimento para Borland C++:

| Conceito | Layout em Borland C++ | Layout em plataformas modernas |
|:-:|:-:|:-:|
| Atributo de cor | `uchar`. Um atributo de cor do BIOS. | `struct TColorAttr`. |
| Cor | Um número de 4 bits. | `struct TColorDesired`. |
| Par de atributos | `ushort`. Um atributo em cada byte. | `struct TAttrPair`. |


Um dos princípios-chave deste projeto é que a API deve ser usada da mesma forma tanto no Borland C++ quanto em plataformas modernas, ou seja, sem a necessidade de `#ifdef`s. Outro princípio é que o código legado deve ser compilado pronto para uso, e adaptá-lo aos novos recursos deve aumentar a complexidade o mínimo possível.

A compatibilidade com versões anteriores é realizada da seguinte forma:

* No Borland C++, `TColorAttr` e `TAttrPair` são `typedef`'d para `uchar` e `ushort`, respectivamente.
* Em plataformas modernas, `TColorAttr` e `TAttrPair` podem ser usados ​​no lugar de `uchar` e `ushort`, respectivamente, já que eles são capazes de manter qualquer valor que se encaixe neles e podem ser convertidos implicitamente para/a partir deles.

	Um `TColorAttr` inicializado com `uchar` representa um atributo de cor do BIOS. Ao converter de volta para `uchar`, acontece o seguinte:

	* Se `fg` e `bg` forem cores do BIOS, e `style` estiver limpo, o `uchar` resultante representa o mesmo atributo de cor do BIOS contido no `TColorAttr` (como no código acima).
	* Caso contrário, a conversão resulta em um atributo de cor que se destaca, ou seja, branco em magenta, o que significa que o programador deve considerar substituir `uchar`/`ushort` por `TColorAttr`/`TAttrPair` se pretender oferecer suporte aos atributos de cor estendidos.

	O mesmo vale para `TAttrPair` e `ushort`, considerando que ele é composto de dois `TColorAttr`.

Um caso de uso de compatibilidade com versões anteriores dentro do próprio Turbo Vision é a classe `TPalette`, núcleo do sistema de paletas. Em seu design original, ele usava um único tipo de dados (`uchar`) para representar coisas diferentes: comprimento do array, índices de paleta ou atributos de cor.

O novo design simplesmente substitui `uchar` por `TColorAttr`. Isso significa que não há mudanças na maneira como `TPalette` é usado, mas `TPalette` agora é capaz de armazenar atributos de cor estendidos.

`TColorDialog` não foi remodelado e, portanto, não pode ser usado para escolher atributos de cor estendidos em tempo de execução.


### Exemplo: adicionando suporte de cor estendido ao código legado

O seguinte padrão de código é comum em métodos `draw` de visualizações:

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

Neste caso, `ushort` é usado tanto como um par de índices de paleta quanto como um par de atributos de cor. `getColor` agora retorna um `TAttrPair`, então, mesmo que isso seja compilado pronto para uso, atributos estendidos serão perdidos na conversão implícita para `ushort`.

O código acima ainda funciona exatamente como funcionava originalmente. São apenas atributos de cor não-BIOS que não produzem o resultado esperado. Devido à compatibilidade entre `TAttrPair` e `ushort`, o seguinte é suficiente para habilitar o suporte para atributos de cor estendidos:


```diff
-    ushort cFrame, cTitle;
+    TAttrPair cFrame, cTitle;
```

Nada impede que você use variáveis ​​diferentes para índices de paleta e atributos de cor, que é o que realmente deveria ser feito. O ponto da compatibilidade com versões anteriores é a capacidade de suportar novos recursos sem alterar a lógica do programa, ou seja, minimizar o risco de aumentar a complexidade do código ou introduzir bugs.
