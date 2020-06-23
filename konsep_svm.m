clear all
close all
clc
load featall
% xdata = cell2mat(featall(:,3));
xdata(isnan(xdata))=0;
%xdata=xdata(:,2:3);
group = featall(:,2);
svmStruct = svmtrain(xdata,group,'ShowPlot',true);
class = svmclassify(svmStruct,xdata,'ShowPlot',true);
hasil=[group class];

for i=1:size(group,1)
    v(i,:)=strcmp(group(i,:),class(i,:));
end
akurasi=(sum(v)/numel(v))*100
commandwindow
% 
% hold on;
% plot(5,2,'ro','MarkerSize',12);
% hold off
