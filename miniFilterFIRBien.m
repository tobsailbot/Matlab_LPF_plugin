classdef miniFilterFIRBien < audioPlugin

    properties  
        fc = 1000;
        orden = 3;
    end

    properties (Access = private)
        inicial ;
        b ; % inicializar variables
        a ;
    end

    properties (Constant)
        PluginInterface = audioPluginInterface(...
             audioPluginParameter('fc',...
             'DisplayName','Cutoff Frequency',...
             'Mapping',{'log',20,20e3}),...
             audioPluginParameter('orden',...
             'DisplayName','Orden',...
             'Mapping',{'int',1,6}))
   end

    methods
        function out=process(p,in)
            [out, p.inicial] = filter(p.b, p.a, in, p.inicial);
        end

        function reset(p)
            p.inicial = zeros(p.orden,2);
            fs = getSampleRate(p);
            [p.b,p.a] = butterCoeff(p.fc, fs, p.orden);
        end

        function set.orden(p,value) 
            p.orden = value; % actualizar el valor de la propiedad
            p.reset(); % reiniciar el filtro
        end

        function set.fc(p,value) 
            p.fc = value; % actualizar el valor de la propiedad
            fs = getSampleRate(p);
            [p.b,p.a] = butterCoeff(p.fc, fs, p.orden);
        end


    end

end

