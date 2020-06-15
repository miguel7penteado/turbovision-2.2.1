# Biblioteca C++ Borland Turbo Vision versão 2.2.1
## A biblioteca para fazer "telas texto" do "modo DOS"
[![Linkedin](https://i.stack.imgur.com/gVE0j.png) LinkedIn](https://www.linkedin.com/in/miguel-penteado-760486a9/)
&nbsp;
[![GitHub](https://i.stack.imgur.com/tskMh.png) GitHub](https://github.com/miguel7penteado)

# Documentação do projeto

Site está em [!http://miguel7penteado@github.io/turbovision-2.2.1](http://miguel7penteado@github.io/turbovision-2.2.1)

## Criando Documentação
```bash
# Clone o repositório remoto
git clone <endereço_repositorio_github>

# Adicione o ramo de páginas do projeto
# no github o nome padrão é gh-pages
git checkout --orphan gh-pages

# apague a cópia dos arquivos que existe nesse ramo (rascunho)
git rm -rf .

# apague o arquivo de ignorações
rm '.gitignore'

# Crie seus arquivos
gitbook init

# edite os modelos

# Gere a estrutura html
gitbook install && gitbook build

# adicione tudo que você criou
git add -A

# Dê o nome para sua atualização
git commit -a -m "Publicação Inicial"

# Mande o ramo de volta para o repositório github
git push -u origin gh-pages

# volte para o tronco principal (ramo master)
git checkout master
```
## Atualizando a Documentação

```bash
# Clone o repositório remoto
git clone <endereço_repositorio_github>

# entre no ramo gh-pages para atualizar a documentação
git checkout gh-pages

# faça suas atualizações

# Gere a estrutura html
gitbook install && gitbook build

# adicione tudo que você criou
git add -A

# Dê o nome para sua atualização
git commit -a -m "Publicação Inicial"

# Mande o ramo de volta para o repositório github
git push -u origin gh-pages

```

### Navegadores FrameBuffer Linux
*- links2
```bash
sudo gpm -m /dev/input/mice -t imps2 -d 2 -a 3
links2 -driver fb
```
*- netsurf
```bash
netsurf
```

## A fazer
Certificar o funcionamento em todos os modos de tela

CGA 640×200, 16,    4:5

EGA 640×350, 16bpp, 1:1,37

VGA 640x480, 32bpp, 4:3

SVGA 800x600, 32bpp, 4:3

XGA 1024x768, 32bpp, 4:3

XGA+ 1152x864, 32bpp, 4:3

HD 1280x720, 32bpp, 16:9

WXGA 1280x800, 32bpp, 16:10

SXGA 1280x1024, 32bpp, 5:4

SXGA+ 1400x1050, 32bpp, 4:3

WXGA+ 1440x900, 32bpp, 16:10

HD+ 1600x900, 32bpp, 16:9

UXGA 1600x1200, 32bpp, 4:3

WSXGA+ 1680x1050, 32bpp, 16:10

Full HD 1920x1080, 32bpp, 16:9

WUXGA 1920x1200, 32bpp, 16:10

DCI 2K 2048x1080, 32bpp, 19:10

Full HD+ 2160x1440, 32bpp, 3:2

Unnamed 2304x1440, 32bpp, 16:10

QHD 2560x1440, 32bpp, 16:9

WQXGA 2560x1600, 32bpp, 16:10

QWXGA+ 2880x1800, 32bpp, 16:10

QHD+ 3200x1800, 32bpp, 16:9

WQSXGA 3200x2048, 32bpp, 16:10

4K UHD 3840x2160, 32bpp, 16:9

WQUXGA 3840x2400, 32bpp, 16:10

DCI 4K 4096x2160, 32bpp, 19:10

HXGA 4096x3072, 32bpp, 4:3

UHD+ 5120x2880, 32bpp, 16:9

WHXGA 5120x3200, 32bpp, 16:10

WHSXGA 6400x4096, 32bpp, 16:10

HUXGA 6400x4800, 32bpp, 4:3

8K UHD2 7680x4320, 32bpp, 16:9
