load LiibaanNetNP.mat %NP is the training of nodule and pneumonia

net = LiibaanNetNP  %set the network to a viarable

folder = 'X:\Matlab\Chest X Ray\Disease Data\Disease Classes Training';

Diseases= {'Atelectasis', 'Nodule'};  %using transfer learning on these data sets
%Using folder name is labels
disimg=imageDatastore(fullfile(folder, Diseases),'LabelSource','foldernames');

%splitting the data 80% trianing
[DisTrain,DisTest] = splitEachLabel(disimg,0.8);

%The data is pre-processed for it to be equally trained 
DisTrain=augmentedImageDatastore(inputSize, DisTrain,'ColorPreprocessing','rgb2gray');
DisTest=augmentedImageDatastore(inputSize, DisTest,'ColorPreprocessing','rgb2gray');

layer = net.Layers  % Allows us to see what layers we are working with

layer(end) = classificationLayer   % This will find the last layer and remove the classes stored previously and leaving a place holder

 options = trainingOptions('sgdm', ...  %Training parameters
    'InitialLearnRate',0.01, ...
    'LearnRateDropFactor', 0.1, ...
    'MaxEpochs',10, ...
    'Shuffle','every-epoch', ...
    'ValidationData',DisTest, ...
    'ValidationFrequency',30, ...
    'Verbose',false, ...
    'Plots','training-progress');

LiibaanNetNA = trainNetwork(DisTrain,layer,options); % The netwprk being trained on a new dataset