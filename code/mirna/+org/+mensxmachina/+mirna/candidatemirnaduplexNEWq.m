function [duplex overhang] = candidatemirnaduplexNEWq(model, ...
    hairpinBracket, hairpin5pArmMatchPos, hairpin3pArmMatchPos, ...
    hairpinTipPos, Param)
%CANDIDATEMIRNADUPLEXQ Generate candidate miRNA:miRNA* duplexes
% This function builts the possible miRNA duplexes based on model 1
% model 1 is generated in "mirnaduplexsvmfindertrainq"

%% to run it by its own
% clear all;
% clc;
% load ('candidatemirnaduplexNEWqINPUT');
% load('mirDuplex');
% %%
% i = 1;
% model = candidateMiRnaDuplexModel;
% hairpinBracket = hairpinBracket{i};
% hairpin5pArmMatchPos = hairpin5pArmMatchPos{i};
% hairpin3pArmMatchPos = hairpin3pArmMatchPos{i};
% hairpinTipPos = hairpinTipPos(i);
% Param.Verbose = 1;
%%


% initialize duplex position matrix
duplex = zeros(0, 4);
overhang = zeros(0, 2);

% get hairpin sequence length
hairpinSeqLength = length(hairpinBracket);
% howmany = 0;
% total = 0;
for duplex5pStrand5pEndPos = max(1, hairpinTipPos - model.Strand5pEnd5pSeqDistFromTip(2)) ...
    : hairpinTipPos - model.Strand5pEnd5pSeqDistFromTip(1) + 1
    
    for duplex5pStrand3pEndPos = duplex5pStrand5pEndPos + ...
            model.strand5pSeqLengthLim(1) - ...
            1 : min((duplex5pStrand5pEndPos + model.strand5pSeqLengthLim(2) - 1), ...
            hairpinTipPos - model.Strand5pEnd3pSeqDistFromTip + 1);
        
        for duplex3pStrand5pEndPos = hairpinTipPos + model.Strand3pEnd5pSeqDistFromTip(1) -1 ...
                : hairpinTipPos + model.Strand3pEnd5pSeqDistFromTip(2)
            %duplex3pStrand5pEndPos
            
            
            a = duplex3pStrand5pEndPos + model.strand3pSeqLengthLim(2);
            b = hairpinTipPos + model.Strand3pEnd3pSeqDistFromTip(2);
            c = hairpinSeqLength;
            A = [a,b,c];           
            %strand3p_3pendpos = min(A);
       
            for duplex3pStrand3pEndPos = duplex3pStrand5pEndPos + ...
                    model.strand3pSeqLengthLim(1) - ...
                    1 : min(A);                 
                %total = total+1;                
                thisMiRnaDuplex = [duplex5pStrand5pEndPos duplex5pStrand3pEndPos...
                    duplex3pStrand5pEndPos duplex3pStrand3pEndPos];
%                 Param.Verbose = 1;
                if Param.Verbose
                    fprintf('\nChecking [%d %d %d %d]...', duplex5pStrand5pEndPos, ...
                        duplex5pStrand3pEndPos, duplex3pStrand5pEndPos, ...
                        duplex3pStrand3pEndPos);
                end
                
                [ijklCandidateIsMiRnaDuplex ijklOverhang] = ...
                    org.mensxmachina.mirna.iscandidatemirnaduplexq...
                    (model, hairpinBracket, hairpin5pArmMatchPos, ...
                    hairpin3pArmMatchPos, thisMiRnaDuplex, Param);
                
                if ~ijklCandidateIsMiRnaDuplex
                    continue;
                end
                
                % ladies and gentlemen, we have a candidate!
                if duplex3pStrand3pEndPos <= hairpinSeqLength %nestoras start
                    % add the candidate duplex
                    duplex = [duplex; thisMiRnaDuplex];
                    % add the overhangs
                    overhang = [overhang; ijklOverhang];
                else 
                    fprintf('Invalid candidate!!!!!!!!!!!, Nestoras');
                end  %Nestoras end
                
                if Param.Verbose
                    fprintf(' Valid candidate.');
                    %howmany = howmany + 1;
                end                 
                
            end
            
        end
    end
end
   
end










