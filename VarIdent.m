function [ Location, Fs ] = VarIdent( Input )
%Takes input in form of a string and identifies it's content
%based on the name and outputs the location and sampling freq. required
        StrInput = char (Input);
        if (strfind (StrInput, 'DE') > 1)
            Location = 'DriveEnd';
            Fs = 12000;
        else
            if (strfind (StrInput, 'FE') > 1)
                Location = 'FanEnd';
                Fs = 12000;
            else
                if (strfind (StrInput, 'BA') > 1)
                    Location = 'Base';
                    Fs = 12000;
                else
                    if (strfind (StrInput, 'RPM') > 1)
                    Location = 'RPM';
                    Fs = 0;
                end
            end
        end

end

