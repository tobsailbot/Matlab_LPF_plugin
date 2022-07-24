% Butterworth Bandpass
function [b, a] = butterBandPass(fs, orden, f0, q)
    
    % al usar getSampleRate en el plugin no se puede validar BUG
    fN = fs/2; % frecuencia de nyquist
    deltaf = f0/q; % ancho de banda del filtro
    
    fc1 = (sqrt(deltaf^2+4*f0^2)-deltaf)/2,1;
    fc2 = f0^2/fc1,1;
    
    % debug
    disp('--------')
    disp('fc1: ')
    disp(fc1);
    disp('fc2: ')
    disp(fc2);
    
    wn1 = fc1/fN;
    wn2 = fc2/fN;
    
    % limitar wn frecuencias de corte normalizadas
    % esto lo hice porque daba probmeas al valida el plugin con
    % diferentes frecuencias de muestreo, Wn debe ser valores entre 0 y 1
    if wn1 <= 0
        wn1 = 0;
    elseif wn1 >= 1
        wn1 = 0.9999;
    end
    
    if wn2 <= 0
        wn2 = 0;
    elseif wn2 >= 1
        wn2 = 0.9999;
    end
    
    disp(wn1)
    disp(wn2)
    
    Wn = [wn1, wn2]; 
    [b,a] = butter(orden,Wn); 
end