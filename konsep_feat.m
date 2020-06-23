clear all
close all
clc
d1=dir('Data');
jj=0;
for i=3:size(d1,1)
    folder1=d1(i).name;
    d2=dir(['Data\',folder1]);
    for j=3:size(d2,1)
        jj=jj+1;
        filename1=d2(j).name;
        img=imread(['Data\',folder1,'\',filename1]);
        img=rgb2gray(img);
        imgr=img;
        img(img==0)=255;
        level=0.5;
        img=~im2bw(img,level);
        imgr((img==0))=0;
        imshow(imgr)
        a=i-2;
        if a==1
            k={'normal'};
        elseif a==2
            k={'infeksi'};
        end
        featall(jj,:) = [ {filename1} k {chip_histogram_features(imgr)}];
    end
end
save featall featall
