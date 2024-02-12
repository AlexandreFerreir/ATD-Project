% Pasta onde os sinais de áudio estão localizados
pasta = 'C:\Users\Asus\Desktop\ATD\Projeto\AudioMNIST-ATD2022_23\AudioMNIST-master\data\57';

%ESCOLHER DIGITO AQUI 
% Obter lista de arquivos na pasta
arquivos = dir(fullfile(pasta, '9*.wav'));

% Número total de arquivos
numArquivos = length(arquivos);

% Variáveis para armazenar os sinais de áudio
sinais = cell(1, numArquivos);
tamanhoSinal = length(sinais{1});

% Carregar os sinais de áudio e verificar o tamanho máximo
for i = 1:numArquivos
    arquivo = fullfile(pasta, arquivos(i).name);
    sinal = audioread(arquivo);
    sinais{i} = sinal;
    tamanhoSinal = max(tamanhoSinal, length(sinal));
end

% Preencher os sinais com zero para ter o mesmo tamanho
for i = 1:numArquivos
    sinal = sinais{i};
    sinais{i} = [sinal; zeros(tamanhoSinal - length(sinal), 1)];
end

% Calcular a média dos sinais de áudio
somaSinais = sum(cat(2, sinais{:}), 2);
mediaSinais = somaSinais / numArquivos;

% Calcular o espectro de amplitude mediano para cada dígito
espectros = zeros(numArquivos, ceil(tamanhoSinal/2) + 1);

for i = 1:numArquivos
    sinal = sinais{i};
    espectro = abs(fft(sinal));
    espectros(i, :) = espectro(1:ceil(length(sinal)/2) + 1);
end

% Calcular a mediana, primeiro quartil e terceiro quartil para cada frequência
mediana = median(espectros);
primeiroQuartil = prctile(espectros, 25);
terceiroQuartil = prctile(espectros, 75);

% Normalizar pelo número de amostras
espectrosNormalizados = espectros / tamanhoSinal;

% Dígito sendo processado
digitoAtual = arquivos(1).name(1);

% Plotar o resultado com diferentes janelas
frequencias = linspace(0, 1, ceil(tamanhoSinal/2) + 1) * (8000/2);

amplitudeNormalizada = espectrosNormalizados / tamanhoSinal;

figure;
hold on;
plot(frequencias, mediana / tamanhoSinal);
plot(frequencias, primeiroQuartil / tamanhoSinal);
plot(frequencias, terceiroQuartil / tamanhoSinal);
legend('Espectro mediano normalizado', 'Primeiro quartil', 'Terceiro quartil');
xlabel('Frequência (Hz)');
ylabel('Amplitude (normalizada)');
title(['Espectro mediano normalizado e quartis - Dígito: ' digitoAtual]);
xlim([0 8000]); % Define o limite do eixo x de 0 a 8 kHz
hold off;

% Janela retangular
janelaRetangular = rectwin(tamanhoSinal);
janelaRetangular = janelaRetangular(1:ceil(tamanhoSinal/2) + 1);
espectrosRetangular = espectros .* janelaRetangular';
medianaRetangular = median(espectrosRetangular);
primeiroQuartilRetangular = prctile(espectrosRetangular, 25);
terceiroQuartilRetangular = prctile(espectrosRetangular, 75);

% Janela Hann
janelaHann = hann(tamanhoSinal);
janelaHann = janelaHann(1:ceil(tamanhoSinal/2) + 1);
espectrosHann = espectros .* janelaHann';
medianaHann = median(espectrosHann);
primeiroQuartilHann = prctile(espectrosHann, 25);
terceiroQuartilHann = prctile(espectrosHann, 75);

% Janela Hamming
janelaHamming = hamming(tamanhoSinal);
janelaHamming = janelaHamming(1:ceil(tamanhoSinal/2) + 1);
espectrosHamming = espectros .* janelaHamming';
medianaHamming = median(espectrosHamming);
primeiroQuartilHamming = prctile(espectrosHamming, 25);
terceiroQuartilHamming = prctile(espectrosHamming, 75);

% Janela Blackman
janelaBlackman = blackman(tamanhoSinal);
janelaBlackman = janelaBlackman(1:ceil(tamanhoSinal/2) + 1);
espectrosBlackman = espectros .* janelaBlackman';
medianaBlackman = median(espectrosBlackman);
primeiroQuartilBlackman = prctile(espectrosBlackman, 25);
terceiroQuartilBlackman = prctile(espectrosBlackman, 75);

% Plotar os resultados
figure;
hold on;
plot(frequencias, medianaRetangular / tamanhoSinal);
plot(frequencias, medianaHann / tamanhoSinal);
plot(frequencias, medianaHamming / tamanhoSinal);
plot(frequencias, medianaBlackman / tamanhoSinal);
legend('Retangular', 'Hann', 'Hamming', 'Blackman');
xlabel('Frequência (Hz)');
ylabel('Amplitude (normalizada)');
title(['Janelas - Dígito: ' digitoAtual]);
xlim([0 8000]); % Define o limite do eixo x de 0 a 8 kHz
hold off;
