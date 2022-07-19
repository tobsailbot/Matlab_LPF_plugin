
function [b, a] = butterCoeffi(f0, q, fs, orden)
    % Butterworth filter coefficients
    fN=fs/2;
    deltaf = f0/q;
    
    fc1 = (sqrt(deltaf^2+4*f0^2)-deltaf)/2,1;
    fc2 = f0^2/fc1,1;
    
    if fc1 <= 20
        fc1 = 20;
    elseif fc2 >= 20000
        fc2 = 20000;
    end
    
    % debug
    disp('--------')
    disp('fc1: ')
    disp(fc1);
    disp('fc2: ')
    disp(fc2);
    
    Wn = [fc1/fN, fc2/fN]; 
    [b,a] = butter(orden,Wn); 
end