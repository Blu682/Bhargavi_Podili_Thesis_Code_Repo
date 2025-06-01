%[SourceParam SourceData] = predictSP(Mw,Lat,Lon,tectS,FMech)

%INPUT PARAMETERS----------------------------------------------------------
%Magnitude       : "Mw" (eg. 7.20 or 7.55)
%Latitude        : "Lat" (eg. 14.2)
%Longitude       : "Lon" (eg. 121.223)
%tectonics       : "tectS"    : "IeP = Interplate"/
%                               "IaP = Intraplate"/
%                               "OR  = Outer rise"/
%                               "AC  = Active Crustal"/
%                               "SCR = Stable Continental Region"/ 
%                                OR 
%                               "NA = Unknown"
%Fault-Mechanism : "FMech"    : "R = Reverse"/ 
%(FM)                           "ObR = Oblique Reverse"/
%                               "N = Normal"/
%                               "ObN = Oblique Normal"/
%                               "SS = Strike-slip"/
%                                OR 
%                               "NA = Unknown"
%--------------------------------------------------------------------------
%OUTPUT PARAMETERS---------------------------------------------------------
%SourceParam     :  Leff, Weff, Aeff, Avla, Ala, Dmean, Dmax, Dstd
%
%                    Leff: Effective fault length, in km
%                    Weff: Effective fault width, in km
%                    Aeff: Effective fault area, in km^2
%                    Avla: Very large asperity area, in km^2
%                    Ala: Large asperity area, in km^2
%                    Dmean: Mean slip, in m
%                    Dmax: maximum slip, in m
%                    Dstd: standard deviation of the slip distribution with
%                          respect to the mean slip, in m
%SourceData      :  Mw, Lat, Lon, Tectonics, FM, Region
%                   (For when only Mw, Lat and Lon are the only input para-
%                    meters; Displays the assumed tectonics &/FM &/Region)
%--------------------------------------------------------------------------
Mw=5:0.1:9.4;
Lat=-14.99;
Lon=-75.63;
for i=1:length(Mw)
    [SP SD]=predictSP(Mw(i), Lat, Lon, 'IeP', 'R');
    Res(i)=SP.Leff;
end
%Eg2
%Nepal
Mw = 7.8; Lat=27.7; Lon=85.3;
[SP SD]=predictSP(Mw, Lat, Lon);

hold on
semilogy(Mw,(Res),'b')
