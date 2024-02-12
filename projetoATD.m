% Adicione a seguinte linha no início do script para habilitar as funções necessárias
addpath('C:\Users\Asus\Desktop\ATD\Projeto\AudioMNIST-ATD2022_23\AudioMNIST-master\data\57'); % Substitua pelo caminho para a sua Signal Processing Toolbox

% Caminho para o diretório com os arquivos de áudio
diretorio = 'C:\Users\Asus\Desktop\ATD\Projeto\AudioMNIST-ATD2022_23\AudioMNIST-master\data\57';


% Obter todos os arquivos .wav no diretório
arquivos = dir(fullfile(diretorio, '*.wav'));
audio_files = cell(length(arquivos), 1);
digit_labels = zeros(length(arquivos), 1);

% Iterar sobre os arquivos e obter os nomes e rótulos
for i = 1:length(arquivos)
    audio_files{i} = fullfile(diretorio, arquivos(i).name);
    digit_labels(i) = str2double(arquivos(i).name(1)); % Assumindo que o rótulo do dígito está na posição 1 do nome do arquivo
end

% Célula para armazenar os sinais importados
audio_signals = {};

for i = 1:length(audio_files)
    [signal, sr] = audioread(audio_files{i});
    audio_signals{i} = signal;
end

num_digits = 10; % Número total de dígitos
num_samples_per_digit = 50; % Número de amostras por dígito

% Célula para armazenar os sinais médios por dígito
average_signals = cell(num_digits, 1);

% Calcular o sinal médio para cada dígito
for i = 1:num_digits
    digit_signals = audio_signals(digit_labels == (i-1));
    num_digit_samples = min(num_samples_per_digit, length(digit_signals));
    digit_samples = digit_signals(1:num_digit_samples);
    
    % Obter o comprimento mínimo entre os sinais
    min_length = min(cellfun(@length, digit_samples));
    
    % Inicializar matriz para armazenar os sinais de mesmo comprimento
    digit_signals_matrix = zeros(min_length, num_digit_samples);
    
    % Preencher a matriz com os sinais de mesmo comprimento
    for j = 1:num_digit_samples
        digit_signals_matrix(:, j) = digit_samples{j}(1:min_length);
    end
    
    % Calcular a média dos sinais
    average_signal = mean(digit_signals_matrix, 2);
    
    % Armazenar o sinal médio do dígito
    average_signals{i} = average_signal;
    
    % Plotar o sinal médio do dígito
    time = (0:length(average_signal)-1) / sr; % Vetor de tempo em segundos
    figure;
    plot(time, average_signal);
    xlabel('Tempo (s)');
    ylabel('Amplitude');
    title(['Sinal Médio do Dígito ', num2str(i-1)]);
end

% Calculate the energy and maximum amplitude for each digit
energy = zeros(10, 1);
max_amplitude = zeros(10, 1);

% Calculate the additional features for each digit
zero_crossing_rate = zeros(10, 1);
spectral_centroid = zeros(10, 1);
spectral_bandwidth = zeros(10, 1);
spectral_slope = zeros(10, 1);

for i = 1:10
    digit_samples = audio_signals(digit_labels == (i-1));
    num_digit_samples = min(num_samples_per_digit, length(digit_samples));
    digit_samples = digit_samples(1:num_digit_samples);
    
    % Calculate energy and maximum amplitude
    energy(i) = sum(cellfun(@(x) sum(x.^2), digit_samples));
    max_amplitude(i) = max(cellfun(@(x) max(abs(x)), digit_samples));
    
    % Calculate Zero Crossing Rate
    zero_crossings = sum(cellfun(@(x) sum(abs(diff(x > 0))), digit_samples));
    zero_crossing_rate(i) = zero_crossings / sum(cellfun(@length, digit_samples));
    
    % Calculate Spectral Centroid, Spectral Bandwidth, and Spectral Slope
    for j = 1:num_digit_samples
        [pxx, f] = periodogram(digit_samples{j}, [], [], sr);
        spectral_centroid(i) = spectral_centroid(i) + sum(pxx .* f) / sum(pxx);
        spectral_bandwidth(i) = spectral_bandwidth(i) + sqrt(sum(pxx .* (f - spectral_centroid(i)).^2) / sum(pxx));
        spectral_slope(i) = spectral_slope(i) + sum(pxx .* f.^2) / sum(pxx);
    end
    spectral_centroid(i) = spectral_centroid(i) / num_digit_samples;
    spectral_bandwidth(i) = spectral_bandwidth(i) / num_digit_samples;
    spectral_slope(i) = spectral_slope(i) / num_digit_samples;
end

% Plot the energy for each digit
figure;
bar(0:9, energy);
xlabel('Dígito');
ylabel('Energia');
title('Energia de Cada Dígito');

% Plot the maximum amplitude for each digit
figure;
bar(0:9, max_amplitude);
xlabel('Dígito');
ylabel('Amplitude Máxima');
title('Amplitude Máxima de Cada Dígito');

% Plot the Zero Crossing Rate for each digit
figure;
bar(0:9, zero_crossing_rate);
xlabel('Dígito');
ylabel('Taxa de Cruzamento por Zero');
title('Zero Crossing Rate de Cada Dígito');

% Plot the Spectral Centroid for each digit
figure;
bar(0:9, spectral_centroid);
xlabel('Dígito');
ylabel('Centroide Espectral');
title('Spectral Centroid de Cada Dígito');

% Plot the Spectral Slope for each digit
figure;
bar(0:9, spectral_slope);
xlabel('Dígito');
ylabel('Declive Espectral');
title('Spectral Slope de Cada Dígito');

figure;
scatter3(energy, max_amplitude, spectral_centroid, 50, 0:9, 'filled');
xlabel('Energia');
ylabel('Amplitude Máxima');
zlabel('Spectral Centroid');
title('Superficies de Divisão');
cb = colorbar;
cb.Ticks = 0:9;
cb.TickLabels = cellstr(num2str((0:9)'));









