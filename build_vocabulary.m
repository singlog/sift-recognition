
siftdir = './sift/';
framesdir = './frames/';


fnames = dir([siftdir '/*.mat']);
numframe = length(fnames);

rand = randperm(numframe);
rand = rand(1:200);
feat = [];

for i=rand
    fname = [siftdir '/' fnames(i).name];
    load(fname);
    numfeat = size(descriptors,1);
    feat = [feat; descriptors];
end

[member,means,~] = kmeansML(1500,feat');
means = means';
member = member';
save('kmeans.mat','means');

imwords = zeros(numframe,1500);
names = zeros(numframe,23);

bin = 1:1500;

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




