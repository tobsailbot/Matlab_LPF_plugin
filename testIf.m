classdef testIf < audioPlugin
    methods
        function out = process(~,in)
            white = rand(size(in))- 0.5;
            
            out = in + white*0.1;
        end
    end 
end