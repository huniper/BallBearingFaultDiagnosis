function [ Wn1, Wn2 ] = FiltrFreq ( FaultType )
%Allows the script to use different filtering frequencies for different
%cases as the fault frequencies differ for each case.

if(strcmp (FaultType, 'OuterRace') ~= 0)
    Wn1 = -2500; %low cut frequency
    Wn2 = 2500; %high cut frequency
end
if(strcmp (FaultType, 'InnerRace') ~= 0)
    Wn1 = -2175;
    Wn2 = 2175;
end
if(strcmp (FaultType, 'Ball') ~= 0)
    Wn1 = -2175;
    Wn2 = 2175;
end
if(strcmp (FaultType, 'NoFault') ~= 0)
    Wn1 = -2500;
    Wn2 = 2500;
end

end

