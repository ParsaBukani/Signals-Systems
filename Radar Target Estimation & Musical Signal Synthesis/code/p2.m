clc;
clear;

%% Exercise 2.1

% Parameters
Fs = 8000;
ts = 1/Fs;
T = 0.5;
T_half = 0.25;
tau = 0.025;

t = 0:ts:T-ts;
t_h = 0:ts:T_half-ts;
silence = zeros(1, round(tau*Fs));

% Note map (name → waveform)
notes_map = containers.Map;

notes_map('c')   = sin(2*pi*523.25*t);
notes_map('c#')  = sin(2*pi*554.37*t);
notes_map('d')   = sin(2*pi*587.33*t);
notes_map('d#')  = sin(2*pi*622.25*t);
notes_map('e')   = sin(2*pi*659.25*t);
notes_map('f')   = sin(2*pi*698.46*t);
notes_map('f#')  = sin(2*pi*739.99*t);
notes_map('g')   = sin(2*pi*783.99*t);
notes_map('g#')  = sin(2*pi*830.61*t);
notes_map('a')   = sin(2*pi*880*t);
notes_map('a#')  = sin(2*pi*932.33*t);
notes_map('b')   = sin(2*pi*987.77*t);

notes_map('c_h')  = sin(2*pi*523.25*t_h);
notes_map('c#_h') = sin(2*pi*554.37*t_h);
notes_map('d_h')  = sin(2*pi*587.33*t_h);
notes_map('d#_h') = sin(2*pi*622.25*t_h);
notes_map('e_h')  = sin(2*pi*659.25*t_h);
notes_map('f_h')  = sin(2*pi*698.46*t_h);
notes_map('f#_h') = sin(2*pi*739.99*t_h);
notes_map('g_h')  = sin(2*pi*783.99*t_h);
notes_map('g#_h') = sin(2*pi*830.61*t_h);
notes_map('a_h')  = sin(2*pi*880*t_h);
notes_map('a#_h') = sin(2*pi*932.33*t_h);
notes_map('b_h')  = sin(2*pi*987.77*t_h);

% Melody
melody = "d_h d_h g f# d d_h e_h e_h d_h f#_h e d e f# e d_h e_h e_h d_h f#_h d_h e d e_h d_h f# e d e_h d_h f# e d_h d_h e f#_h e_h f# f#_h e_h f# f# d";

melody = split(melody);

% Generate music
output = [];

for i = 1:length(melody)
    note = melody{i};
    if isKey(notes_map, note)
        output = [output notes_map(note) silence];
    end
end

% Play sound
sound(output, Fs);
audiowrite('song_part2_1.wav', output, Fs);

%% Exercise 2.2
clc;
clear;

Fs = 8000;
ts = 1/Fs;
T = 0.5;
T_half = 0.25;
tau = 0.025;

t = 0:ts:T-ts;
t_h = 0:ts:T_half-ts;
silence = zeros(1, round(tau*Fs));

notes_map = containers.Map;

notes_map('c')   = sin(2*pi*523.25*t);
notes_map('d')   = sin(2*pi*587.33*t);
notes_map('e')   = sin(2*pi*659.25*t);
notes_map('f')   = sin(2*pi*698.46*t);
notes_map('g')   = sin(2*pi*783.99*t);
notes_map('a')   = sin(2*pi*880*t);
notes_map('b')   = sin(2*pi*987.77*t);

notes_map('c_h') = sin(2*pi*523.25*t_h);
notes_map('d_h') = sin(2*pi*587.33*t_h);
notes_map('e_h') = sin(2*pi*659.25*t_h);
notes_map('f_h') = sin(2*pi*698.46*t_h);
notes_map('g_h') = sin(2*pi*783.99*t_h);
notes_map('a_h') = sin(2*pi*880*t_h);
notes_map('b_h') = sin(2*pi*987.77*t_h);

% Happy Birthday Melody
melody = "g g a g c_h b_h g g a g d_h c_h g g g_h e_h c_h b_h a_h f_h f_h e_h c_h d_h c_h g g a g c_h b_h g g a g d_h c_h";

melody = split(melody);

output = [];

for i = 1:length(melody)
    note = melody{i};
    if isKey(notes_map, note)
        output = [output notes_map(note) silence];
    end
end

sound(output, Fs);
audiowrite('mysong.wav', output, Fs);

%% Exercise 2.3
clc;
clear;

% Load music from Exercise 2.1
[y, Fs] = audioread('song_part2_1.wav');
y = y';
y = y / max(abs(y));   % normalize 

frame_len = round(0.02 * Fs);   % 20 ms
hop_len   = round(0.01 * Fs);   % 10 ms
silence_th = 0.15;              % relative energy threshold

% Short-time energy
num_frames = floor((length(y) - frame_len) / hop_len);
energy = zeros(1, num_frames);

for k = 1:num_frames
    idx = (k-1)*hop_len + (1:frame_len);
    frame = y(idx);
    energy(k) = sum(frame.^2);
end

energy = energy / max(energy);  % normalize energy

% Detect note segments
is_note = energy > silence_th;
edges = diff([0 is_note 0]);
start_idx = find(edges == 1);
end_idx   = find(edges == -1) - 1;

% Note frequency map (Part 2.1)
note_freqs = [523.25 554.37 587.33 622.25 659.25 ...
              698.46 739.99 783.99 830.61 880 932.33 987.77];
note_names = ["c","c#","d","d#","e","f","f#","g","g#","a","a#","b"];

detected_notes = strings(1, length(start_idx));
durations = zeros(1, length(start_idx));

% Process each detected note
for i = 1:length(start_idx)

    s = (start_idx(i)-1)*hop_len + 1;
    e = min((end_idx(i)-1)*hop_len + frame_len, length(y));
    note_sig = y(s:e);

    % FFT for pitch detection
    N = length(note_sig);
    f = (0:N-1) * (Fs/N);
    Y = abs(fft(note_sig));

    [~, idx] = max(Y(1:floor(N/2)));
    f_peak = f(idx);

    % Map frequency to nearest note
    [~, nidx] = min(abs(note_freqs - f_peak));
    detected_notes(i) = note_names(nidx);

    % Duration (seconds)
    durations(i) = (e - s) / Fs;
end

% Label half-duration notes (_h)
labeled_notes = strings(1, length(detected_notes));
for i = 1:length(detected_notes)
    if durations(i) < 0.35        % ~0.25 s
        labeled_notes(i) = detected_notes(i) + "_h";
    else                          % ~0.5 s
        labeled_notes(i) = detected_notes(i);
    end
end

disp('Detected Notes and Durations:');
for i = 1:length(labeled_notes)
    fprintf('%3d) %-4s  %.2f s\n', i, labeled_notes(i), durations(i));
end
