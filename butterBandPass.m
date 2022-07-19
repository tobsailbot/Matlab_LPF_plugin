% Filtro butter LPF, que permite variar el cutoff y el orden del filtro
classdef butterBandPass < audioPlugin

    properties  
        f0 = 1000;
        q = 0.25; % Q-factor 0.05 - 20 
        noise_gain = 0.1;
        output = 1;
        noise_switch = true;
    end

    properties (Access = private)
        inicial = zeros(8,2) ;
        b = zeros(1,2) ; % inicializar variables
        a = zeros(1,2);
        orden = 2;
    end

    properties (Constant)
        PluginInterface = audioPluginInterface(...
             audioPluginParameter('f0',...
             'DisplayName','Center Frequency',...
             'Mapping',{'log',20,20e3}),...
             audioPluginParameter('q',...
             'DisplayName','Band width (Q)',...
             'Mapping',{'log',0.05,10}),...
             audioPluginParameter('noise_gain',...
             'DisplayName','Pink Noise',...
             'Mapping',{'log',0.1,10}),...
              audioPluginParameter('noise_switch', ...
             'DisplayName','Enable noise',...
             'Mapping', {'enum','Block signal','Pass through'}), ...
             audioPluginParameter('output',...
             'DisplayName','Output',...
             'Mapping',{'lin',0,1}))

   end

    methods
        function out=process(p,in)
            
            [filtrado, p.inicial] = filter(p.b, p.a, in, p.inicial);
            
            if p.noise_switch == true
                white = rand(size(in))- 0.5; % señal de ruido blanco
                b_noise = [0.049922035, -0.095993537, 0.050612699, -0.004408786];
                a_noise = [1 -2.494956002   2.017265875  -0.522189400];
                pink = filter(b_noise,a_noise,white);
                
                out = (filtrado + pink*p.noise_gain) * p.output; % señal filtrada mas ruido
            else
                out = (filtrado)* p.output;
            end
        
        end
        
        function reset(p)
            p.inicial = zeros(p.orden*2,2);
            fs = getSampleRate(p);
            [p.b,p.a] = butterCoeffi(p.f0, p.q, fs, p.orden);
        end
        
        function set.f0(p,value) 
            p.f0 = value; % actualizar el valor de la propiedad
            fs = getSampleRate(p);
            [p.b,p.a] = butterCoeffi(p.f0, p.q, fs, p.orden);
        end
        
        function set.q(p,value)
            p.q = value;
            fs = getSampleRate(p);
            [p.b,p.a] = butterCoeffi(p.f0, p.q, fs, p.orden);
        end

    end

end
