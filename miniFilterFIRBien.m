classdef miniFilterFIRBien < audioPlugin

    properties  
        fc = 1000;
    end

    properties
        %Pasa bajos butter de orden 3 con fc/fN = 1000/24000
        orden = 8; % 1 - 6 max
        inicial ;
        b ; % inicializar variables
        a ;
    end

    properties (Constant)
        PluginInterface = audioPluginInterface(...
             audioPluginParameter('fc',...
             'DisplayName','Cutoff Frequency',...
             'Mapping',{'log',20,20e3}))
   end

    methods
        function out=process(p,in)
            %[p.b,p.a] = deal([0.000247, 0.000741, 0.000741, 0.000247],...
            % [1, -2.738, 2.51, -0.77]);
            %fs = getSampleRate(p);
            %[p.b,p.a] = butterCoeff(p.fc, fs, p.orden);
            [out, p.inicial] = filter(p.b, p.a, in, p.inicial);
        end

        function reset(p)
            p.inicial = zeros(p.orden,2);
            fs = getSampleRate(p);
            [p.b,p.a] = butterCoeff(p.fc, fs, p.orden);
        end

       function set.fc(p,fc)

            p.fc = fc;
            fs = getSampleRate(p);
            [p.b,p.a] = butterCoeff(p.fc, fs, p.orden);
        end
    end

end

