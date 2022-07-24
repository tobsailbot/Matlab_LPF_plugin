% Filtro butter LPF, y generador de ruido rosa

classdef BandPassPinkNoise < audioPlugin

    properties  
        f0 = 1000; % Frecuencia central
        Q = 0.25; % Q-factor 0.05 - 20 
        noise_gain = 0.1; % Nivel de ruido rosa
        output = 1; % Nivel de salida
        noise_switch = true; % Activador del ruido
    end

    properties (Access = private)
        inicial = zeros(2,2) ;
        b = zeros(1,2) ; % inicializar variables
        a = zeros(1,2);
        orden = 2; % orden del filtro butter
        fs = 44100; % fs default
    end

    properties (Constant)
        PluginInterface = audioPluginInterface(...
         'PluginName','Band Pass and Pink Noise',...
         'VendorName', 'DSP UNLa - Tobias Pilarche',...
         ...
         audioPluginParameter('f0',...
         'DisplayName','Center Frequency',...
         'Mapping',{'log',20,20e3}),...
         ...
         audioPluginParameter('Q',...
         'DisplayName','Band width (Q)',...
         'Mapping',{'log',0.05,10}),...
         ...
         audioPluginParameter('noise_gain',...
         'DisplayName','Pink Noise',...
         'Mapping',{'log',0.1,10}),...
         ...
         audioPluginParameter('noise_switch',...
         'DisplayName','Enable noise',...
         'Mapping', {'enum','Block signal','Pass through'}),...
         ...
         audioPluginParameter('output',...
         'DisplayName','Output',...
         'Mapping',{'lin',0,1}))
   end

    methods
        function out=process(p,in)
            
            [filtrado, p.inicial] = filter(p.b, p.a, in, p.inicial);
            
            if p.noise_switch == true
                white = rand(size(in))- 0.5; % señal de ruido blanco
                b_noise = [0.049922035, -0.095993537, 0.050612699, -0.004408786]; % coeficientes
                a_noise = [1 -2.494956002   2.017265875  -0.522189400];
                pink = filter(b_noise,a_noise,white); % filtrado obtiene ruido rosa

                out = (filtrado + pink*p.noise_gain) * p.output;
            else
                out = (filtrado)* p.output;
            end
        
        end
        
        function reset(p)
            p.fs = getSampleRate(p);
            p.inicial = zeros(p.orden*2,2);
            [p.b,p.a] = butterBandPass(p.fs, p.orden, p.f0, p.Q);
        end
        
        function set.f0(p,f0)
            p.f0 = f0;
            [p.b,p.a] = butterBandPass(p.fs, p.orden, f0, p.Q);
        end
        
        function set.Q(p,Q)
            p.Q = Q;
            [p.b,p.a] = butterBandPass(p.fs, p.orden, p.f0, Q);
        end

    end

end
