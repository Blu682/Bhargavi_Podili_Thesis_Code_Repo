function   [SourceParam SourceData]= predictSP(Mw,Lat,Lon,tectS,FMech)
    %======================================================================
    %Pre-conditions:
    %Mw:
    assert(isnumeric(Mw),'Mw should be a number of the format "0.0".');
    if Mw < 5.0 || Mw > 9.2
        warning(['The code is developed using Mw between 5.0 and 9.2. '...
            'Mw = %.2f is outside the expected range.'], Mw);
    end  

    %Lat:
    assert(isnumeric(Lat),['Lat (in degrees) should be of the format...'...
                           ' "0.0".']);
    assert((Lat>-90 && Lat<90),['Lat (in degrees) should be between...' ...
                                ' -90 and 90.']);

    %Lon:
    assert(isnumeric(Lon),['Lon (in degrees) should be of the format...'...
                           ' "0.0".']);
    assert((Lon>-180 && Lon<180),['Lon (in degrees) should be...' ...
                                  ' between -180 and 180.']);

    %Tectonics:
    if ~exist('tectS'),tect = 'NA'; else tect=tectS; end
    assert(isempty(tect) || any(strcmp(tect, {'IeP', 'IaP', 'OR',...
        'AC', 'SCR', 'NA'})),['tectonics should be either empty or' ...
        ' IeP/IaP/OR/AC/SCR/NA.']);
   
    %Fault-Mechanism:
    if ~exist('FMech'),FaultMech = 'NA'; else FaultMech=FMech; end
    assert(isempty(FaultMech) || any(strcmp(FaultMech, {'R', 'ObR', 'N',...
        'ObN', 'SS', 'NA'})),['FaultMech should be either empty or' ...
        ' R/ObR/N/ObN/SS/NA.']);
    
    %----------------------------------------------------------------------
    %Options---------------------------------------------------------------

    %tectonics:
    % D1. *Obtain the probable tectonics if Tectonics = NA
    if strcmp(tect,'IeP')==1, tectonics='Interplate';
    elseif strcmp(tect,'IaP')==1, tectonics='Intraplate';
    elseif strcmp(tect,'OR')==1, tectonics='Outer rise';
    elseif strcmp(tect,'AC')==1, tectonics='Active';
    elseif strcmp(tect,'SCR')==1, tectonics='Stable'; 
    elseif strcmp(tect,'NA')==1 || isempty(tect)
        load Data2.mat
        [a, LatNear] = min(abs(Lat-Data2.Lat(:,1)) + ...
                           abs(Lon-Data2.Lon(:,1))); 
        tectonics=char(Data2.Tect(LatNear));
        warning(['Approximating "tectonics" type']);
        clear a LatNear Data2;
    end
    % 2. Bilinear: set the bilinear option for Interplate events
    Mwo=7.94;
    if Mw >= Mwo && strcmp(string(tectonics),'Interplate')==1
        tectonics = 'Megathrust';
    end
    %----------------------------------------------------------------------

    %Region:
    % D2. *Obtaining FE from Lat Lon and SE from FE
    url = 'https://service.iris.edu/irisws/flinnengdahl/2/query?';
    %Lat = 35.4; Lon = 139.2;
    output = 'code';  % You can change this to 'code' for numeric codes, 
                      % else 'region'
    data = webread(url, 'lat', Lat, 'lon', Lon, 'output', output);
    SE = FEtoSE(double(string(data)));
    load Data2.mat
    Region=char(unique(Data2.Region(Data2.SE == SE)));
    clear Data2 url data output
    %----------------------------------------------------------------------

    %FaultMech:
    % D3. *Obtain dominant FaultMech if FaultMech = NA
    if strcmp(FaultMech,'R')==1, FM='Reverse';
    elseif strcmp(FaultMech,'ObR')==1, FM='Oblique reverse';
    elseif strcmp(FaultMech,'N')==1, FM='Normal';
    elseif strcmp(FaultMech,'ObN')==1, FM='Oblique normal';
    elseif strcmp(FaultMech,'SS')==1, FM='Strike-slip'; 
    elseif strcmp(FaultMech,'NA')==1 || isempty(FaultMech)
        load Data2.mat
        [a, LatNear] = min(abs(Lat-Data2.Lat(:,1)) + ...
                           abs(Lon-Data2.Lon(:,1))); 
        FM=char(Data2.FM(LatNear));
        warning(['Approximating "FM" type']);
        clear a LatNear Data2;
    end
    %----------------------------------------------------------------------

    %EqID: Get a similar ID for obtaining Intra-event uncertainity
    % D4. *Select the ID of the most closely matched Mw event from the 
    %      database
    load Data2.mat
    MwOptions=[];
    a=1;
    for i=1:273
        if Data2.Tect(i)==tectonics && Data2.Region(i)==Region &&...
                Data2.FM(i)==FM
            MwOptions(a,1)=abs(Data2.Mw(i)-Mw);
            MwOptions(a,2)=Data2.EqID(i);
            a=a+1;
        end
    end
    clear Data2 a
    %----------------------------------------------------------------------

    %Adjusting
    %FM:
    % *Generate specific error messages for tectonics with FM groups 
    %    that are not present in the data
    %a. Megathrust.. only reverse and Oblique reverse
    if all(strcmp(tectonics,'Megathrust')==1 & strcmp(FM,'Reverse')==0 ...
            & strcmp(FM,'Oblique reverse')==0)
        error(['FM groups for interplate megathrust events are only of '...
            '"Reverse - R" and "Oblique reverse - ObR"']);
    end
    %b. Outer-rise.. only normal
    if strcmp(tectonics,'Outer rise')==1 && strcmp(FM,'Normal')==0 
        error(['FM groups for Outer-rise events are only of...' ...
               '"Normal - N" type']);
    end
    %c. Stable.. only reverse and normal
    if all(strcmp(tectonics,'Stable')==1 & strcmp(FM,'Reverse')==0 &...
            strcmp(FM,'Normal')==0)
        error(['FM groups for Stable events are only of "Normal - N"' ...
            ' and "Reverse - R" type']);
    end
    
    %----------------------------------------------------------------------
    %Approximating region (since the current dataset has only 25 out of 50
    %seismic regions
    % A1. *Obtain dominant FaultMech if FaultMech = NA
    load Data2.mat
    if isempty(Region)==1
        for i=1:273
            if strcmp(char(Data2.Tect(i)),tectonics)==1
                diff(i) = (abs(Lat-Data2.Lat(i,1)) + ...
                                   abs(Lon-Data2.Lon(i,1))); 
            else, diff(i)=10^4;
            end
        end
        [a LatNear] = min(diff);
        Region=char(Data2.Region(LatNear));
         warning(['Approximating "Region" type']);
        clear a LatNear Data2;
    end
  
    %----------------------------------------------------------------------
    %A2. *If there are no exact matches to the fault mechanism, 
    %    then adjust. 
    % For example, RLOR and LLOR can be appproximated to R and so on..
    if isempty(MwOptions)==1
        load Data2.mat
        check = textscan(FM, '%s');
        if strcmp(check{1,1},('Oblique reverse'))==1
            for i=1:273
                if Data2.Tect(i)==tectonics && Data2.Region(i)==Region ...
                    && Data2.FM(i)==Data2.FM(3)
                    MwOptions(a,1)=abs(Data2.Mw(i)-Mw);
                    MwOptions(a,2)=Data2.EqID(i);
                    a=a+1;
                end
            end
            warning(['Approximating "FM" type to Reverse']);
        elseif strcmp(check{1,1},('Oblique normal'))==1
            for i=1:273
                if Data2.Tect(i)==tectonics && Data2.Region(i)==Region ...
                    && Data2.FM(i)==Data2.FM(14)
                    MwOptions(a,1)=abs(Data2.Mw(i)-Mw);
                    MwOptions(a,2)=Data2.EqID(i);
                    a=a+1;
                end
            end
            warning(['Approximating "FM" type to Normal']);
         end
    end
    %----------------------------------------------------------------------

    %----------------------------------------------------------------------
    %A3. *If there are no exact matches to the EqID, 
    %    then adjust. 
    if isempty(MwOptions)==1
        load Data2.mat
        a=1;
            for i=1:273
                if Data2.Tect(i)==tectonics && Data2.FM(i)==Data2.FM(3)
                    MwOptions(a,1)=abs(Data2.Mw(i)-Mw);
                    MwOptions(a,2)=Data2.EqID(i);
                    a=a+1;
                end
            end
            warning(['Approximating "intra-event" uncertainity']);
     end
    %----------------------------------------------------------------------
    if isempty(MwOptions)==1
        error(['Discrepancy in the source characteristics provided.' ...
            ' Please adjust the input options for either tectonics...' ...
            ' or FM for the given coordinates (Lat+Lon).']);
    end
   
    [~, index] = min(MwOptions(:,1));
    ID=MwOptions(index,2);
    clear MwOptions index i a Data2
    
    %----------------------------------------------------------------------
    % New data for prediction with the same categorical variable 'Group'
    newData = table([Mw],{tectonics}, {Region}, {FM}, [ID],...
        'VariableNames', {'Mw', 'Tect', 'Region','FM','EqID'});
    %----------------------------------------------------------------------
    load Data2.mat
    % Ensure that 'Group' in newData is categorical and matches the levels
    % in the training data
    newData.Tect = categorical(newData.Tect, categories(Data2.Tect)); 
    % Use the same categories as in the model
    newData.Region = categorical(newData.Region, categories(Data2.Region)); 
    % Use the same categories as in the model
    newData.FM = categorical(newData.FM, categories(Data2.FM));
    % Use the same categories as in the model
    %----------------------------------------------------------------------
    
    load ModelF.mat
    %Prediction
    SourceP = [10.^(predict(ModelF.Leff,newData)); 
                   10.^(predict(ModelF.Weff,newData));
                   10.^(predict(ModelF.Aeff,newData));
                   10.^(predict(ModelF.ar,newData));
                   10.^(predict(ModelF.Avla,newData));
                   10.^(predict(ModelF.Ala,newData));
                   10.^(predict(ModelF.Dmean,newData));
                   10.^(predict(ModelF.Dmax,newData));
                   10.^(predict(ModelF.Dstd,newData));
                   10.^(predict(ModelF.sd,newData))];
     % Column headings
     colHeadings = {'Leff', 'Weff', 'Aeff', 'ar','Avla', 'Ala', 'Dmean',...
                    'Dmax', 'Dstd','sd'};
     for i = 1:length(colHeadings)
         SourceParam.(colHeadings{i}) = SourceP(i);  
     end
     SourceParam.units={'km','km','km^2','-','km^2','km^2','m','m','m','*10^3'};
     % Column headings2
     colHeadings2 = {'Mw', 'Lat', 'Lon', 'Tectonics', 'FM', 'Region'};
     SourceData.(colHeadings2{1}) = Mw;  
     SourceData.(colHeadings2{2}) = Lat;SourceData.(colHeadings2{3}) = Lon;
     SourceData.(colHeadings2{4}) = char(tectonics);
     SourceData.(colHeadings2{5}) = char(FM);
     SourceData.(colHeadings2{6}) = char(Region);

    %----------------------------------------------------------------------
end
