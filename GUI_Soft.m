function varargout = GUI_Soft(varargin)
% GUI_SOFT MATLAB code for GUI_Soft.fig
%      GUI_SOFT, by itself, creates a new GUI_SOFT or raises the existing
%      singleton*.
%
%      H = GUI_SOFT returns the handle to a new GUI_SOFT or the handle to
%      the existing singleton*.
%
%      GUI_SOFT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_SOFT.M with the given input arguments.
%
%      GUI_SOFT('Property','Value',...) creates a new GUI_SOFT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_Soft_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_Soft_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_Soft

% Last Modified by GUIDE v2.5 09-Aug-2019 17:20:29

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_Soft_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_Soft_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before GUI_Soft is made visible.
function GUI_Soft_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_Soft (see VARARGIN)

% Choose default command line output for GUI_Soft
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_Soft wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_Soft_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function uipushtool2_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,path]=uigetfile('*.png','Pilih Citra');
if isequal(filename,0)
    return
end
img=imread(fullfile(path,filename));
axes(handles.axes1)
imshow(img)
setappdata(handles.figure1,'img',img)


% --------------------------------------------------------------------
function uipushtool3_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
img=getappdata(handles.figure1,'img');
whos img
img=rgb2gray(img);
imgr=img;
img(img==0)=255;
level=0.5;
img=~im2bw(img,level);
imgr((img==0))=0;
imshow(imgr)
st=chip_histogram_features(imgr);
st(isnan(st))=0;
load svmStruct
class = svmclassify(svmStruct,st);
set(handles.edit1,'string',class)
% --------------------------------------------------------------------
function uipushtool4_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
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
        pause(0.01)
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
load featall
xdata = cell2mat(featall(:,3));
xdata(isnan(xdata))=0;
%xdata=xdata(:,2:3);
group = featall(:,2);
svmStruct = svmtrain(xdata,group,'ShowPlot',true);
class = svmclassify(svmStruct,xdata,'ShowPlot',true);
hasil=[group class];

for i=1:size(group,1)
    v(i,:)=strcmp(group(i,:),class(i,:));
end
akurasi=(sum(v)/numel(v))*100;
warndlg(['Akurasi Pelatihan SVM: ', num2str(akurasi),' %'])

save svmStruct svmStruct

xdata(isnan(xdata))=0;
xdata=xdata(:,2:3);
group = featall(:,2);
figure
svmStruct = svmtrain(xdata,group,'ShowPlot',true);



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
img=getappdata(handles.figure1,'img');
whos img
% img=rgb2gray(img);
% imgr=img;
% img(img==0)=255;
% level=0.5;
% img=~im2bw(img,level);
% imgr((img==0))=0;
% imshow(imgr)
% st=chip_histogram_features(imgr);
% st(isnan(st))=0;
% load svmStruct
% class = svmclassify(svmStruct,st);
% set(handles.edit1,'string',class)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
