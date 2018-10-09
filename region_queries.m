%{
Created on 05/23/2018

This script illustrates using sift features and bag-of-words 
representationfor instance recognition.

User can select a polygon region on a popped up image and 
the script findsthe other images with the similar region.
The sift feature description is shown to be translation 
invariant and scaleinvariant.

The bag-of-words representation and the visual vocabulary 
is pre-computed with build_vocalubary.m
%}

clear;
load words.mat;
load kmeans.mat;

framedir = './frames/';
siftdir = './sift/';
bin = 1:1500;

%the frames used for illustrating
frame_names = ["0000003652.jpeg","0000000401.jpeg","0000005806.jpeg","0000003553.jpeg"];

for i = 1:4
    im = imread([framedir char(frame_names(1,i))]);
    load([siftdir char(frame_names(1,i)) '.mat']);
    
    imshow(im);
    h = impoly(gca, []);
    api = iptgetapi(h);
    polygon = api.getPosition();
    
    ptsin = inpolygon(positions(:,1),positions(:,2),polygon(:,1),polygon(:,2));
    ind = find(ptsin == 1);
    feats = descriptors(ind,:);
    
    %find the frame with the most similar visual word histogram
    
    dist = dist2(feats,means);
    [~,minind] = min(dist,[],2);
    [word,~] = hist(minind,bin);
    normalP = (imwords * word') ./ vecnorm(imwords,2,2);

    
    [~,maxind] = sort(normalP,'descend');
    notnan = find(~isnan(sort(normalP,'descend')));
    
    for j=1:6
        fname = names(maxind(notnan(1)+j),:);
        im = imread(['./frames/' fname]);
        subplot(3,2,j);
        imshow(im);
    end
    pause;
    close;

end
