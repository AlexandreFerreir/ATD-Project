% Pasta com os sinais de áudio
pasta = 'C:\Users\Asus\Desktop\ATD\Projeto\AudioMNIST-ATD2022_23\AudioMNIST-master\data\57';

% Obter o nome do arquivo do sinal de áudio que começa com "0"
arquivos = dir(fullfile(pasta, '9*.wav'));
if isempty(arquivos)
    error('Nenhum arquivo encontrado com nome começado por "0".');
end
nomeArquivo = arquivos(1).name;

% Caminho completo para o arquivo do sinal de áudio
caminhoArquivo = fullfile(pasta, nomeArquivo);

% Ler o sinal de áudio
[sinal, fs] = audioread(caminhoArquivo);

% Parâmetros da STFT
tamanhoFFT = 1024; % Tamanho da FFT
sobreposicao = 0.75; % Porcentagem de sobreposição (ajuste conforme necessário)

tamanhoFFT = 256; % Tamanho da FFT
sobreposicao = 0.75; % Porcentagem de sobreposição
subplot(1, 1, 1);
spectrogram(sinal, hamming(tamanhoFFT), round(sobreposicao * tamanhoFFT), tamanhoFFT, fs, 'yaxis');
digit = nomeArquivo(1); % Extrai o dígito do nome do arquivo
title(['STFT - Dígito: ' digit]);
