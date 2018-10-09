%{
Created on 05/20/2018

Run this script to build a bag-of-words description for images with
pre-computed sift features for each frame.
The script first build a vocabulary of descriptors,
i.e. classify the descriptors into clusters.
%}

siftdir = './sift/';
framesdir = './frames/';


fnames = dir([siftdir '/*.mat']);
numframe = length(fnames);

%build the feature vocabulary from a random sample of size 200 (frames).
%In this case, the number 200 produces a desriable result.

rand = randperm(numframe);
rand = rand(1:200);
feat = [];

for i=rand
    fname = [siftdir '/' fnames(i).name];
    load(fname);
    numfeat = size(descriptors,1);
    feat = [feat; descriptors];
end

%classify the features into 1500 clusters
%save the mean parameters for later sift descriptors classification.

[member,means,~] = kmeansML(1500,feat');
means = means';
member = member';
save('kmeans.mat','means');

imwords = zeros(numframe,1500);
names = zeros(numframe,23);

bin = 1:1500;

%for each frame, classify the descriptors into 1500 bins.
%save the frame as a histogram of the bins.
%save all the frame data into one .mat file.

for i=1:numframe
   
    fname = [siftdir fnames(i).name];
    load(fname);
    dist = dist2(descriptors,means);
    [~,minind] = min(dist,[],2);
    
    [count,~] = hist(minind,bin);
    imwords(i,:) = count;
    names(i,:) = imname;
end

names = char(names);
save('words.mat','imwords','names');




