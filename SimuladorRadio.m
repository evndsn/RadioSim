% Reset do MATLAB
clc, clear('variables'); close('all');
%% principais parametros
fs = 44100;                          % frequencia de amostragem [Amostras/segundo]
T = 10;                              % O tempo de duração de cada audio [segundo]
BW = 3000;							 % Largura de banda de cada audio [Hz]
N = 3;								 % Quantidade de audios a serem gravados

%% Cria o objeto gravador
gravador = audiorecorder(fs, 16, 1); % objeto gravador do matlab

%% Cria um filtro tipo passa-baixas e armazena seus coeficientes em 'a' e 'b'.
[b, a] = butter(10, BW*2/fs); % A frequência de corte é a largura de banda BW

% Cria a variável que armazenará o sinal a ser transmitido
Tx = zeros(1, T*fs);

% Vetor do tempo
t = 0:T/(T*fs-1):T;

%% Do Transmissor
%%= Grava N audios diferentes
for i = 1:N
    
    % Indica para gravar audio da rádio
    disp(['Radio ', num2str(i), ' no ar (gravando)']);
    
    % Grava o audio de T segundos
    record(gravador, T);
    pause(T + 1);									% Espera até que o audio seja completamente gravado
    
    % Salva os resultados na variável radio.x
    radio(i).x  = getaudiodata(gravador)';
   
	% Filtra o sinal e salva na variável radio.y
	radio(i).y  =  filter(b, a, radio(i).x);
    
	close('all');
	% Visualiza o espectro antes e depois da filtragem	
	fvtool(radio(1).x, 1, 'Fs', fs, 'Analysis', 'magnitude', 'MagnitudeDisplay', 'Magnitude'); title('Audio não filtrado');
	% fvtool(b, a, 'Fs', fs, 'Analysis', 'magnitude', 'MagnitudeDisplay', 'Magnitude'); title('Filtro de butterworth');
	fvtool(radio(1).y, 1, 'Fs', fs, 'Analysis', 'magnitude', 'MagnitudeDisplay', 'Magnitude'); title('Audio filtrado');

	% Permite escutar o audio filtrado
	% sound(radio(1).y, fs);
	% pause(T + 1)
    
    % Pergunta em qual frequência pretende modular para o canal
	P=input(sprintf('Portadora [escolha entre %d e %d]: ', BW/2, (fs-BW)/2));
    Tx = Tx + radio(i).y .* cos(2 * pi * P * t);

end

% Mensagem e informações úteis
disp('Tocando e exibindo o espectro completo');
close('all');
sound(Tx, fs);

% Vamos visualizar também
fvtool(Tx, 1, 'Fs', fs, 'Analysis', 'magnitude', 'MagnitudeDisplay', 'Magnitude'); title('Espectro com as 3 rádios');

%% Recebimento

disp('Sintonizando na rádio R');
disp('Enter para sintonizar na rádio R e ouvir');
pause;
R = 12000; % Portadora que deseja sintonizar

% Lembrando que temos um sinal X de interesse que foi modulado com cos(7kHz)
% se multiplicarmos novamente pelo cos(7kHz) teremos:
% X * cos(7kHz) * cos(7kHz)
% Lembrando: cos(a-b) = cos(a)*cos(b) + sen(a)*sen(b)
% fazendo: a = b = 7 kHz
% cos(7kHz)*cos(7kHz) = cos(7kHz-7kHz) - sen(7kHz)*sen(7kHz)
% Se multiplicar ambos os lados por X, teremos:
% X*cos(7kHz)*cos(7kHz) = X*cos(0) - X*sen(7kHz)*sen(7kHz)
% Sabendo que cos(0) = 1, ficamos com:
% X*cos(7kHz)*cos(7kHz) = X - X*sen(7kHz)*sen(7kHz)
% Se passarmos o sinal por um filtro passa-baixas, a parte de alta
% frequência com sen(7kHz) vai embora... e ficamos com:
% FiltroPB(X*cos(7khz)*cos(7khz)) = X (nosso sinal original).

Rx = filter(b, a, Tx .* cos(2*pi*t*R));

% Vamos escutar?
sound(Rx./max(Rx), fs);