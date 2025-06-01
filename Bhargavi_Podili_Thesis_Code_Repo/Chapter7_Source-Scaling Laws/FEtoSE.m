function   SE = FEtoSE(FE)
%check the precondition that Fe should be between 1 and 757
     if FE >= 1 && FE <= 757
        % Define the range of FEregions
        FEregions = 1:729;    
        % Define the group boundaries as a matrix with ranges
        groupRanges = [1 17; 18 29; 30 46; 47 52; 53 71; 72 83; 84 101;...
            102 142; 143 146; 147 157; 158 168; 169 179; 180 182; 183 189;...
            190 195; 196 208; 209 210; 211 216; 217 230; 231 241; 242 247;...
            248 260; 261 272; 273 293; 294 301; 302 319; 320 325; 326 334;...
            335 356; 357 375; 376 401; 402 414; 415 437; 438 527; 528 531;...
            532 549; 550 587; 588 610; 611 632; 633 655; 656 666; 667 682;...
            683 692; 693 699; 700 702; 703 708; 709 712; 713 720; 721 726;...
            727 729];
        % Number of groups
        numGroups = size(groupRanges, 1);
        % Pre-allocate a vector to store the group number
        groupNumbers = zeros(size(FEregions));
        % Assign FEregions to groups
        for i = 1:numGroups
            % Extract the start and end for the current group
            startVal = groupRanges(i, 1);
            endVal = groupRanges(i, 2);
            % Assign the group number to the FEregions within the range
            groupNumbers(FEregions >= startVal & FEregions <= endVal) = i;
        end
        
       
        %Special Cases
        if FE == 730
            SE = 5;
        elseif FE == 731
            SE = 7;
        elseif FE == 732
            SE = 10;
        elseif FE >= 733 && FE <= 737
            SE = 25;
        elseif FE >= 738 && FE <= 739
            SE = 32;
        elseif FE >= 740 && FE <= 742
            SE = 33;
        elseif FE >= 743 && FE <= 755
            SE = 37;
        elseif FE == 756
            SE = 43;
        elseif FE == 757
            SE = 44;
        else
            SE = groupNumbers(FE);
        end
        %fprintf('FEregion %d belongs to SEregion %d\n', FE, SE);
     else 
        fprintf('Enter a valid FE region code');
end
