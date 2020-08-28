% Start with 2 diseases with the best results from 

%The folder path where my data is located
folder = 'X:\Matlab\Chest X Ray\Disease Data\Disease Classes Training\classimb';


% Selecting the data I need to train
Diseases= {'Atelectasis', 'Cardiomegaly'};

% Storing the class images into a datastore and labelling them
disimg=imageDatastore(fullfile(folder, Diseases),'LabelSource','foldernames');

%double check if 6407 images are in the data storage
fname= disimg.Files;

%Double check if the data is labelled
labelling=disimg.Labels;
% Splitting the data for training and Testing
[DisTrain,DisTest] = splitEachLabel(disimg,0.8);

%Pre processing the data to have an input resolution os 224x224 and making
%it gray scale
inputSize=[256 256 1];
DisTrain=augmentedImageDatastore(inputSize, DisTrain,'ColorPreprocessing','rgb2gray');
DisTest=augmentedImageDatastore(inputSize, DisTest,'ColorPreprocessing','rgb2gray');


% __________________Hidden Layers_____________%
layers = [
    imageInputLayer([256 256 1])
    
    convolution2dLayer(3,4,'Padding','same')
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer(2,'Stride',2)
    
    convolution2dLayer(3,16,'Padding','same')
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer(2,'Stride',2)
    
    convolution2dLayer(3,32,'Padding','same')
    batchNormalizationLayer
    reluLayer
    
    fullyConnectedLayer(3)
    softmaxLayer
    classificationLayer];

options = trainingOptions('sgdm', ...   % Setting the training parameters for the network
    'InitialLearnRate',0.01, ...
    'LearnRateDropFactor', 0.1, ...
    'MaxEpochs',10, ...
    'Shuffle','every-epoch', ...
    'ValidationData',DisTest, ...
    'ValidationFrequency',30, ...
    'Verbose',false, ...
    'Plots','training-progress');

LiibaanNet = trainNetwork(DisTrain,layers,options); %Training of network

save LiibaanNet; % This will save the network as a .MAT file which will we can access later on when applying transfer learning