function [trainCandidateMiRnaDuplex trainCandidateMiRnaDuplexOverhang tf NOTFOUND] = ...
    traincandidatemirnaduplexq(candidateMiRnaDuplex, candidateMiRnaDuplexOverhang, ...
    miRnaDuplex, miRnaDuplexOverhang, Param)
%TRAINCANDIDATEMIRNADUPLEXQ Select candidate miRNA:miRNA* duplexes for training

% find miRNA:miRNA* duplex in candidates
%Param.Verbose = 1;
NOTFOUND = 0;
[miRnaDuplexIsCandidate, miRnaDuplexInd] = ismember(miRnaDuplex, ...
    candidateMiRnaDuplex, 'rows'); 

if miRnaDuplexIsCandidate % miRNA:miRNA* duplex is a candidate
    candidateMiRnaDuplex(miRnaDuplexInd, :) = []; % remove it from candidates
    NOTFOUND = 1;
    if Param.Verbose
        disp('miRNA:miRNA* duplex in candidates: yes');
   
    end
elseif Param.Verbose
    disp('miRNA:miRNA* duplex not in candidates: NO');
   
end

% find training candidates
trainCandidateMiRnaDuplexInd = randperm(size(candidateMiRnaDuplex, 1));
trainCandidateMiRnaDuplexInd = trainCandidateMiRnaDuplexInd(1:Param.Ratio);

% merge them with miRNA:miRNA* duplex
trainCandidateMiRnaDuplex = [miRnaDuplex; candidateMiRnaDuplex(trainCandidateMiRnaDuplexInd, :)];
trainCandidateMiRnaDuplexOverhang = [miRnaDuplexOverhang; ...
    candidateMiRnaDuplexOverhang(trainCandidateMiRnaDuplexInd, :)];
tf = [true; false(Param.Ratio, 1)];

end

