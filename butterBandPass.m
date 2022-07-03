% Filtro butter LPF, que permite variar el cutoff y el orden del filtro
classdef butterBandPass < audioPlugin

    properties  
        f0 = 800;
        q = 0.05; % Q-factor 0.05 - 20 
    end

    properties (Access = private)
        inicial = zeros(8,2) ;
        b = zeros(1,2) ; % inicializar variables
        a = zeros(1,2);
        orden = 4;
    end

    properties (Constant)
        PluginInterface = audioPluginInterface(...
             audioPluginParameter('f0',...
             'DisplayName','Center Frequency',...
             'Mapping',{'log',100,20e3}),...
             audioPluginParameter('q',...
             'DisplayName','Band width',...
             'Mapping',{'log',0.05,20}))
   end

    methods
        function out=process(p,in)
            [out, p.inicial] = filter(p.b, p.a, in, p.inicial);
        end
        
        function reset(p)
            p.inicial = zeros(p.orden*2,2);
            fs = getSampleRate(p);
            [p.b,p.a] = butterCoeffi(p.f0, (p.f0/p.q), fs, p.orden);
        end
        
        function set.f0(p,value) 
            p.f0 = value; % actualizar el valor de la propiedad
            fs = getSampleRate(p);
            [p.b,p.a] = butterCoeffi(p.f0, (p.f0/p.q), fs, p.orden);
        end
        
        function set.q(p,value)
            p.q = value;
            fs = getSampleRate(p);
            [p.b,p.a] = butterCoeffi(p.f0, (p.f0/p.q), fs, p.orden);
        end

    end

end
