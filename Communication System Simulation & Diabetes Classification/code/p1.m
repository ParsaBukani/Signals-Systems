clc, clearvars, close all;

% Exercise 1-1: Creating Mapset

Nch = 32;
mapset = cell(2, Nch);
Alphabet = 'abcdefghijklmnopqrstuvwxyz .,!";';

for i = 1:Nch
    mapset{1,i} = Alphabet(i);
    mapset{2,i} = dec2bin(i-1, 5);
end

% Exercise 1-2: Amplitude Coding Function

function binarizedMessage = message2binary(message, mapset)

binarizedMessage = '';

for charInMessage = message
    found = false;

    for j = 1:size(mapset,2)
        if charInMessage == mapset{1,j}
            binarizedMessage = [binarizedMessage, mapset{2,j}];
            found = true;
            break;
        end
    end

    if ~found
        fprintf('Character "%c" not found in mapset.\n', charInMessage);
    end
end
end



function codedMessage = amp_coding(message, bitrate, mapset)

% --- Convert to binary ---
binMessage = message2binary(message, mapset);

% --- Pad with ';' exactly like the sample solution ---
while mod(length(binMessage), bitrate) ~= 0
    message = [message, ';'];
    binMessage = message2binary(message, mapset);
end

% --- Setup ---
fs = 100;
t = 0:1/fs:1-1/fs;
codedMessage = [];

% --- Encode groups ---
for i = 1:bitrate:length(binMessage)
    bits = binMessage(i:i+bitrate-1);

    alpha = bin2dec(bits) / (2^bitrate - 1);
    signal = alpha * sin(2*pi*t);

    codedMessage = [codedMessage, signal];
end

end


% Exercise 1-3: Plotting

message = 'signal';
fs = 100;

figure('Position', [200,200,900,700]);
coded = cell(1,3);

for bitrate = 1:3
    coded{bitrate} = amp_coding(message, bitrate, mapset);

    t = 0:(1/fs):(length(coded{bitrate})/fs)-(1/fs);

    subplot(3,1,bitrate);
    plot(t, coded{bitrate}, 'LineWidth', 1.8);
    title(['Bitrate = ', num2str(bitrate), ' bit/s']);
    xlabel('Time (s)');
    ylabel('Amplitude');
    ylim([-1.2, 1.2]);
end

% EXERCISE 1-4 — amp_decoding FUNCTION

function correlation = corr(a, b)
    correlation = 0.01 * dot(a, b);
    correlation = max(0, correlation);   % clamp to [0,1]
    correlation = min(1, correlation);
end

function character = getCharacter(binary, mapset)

    for j = 1:size(mapset,2)
        if strcmp(mapset{2,j}, binary)
            character = mapset{1,j};
            return;
        end
    end

    character = '?'; % fallback (should not happen)
end

function decodedMessage = amp_decoding(codedMessage, bitrate, mapset)

fs = 100;
t = 0:1/fs:1-1/fs;
template = 2 * sin(2*pi*t);

binarizedMessage = '';
decodedMessage = '';

% Number of symbols in signal
numSymbols = length(codedMessage) / fs;

% Decode each 1-second segment
for i = 1:numSymbols
    segment = codedMessage((i-1)*fs + 1 : i*fs);
    c = corr(segment, template);

    % Check which amplitude it belongs to
    for j = 0:(2^bitrate - 1)
        center = j / (2^bitrate - 1);
        tol = 0.5 / (2^bitrate - 1);

        if center - tol <= c && c <= center + tol
            binarizedMessage = [binarizedMessage, dec2bin(j, bitrate)];
            break;
        end
    end
end

% Convert binary → characters (5 bits each)
for k = 1:5:length(binarizedMessage)
    character = getCharacter(binarizedMessage(k:k+4), mapset);
    decodedMessage = [decodedMessage, character];
end

end

for bitrate = 1:3
    decodedMessage = amp_decoding(coded{bitrate}, bitrate, mapset);
    fprintf('Bitrate %d → Decoded Message: %s\n', bitrate, decodedMessage);
end



% Exercise 1-5: Properties of randn

noise = randn(1,3000);

% Compute statistics
noise_mean = mean(noise);
noise_var  = var(noise);

fprintf("Mean  = %.4f\n", noise_mean);
fprintf("Var   = %.4f\n", noise_var);

% Plot histogram to show Gaussian shape
figure;
histogram(noise, 40, 'Normalization', 'pdf');
title('Histogram of randn(1,3000)');
xlabel('Value'); ylabel('PDF');

% Overlay theoretical Gaussian curve
hold on;
x = linspace(-4,4,200);
plot(x, normpdf(x, 0, 1), 'r', 'LineWidth', 2);
legend('Empirical PDF', 'Gaussian N(0,1)');


% Exercise 1-6: Add Gaussian Noise (var = 0.0001)

message = 'signal';
fs = 100;
std_noise = 0.01;

coded = cell(1,3);
noisy = cell(1,3);

for bitrate = 1:3
    
    % Encode
    coded{bitrate} = amp_coding(message, bitrate, mapset);

    % Generate noise
    noise = std_noise * randn(1, length(coded{bitrate}));

    % Add noise
    noisy{bitrate} = coded{bitrate} + noise;

    t = 0:1/fs:(length(noisy{bitrate})/fs - 1/fs);

    figure('Position',[200,200,1200,450]);
    subplot(2,1,1)
    plot(t, noisy{bitrate}, 'LineWidth', 1.2)
    title(['Noisy Signal (Bitrate = ', num2str(bitrate), ' bit/s)'])
    xlabel('Time (s)'); ylabel('Amplitude');
    ylim([-1.25 1.25]);

    % Decode noisy signal
    decodedMessage = amp_decoding(noisy{bitrate}, bitrate, mapset);

    % Display decoded message
    subplot(2,1,2)
    axis off
    text(0.05, 0.5, ['Decoded Message: ', decodedMessage], ...
        'FontSize', 12, 'FontWeight', 'bold');
end


% Exercise 1-7: Increasing Noise Levels

stds = [0.1, 0.5, 1];  

coded = cell(1,3);
noisy = cell(1,3);

for s = 1:length(stds)

    std_now = stds(s);

    figure('Position',[100,50,1400,900]);
    sgtitle(['Noise \sigma = ', num2str(std_now)]);

    for bitrate = 1:3
        
        coded{bitrate} = amp_coding(message, bitrate, mapset);

        noise = std_now * randn(1, length(coded{bitrate}));
        noisy{bitrate} = coded{bitrate} + noise;

        t = 0:1/fs : (length(noisy{bitrate})/fs - 1/fs);

        subplot(3,2, (bitrate-1)*2 + 1);
        plot(t, noisy{bitrate}, 'LineWidth', 1.1)
        title(['Bitrate = ', num2str(bitrate)])
        xlabel('Time (s)')
        ylabel('Amplitude')
        ylim([-2 2])

        decodedMessage = amp_decoding(noisy{bitrate}, bitrate, mapset);

        subplot(3,2, (bitrate-1)*2 + 2);
        axis off
        text(0.05, 0.5, ['Decoded: ', decodedMessage], ...
            'FontSize', 12, 'FontWeight','bold')
    end

end

% Exercise 1-8: Max tolerable noise for each bitrate

% Approximate std ranges found by trial and error
std_ranges = {
    [1.8, 1.9],    % bitrate 1
    [0.4, 0.5],    % bitrate 2
    [0.2, 0.25]    % bitrate 3
};

coded = cell(1,3);

for bitrate = 1:3

    coded{bitrate} = amp_coding(message, bitrate, mapset);
    std_test = std_ranges{bitrate};

    noise1 = std_test(1) * randn(1, length(coded{bitrate}));
    noise2 = std_test(2) * randn(1, length(coded{bitrate}));

    noisy1 = coded{bitrate} + noise1;
    noisy2 = coded{bitrate} + noise2;

    t = 0:1/fs:(length(coded{bitrate})/fs - 1/fs);

    figure;
    
    subplot(2,2,1);
    plot(t, noisy1); 
    title(['std = ', num2str(std_test(1)), ', bitrate = ', num2str(bitrate)]);

    subplot(2,2,2);
    plot(t, noisy2); 
    title(['std = ', num2str(std_test(2)), ', bitrate = ', num2str(bitrate)]);

    subplot(2,2,3); axis off;
    text(0.05, 0.5, ['Decoded: ', amp_decoding(noisy1, bitrate, mapset)], ...
        'FontSize', 12, 'FontWeight', 'bold');

    subplot(2,2,4); axis off;
    text(0.05, 0.5, ['Decoded: ', amp_decoding(noisy2, bitrate, mapset)], ...
        'FontSize', 12, 'FontWeight', 'bold');
    
end
