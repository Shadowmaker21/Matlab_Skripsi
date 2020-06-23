clear all
close all
img=imread('C33P1thinF_IMG_20150619_115740a_cell_162.png');
img=rgb2gray(img);
imgr=img;
img(img==0)=255;
%level = graythresh(img);
level=0.5;
img=~im2bw(img,level);
imgr((img==0))=0;
imshow(imgr)