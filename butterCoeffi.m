
function [b, a] = butterCoeffi(f0, deltaf, fs, orden)
    % Butterworth filter coefficients
    fN=fs/2;
    
    fc1 = (sqrt(deltaf^2+4*f0^2)-deltaf)/2;
    fc2 = round(f0^2/fc1);
    
    if fc1 <= 20
        fc1 = 20;
    elseif fc2 >= 18000;
        fc2 = 18000;
    end
    
    Wn = [fc1/fN, fc2/fN]; 
    [b,a] = butter(orden,Wn); 
end