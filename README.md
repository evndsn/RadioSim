# RadioSimMatLAB
Simulador de uma transmissão de rádio

Este projeto apresenta um exemplo de um simulador de radio, ilustrando a utilização do espectro.

## Como funciona?
Cada rádio possui uma frequência principal conhecido como portadora e uma largura de banda de transmissão. As informações são enviadas utilizando a modulação em amplitude ou em frequência. Neste caso, o arquivo simula a junção de 3 rádios contendo o transmissor e o receptor.

## Transmissor
No transmissor teremos a gravação de 3 audios diferentes, que serão transmitidos por intermédio deu ma portadora de pseudo-alto frequência. Pseudo, pois é apenas uma simulação.

O transmissor é dividido nas seguintes etapas:
1. É gravado um arquivo de audio utilizando de duração **T** segundos e taxa de amostragem **fs** amostras por segundo;
2. Cada audio é filtrado por um filtro passa-baixas, com finalidade de garantir a uma largura máxima de banda **BW**;
3. Os audios são então multiplicados por um sinal senoidal, que acaba por deslocar o espectro no eixo da frequência (propriedade de Fourier);
4. Todos os audios filtrados e deslocados na frequência são somados em um único audio que será transmtido.

## Receptor
O receptor de audio consiste em utilizar as relações trigonométricas para separar o arquivo de audio original.
Para que ocorra a demodulação, basta multiplicar o sinal original que contém todos os audios pela mesma onda senoidal, com mesma frequência e fase e passar por um filtro passa-baixas.

### Matemática por trás da coisa.
Considere que o sinal da radio de interesse é representado por:

<img src="https://render.githubusercontent.com/render/math?math=Rx = Y {cos(2\pi\cdot 7000\cdot t)} %2B G">

Em que Rx é o sinal recebido, Y é o sinal de interesse e G é um sinal indesejado de frequência diferente de 7 kHz.

Se multiplicarmos o sinal recebido Rx por <img src="https://render.githubusercontent.com/render/math?math=cos(2\pi\cdot 7000\cdot t)">, ficamos com:

<img src="https://render.githubusercontent.com/render/math?math=Rx\cdot {cos(2\pi\cdot 7000\cdot t)} = Y {cos^2{(2\pi\cdot 7000\cdot t)}} %2B G\cdot {cos(2\pi\cdot 7000\cdot t)}">

Lembrando da relação matemática:
<img src="https://render.githubusercontent.com/render/math?math=cos^2(a) %2B sin^2(a) = 1 \rightarrow  cos^2(a) = 1 - sin^2(a)"> e substituindo:

<img src="https://render.githubusercontent.com/render/math?math=Rx\cdot {cos(2\pi\cdot 7000\cdot t)} = Y (1 - sin^2(2\pi\cdot 7000\cdot t)) %2B G\cdot {cos(2\pi\cdot 7000\cdot t)}">

ou

<img src="https://render.githubusercontent.com/render/math?math=Rx\cdot {cos(2\pi\cdot 7000\cdot t)} = Y - Y\cdot sin^2(2\pi\cdot 7000\cdot t) %2B G\cdot {cos(2\pi\cdot 7000\cdot t)}">

Passando ambos os termos por um Filtro Passa-Baixas <img src="https://render.githubusercontent.com/render/math?math=f_{pb}(\cdot)"> com frequência de corte de 7 kHz

<img src="https://render.githubusercontent.com/render/math?math=f_{pb}(Rx\cdot {cos(2\pi\cdot 7000\cdot t)}) = f_{pb}(Y - Y\cdot sin^2(2\pi\cdot 7000\cdot t) %2B G\cdot {cos(2\pi\cdot 7000\cdot t)})">

As partes de alta frequência tornam-se zero.

<img src="https://render.githubusercontent.com/render/math?math=f_{pb}(Rx\cdot {cos(2\pi\cdot 7000\cdot t)}) = Y">

Conclusão:
Para demodular o sinal original, basta multiplicar pela mesma base trigonométrica original e aplicar um filtro passa-baixas.
