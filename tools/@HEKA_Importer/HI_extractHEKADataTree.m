function HI_extractHEKADataTree(obj)

% Function to extract parameters from the HEKA data tree and sort them
% according to the recordings.
% Takes HEKA_IMPORTER object as input and creates RecTable
% containing the recording parameters for each recording/series.
%
% See also	HEKA_Importer
% 			HEKA_Importer.HI_loadHEKAFile
% 			HEKA_Importer.HI_ImportHEKAtoMat
% 			HEKA_Importer.HI_extractHEKASolutionTree
% 			HEKA_Importer.HI_extractHEKAStimTree

%1: Root
%2: Group/Experiment
%3: Series/Recording number
%4: Sweep
%5: Trace/Channel

dataTree = obj.trees.dataTree;

allExp = find(~cellfun(@isempty,dataTree(:,2)));
nExperiments = numel(allExp);

Rt = cell(nExperiments,1);

for iExp = 1:nExperiments
	if iExp == nExperiments
		nextExp = size(dataTree,1)+1;
	else
		nextExp = allExp(iExp+1);
	end
	Rt{iExp} = ImportRecordings(dataTree,allExp(iExp),nextExp,iExp);
end

obj.RecTable = [vertcat(Rt{:}),obj.RecTable];



end



function RecTab = ImportRecordings(dataTree,thisExpID,nextExpID,ExpNum)


% RESORT STRUCTURES TO ALSO CONTAIN SWEEP AND TRACE/CHANNEL INFORMATION
recIDs = find(~cellfun(@isempty,dataTree(:,3)));
recIDs = recIDs(recIDs>thisExpID & recIDs<nextExpID);

sweepSt = recIDs+1; sweepEnd = [recIDs(2:end)-1;size(dataTree,1)];

for iR = 1:numel(recIDs)
	% GET RECORDING INFORMATION
	Recs(iR) = dataTree{recIDs(iR),3};
	%GET ASSOCIATED SWEEPS & TRACES
	Recs(iR).Sweeps = ImportSweeps(dataTree(sweepSt(iR):sweepEnd(iR),4:5));	
end


% GET EXPERIMENT NAMES
nRecs = numel(Recs);
ExperimentName = repmat({dataTree{thisExpID,2}.GrLabel},nRecs,1);
ExperimentNumber = repmat(ExpNum,nRecs,1);
RecNum = reshape(1:nRecs,nRecs,1);

%EXTRACT INFORMATION FROM LEVEL 3
Stimulus = reshape({Recs(:).SeLabel},numel(Recs),1);
Comment = reshape({Recs(:).SeComment},numel(Recs),1);
nSweeps = reshape([Recs(:).SeNumbersw],numel(Recs),1);

%EXTRACT INFORMATION FROM AMPLIFIER STATE, LEVEL 3
AmpState = [Recs(:).SeAmplifierState];
Vhold = reshape([AmpState(:).E9VHold],numel(AmpState),1);

	% THIS ONLY READS OUT THE Rs/Cm VALUES FOR FIRST SWEEP
% RsFractionComp = reshape([AmpState(:).E9RsFraction],numel(AmpState),1);
% Rs_uncomp = reshape(1./[AmpState(:).E9GSeries],numel(AmpState),1);
% Rs = Rs_uncomp - reshape([AmpState(:).E9RsValue],numel(AmpState),1);
% Cm = reshape([AmpState(:).E9CSlow],numel(AmpState),1);

% ASSUME TEMPERATURE AND SOLUTIONS ARE IDENTICAL BETWEEN SWEEPS AND LOAD
% FIRST SWEEP ONLY OF EACH RECORDING
Temperature = NaN(nRecs,1);
TimeUnit = cell(nRecs,1);
ChUnit = cell(nRecs,1);
ChName = cell(nRecs,1);
SR = NaN(nRecs,1);
RecModeID = cell(nRecs,1);
ExternalSolutionID = cell(nRecs,1);
InternalSolutionID = cell(nRecs,1);
RecordingMode = cell(nRecs,1);

Rs = cell(nRecs,1);
Rs_uncomp = cell(nRecs,1);
RsFractionComp = cell(nRecs,1);
Cm = cell(nRecs,1);

RecModeNames = {'inside-out V-clamp','on-cell V-clamp','outside-out V-clamp','Whole-cell V-clamp','C-clamp','V-clamp','NoMode'};

for iR=1:nRecs
	Temperature(iR,:) = Recs(iR).Sweeps(1).SwTemperature;

	% NOW GET INFORMATION FROM TRACE/CHANNEL LEVEL FOR FIRST SWEEP OF EACH
	% RECORDING
	TimeUnit{iR,:}= {Recs(iR).Sweeps(1).Traces(:).TrXUnit};
	ChUnit{iR,:} = {Recs(iR).Sweeps(1).Traces(:).TrYUnit};
	ChName{iR,:} = {Recs(iR).Sweeps(1).Traces(:).TrLabel};
	SR(iR,:) = 1/(Recs(iR).Sweeps(1).Traces(1).TrXInterval);
	
	RecModeID{iR,:} = [Recs(iR).Sweeps(1).Traces(:).TrRecordingMode];
	RecordingMode{iR,:} = reshape(RecModeNames(RecModeID{iR}+1),1,numel(RecModeID{iR,:}));
	
	% SOLUTIONS SHOULD BE IDENTICAL FOR EACH CHANNEL, SO IMPORT FIRST
	% CHANNEL ONLY
	ExternalSolutionID{iR,:} = [Recs(iR).Sweeps(1).Traces(1).TrExternalSolution];
	InternalSolutionID{iR,:} = [Recs(iR).Sweeps(1).Traces(1).TrInternalSolution];
	
	Rs{iR} = NaN(1,Recs(iR).SeNumbersw);
	Rs_uncomp{iR} = NaN(1,Recs(iR).SeNumbersw);
	RsFractionComp{iR} = NaN(1,Recs(iR).SeNumbersw);
	Cm{iR} = NaN(1,Recs(iR).SeNumbersw);
	for iS=1:size(Recs(iR).Sweeps, 2)%zh changed 
%         	for iS=1:Recs(iR).SeNumbersw%original
		Rs_uncomp{iR}(iS) = 1/Recs(iR).Sweeps(iS).Traces(1).TrGSeries;
		Rs{iR}(iS) = Rs_uncomp{iR}(iS) - Recs(iR).Sweeps(iS).Traces(1).TrRsValue;
		Cm{iR}(iS) = Recs(iR).Sweeps(iS).Traces(1).TrCSlow;
	end
		RsFractionComp{iR} = 1-Rs{iR}./Rs_uncomp{iR};

end


% COMPILE DATA IN TABLE
RecTab = table(ExperimentNumber,...
	ExperimentName,...
	RecNum,...
	Rs,...
	Cm,...
	nSweeps,...
	Vhold,...
	Rs_uncomp,...
	RsFractionComp,...
	Stimulus,...
	TimeUnit,...
	ChUnit,...
	ChName,...
	Comment,...
	RecordingMode,...
	Temperature,...
	ExternalSolutionID,...
	InternalSolutionID,...
	SR,...
	'VariableNames',{'Experiment',...
	'ExperimentName',...
	'Rec',...
	'Rs',...
	'Cm',...
	'nSweeps',...
	'Vhold',...
	'Rs_uncomp',...
	'RsFractionComp',...
	'Stimulus',...
	'TimeUnit',...
	'ChUnit',...
	'ChName',...
	'Comment',...
	'RecMode',...
	'Temperature',...
	'ExternalSolution',...
	'InternalSolution',...
	'SR'});
end


function Sweeps = ImportSweeps(dataTree)

sweepIDs = find(~cellfun(@isempty,dataTree(:,1)));
traceSt = sweepIDs+1;

if numel(sweepIDs)>1
	traceEnd = [sweepIDs(2:end)-1;size(dataTree,1)];
else
	traceEnd = size(dataTree,1);
end

for iS = 1:numel(sweepIDs)
	Sweeps(iS) = dataTree{sweepIDs(iS),1};
	Sweeps(iS).Traces = [dataTree{traceSt(iS):traceEnd(iS),2}];
end



end




