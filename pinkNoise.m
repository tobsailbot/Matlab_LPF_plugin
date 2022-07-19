clear;clc
%function [pink_noise] = pinkNoise(Fs,noise_gain,duration)
    Fs = 48000;     % Sampling rate
    Nyq = Fs/2;     % Nyquist Frequency for Normalization
    white = randn(5*Fs,1);


    f = 20;    % Starting frequency in Hz
    gain = 1/sqrt(f);  % Amplitude at starting frequency
    freq = 0;  % Initialize fir2 freq vector  
    while f < Nyq
        % Normalized Frequency Vector
        freq = [freq f/Nyq];

        % Amplitude vector, gain = 1/sqrt(f)
        gain = [gain 1/sqrt(f)];

        % Increase "f" by an octave
        f = f*2;
    end
    % Set frequency and amplitude at nyquist
    freq = [freq 1];
    gain = [gain 1/sqrt(Nyq)];

    % Filter Normalization Factor to Unity Gain
    unity = sqrt(20);
    gain = unity * gain;

    % Plot Frequency Reponse of Filter
    order = 2000;
    h = fir2(order,freq,gain);


    % Create Pink Noise by Filtering White Noise
    pink = conv(white,h);

    sound(pink,Fs);