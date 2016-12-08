%Writes list of headers to results matrix ie: statistical operations 
[~,~,ListFunc] = xlsread('Funcs.xlsx'); %Next four lines get the list of functions to run & length of list
[~,~,ListFFTFunc] = xlsread('FFTFuncs.xlsx');
LListFunc = length (ListFunc);
LListFFTFunc = length (ListFFTFunc);
ResultArray (1, round(3+(LListFunc/2),0):round((LListFunc+LListFFTFunc)/2,0):round(3+(LListFunc+LListFFTFunc),0)) = cellstr(['Time Domain     ';'Frequency Domain'])';
ResultArray (2,4:3+(LListFunc+LListFFTFunc)) = [ListFunc,ListFFTFunc]; %writes list of functions to second row of results matrix
RowM = 3;

fnames = dir('*.mat');     %obtain names of all files in directory
Lfnames = length(fnames);  %obtain # of files in directory
vals = cell(1,Lfnames);    %creates array for names of all files

%Initialize the structure that will store data for the waterfall plot later
Wtrfl = struct ('OuterRace', cell(1), 'InnerRace', cell(1), 'Ball', cell(1), 'NoFault',  cell(1));
for K = 1:Lfnames
    
    vals{K} = load(fnames(K).name);   %loads file #K into the specific cell in vals
    
    [FaultType, FaultSize, PowerLvl] = FIdent(char (fnames(K).name));  %identifies test by strings in name
    
    VarNameStruct = cell2struct (fieldnames (vals{K}),'filed', 4); %obtains variable names from current file
    
    NofVars=length(cellfun('isempty',{VarNameStruct.filed})); %gets number of loops to run calculations on # of variables
    
    a = importdata (fnames(K).name); %makes script able to call variable names directly into function
    
    %Fix for single variable files
    if NofVars == 1
    a =  struct(VarNameStruct(1).filed, a)
    end
    
    for i = 1:NofVars
        
        %Starts at column 1 for a new case
        ClmnN = 1;
        
        %Retreives the location of test and sampling frequency
        [ Location, Fs ] = VarIdent (VarNameStruct(i).filed);
        
        %Skips all calculations if the current variable is RPM
        if (strcmp (Location, 'RPM') == 0)
            
            %Filters the current signal before any operations are performed on them
            [ Wn1, Wn2 ] = FiltrFreq ( FaultType );
            [q,r] = butter(5, [(Wn1+6000)/(Fs) (Wn2+6000)/(Fs)] , 'bandpass');
            a(1).(VarNameStruct(i).filed) = filter (q, r, a(1).(VarNameStruct(i).filed));
            
            %Length of current variable to use in df calc, time array calc, & FFT graph Scaling
            LCurrentVar = length (a(1).(VarNameStruct(i).filed));

            %performs fourier transform and writes to FFTShifted variable
            CurFFTShifted = fftshift(fft(a(1).(VarNameStruct(i).filed)));
            df = Fs/LCurrentVar;
            f = (-Fs/2):df:(Fs/2)-df;
            
            %Store a copy of the FFT'd signal, frequency vector, & identifying string for the drive end measurements
            if(strcmp (Location, 'DriveEnd') ~= 0)
                Wtrfl.(FaultType) {1, size(Wtrfl.(FaultType),2) + 1} = abs(CurFFTShifted)/(LCurrentVar/2)';
                Wtrfl.(FaultType) {2, size(Wtrfl.(FaultType),2)} = f';
                Wtrfl.(FaultType) {3, size(Wtrfl.(FaultType),2)} = cellstr([FaultType,' ',PowerLvl,' ',FaultSize]);
            end
            
            %Writes test info to result array
            ResultArray (RowM,1:3) = [cellstr(Location), cellstr(FaultType), cellstr([FaultType,' ',FaultSize])];
            ClmnN = 4;
            
            %Performs the list of functions taken from Funcs.xlsx on the current variable
            for j=1:LListFunc
                CurFunc = str2func(char(ListFunc(j)));
                ResultArray (RowM,ClmnN) = num2cell(CurFunc (a(1).(VarNameStruct(i).filed)));
                ClmnN = ClmnN + 1;
            end
            %Performs the list of functions taken from FFTFuncs.xlsx on the FFT shifted signal
            for k=1:LListFFTFunc
                CurFunc = str2func(char(ListFFTFunc(k)));
                ResultArray (RowM,ClmnN) = num2cell(CurFunc (abs(CurFFTShifted)/(LCurrentVar/2)));
                ClmnN = ClmnN + 1;
            end
            
            RowM=RowM+1;
        end
    end
end


%Uncomment following lines to produce waterfall plots for the listed cases
% WaterFallIt ('InnerRace', Wtrfl)
% WaterFallIt ('OuterRace', Wtrfl)
% WaterFallIt ('Ball', Wtrfl)

%Outputs the results array to 'Results.xlsx'
xlswrite('Results.xlsx',ResultArray)