function [ FaultType, FaultSize, PowerLvl ] = FIdent( FNameStrInpt )
%Function inputs a file name and analyzes it based on it's content
%then returns type and size of fault with power level of test
        if (strfind (FNameStrInpt, 'B0') > 0)       %get fault location
            FaultType = 'Ball';
        else
            if (strfind (FNameStrInpt, 'IR') > 0)
                FaultType = 'InnerRace';
            else
                if (strfind (FNameStrInpt, 'OR') > 0)
                    FaultType = 'OuterRace';
                else
                    if (strfind (FNameStrInpt, 'Normal') > 0)
                    FaultType = 'NoFault';
                    end
                end
            end
        end
        if (strfind (FNameStrInpt, '007') > 0)      %get fault size
            FaultSize = '7mil';
        else
            if (strfind (FNameStrInpt, '014') > 0)
                FaultSize = '14mil';
            else
                if (strfind (FNameStrInpt, '021') > 0)
                    FaultSize = '21mil';
                else
                    if (strfind (FNameStrInpt, '028') > 0)
                        FaultSize = '28mil';
                    else
                        FaultSize = 'None';
                    end
                end
            end
        end
        if (strfind (FNameStrInpt, '_0') > 0)      %get power level
            PowerLvl = '0HP';
        else
            if (strfind (FNameStrInpt, '_1') > 0)
                PowerLvl = '1HP';
            else
                if (strfind (FNameStrInpt, '_2') > 0)
                    PowerLvl = '2HP';
                else
                    if (strfind (FNameStrInpt, '_3') > 0)
                        PowerLvl = '3HP';
                    end
                end
            end
        end

end

