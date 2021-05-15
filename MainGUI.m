function varargout = MainGUI(varargin)
% MAINGUI MATLAB code for MainGUI.fig
%      MAINGUI, by itself, creates a new MAINGUI or raises the existing
%      singleton*.
%
%      H = MAINGUI returns the handle to a new MAINGUI or the handle to
%      the existing singleton*.
%
%      MAINGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAINGUI.M with the given input arguments.
%
%      MAINGUI('Property','Value',...) creates a new MAINGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MainGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MainGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MainGUI

% Last Modified by GUIDE v2.5 27-Jul-2016 15:30:34

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MainGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @MainGUI_OutputFcn, ...
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


% --- Executes just before MainGUI is made visible.
function MainGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MainGUI (see VARARGIN)

% Choose default command line output for MainGUI
handles.output = hObject;
handles.count = 0;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MainGUI wait for user response (see UIRESUME)
% uiwait(handles.GUI1);


% --- Outputs from this function are returned to the command line.
function varargout = MainGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Browser.
function Browser_Callback(hObject, eventdata, handles)

[filename pathname] = uigetfile({'*.png'},'File Selector');
%Reads in the file.


if handles.count ==1
    cla;
end %If not the first file, clears axes for the next image.


fullpathname = strcat(pathname,filename);
img = imread(fullpathname);
handles.currImg = img;
handles.fullpathname = fullpathname;
set(handles.FileName,'String',fullpathname);%Changes string of filename textbox
handles.img =img;%Permanent declaration throughout the GUI 
imshow(img);
handles.count = 1;


%h= msgbox({'I am having trouble finding the roads.' 'Please click on an obvious road for me'});
%%%%Runs the initial segmenter to start off the program.
guidata(hObject,handles);
if (strcmp(filename,'SimpleRoad.png'))||(strcmp(filename,'ForkRoad.png'))
    set(handles.SegMethod,'Value',2);
    SegMethod_Callback(handles.SegMethod,eventdata,handles);
elseif (strcmp(filename,'OverPass1.png'))||(strcmp(filename,'Overpass2.png'))||(strcmp(filename,'OverPass3.png'))
    set(handles.SegMethod,'Value',3);
    SegMethod_Callback(handles.SegMethod,eventdata,handles);
else
     set(handles.SegMethod,'Value',1);
    SegMethod_Callback(handles.SegMethod,eventdata,handles);
end
%{        
MOVED TO SEGMETHOD CALLBACK.

h= msgbox('Initializing. Please wait...');
CC= imSegment(img);
handles.CC = CC;
delete(h);%Deletes the Message Box after segmenter is done.
X = zeros(1,CC.NumObjects); %Initializes selected component matrix.
handles.X = X;
%h1 = msgbox('To begin selecting roads, check the box.''When you are done, uncheck the box.');
%}
%X=Interactivity(CC,X);


%{
%MOVED TO SELECTEDROADS
[m,n,xxx] = size(img);%Image Size
for i = 1:m
    for j =1:n %If colors are within a threshhold of 3 away, then make them blue
        if abs(img(i,j,1)-pixR)<3 && abs(img(i,j,2)-pixG)<3 && abs(img(i,j,3)-pixB)<3
            currImg(i,j,1)= 0;
            currImg(i,j,2) = 0;
            currImg(i,j,3) = 255;
        end
    end
end
imshow(currImg);
%}       
            
  

% hObject    handle to Browser (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
 % eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function FileName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FileName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
str = get(hObject, 'String');
val = get(hObject,'Value');

    if val==1
        CC=imageSegmenter(handles.fullpathname);
        X = zeros(1,CC.NumObjects);
  
    elseif val ==2
        
        CC=blurSegmentation(handles.fullpathname);
        X = zeros(1,CC.NumObjects);
    
        elseif val==3
        
        CC =basicSegmentation(handles.fullpathname);
        X = zeros(1,CC.NumObjects);
    elseif val ==4
        
        CC = colorBasedSeg(handles.fullpathname);
        X = zeros(1,CC.NumObjects);
    elseif val ==5
        
        CC = ext_grad_seg(handles.fullpathname);
        X = zeros(1,CC.NumObjects);
    end

currImg = handles.img;

Interactivity(CC,handles.img,currImg,X);
% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

     

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in shadowDetection.
function shadowDetection_Callback(hObject, eventdata, handles)
% hObject    handle to shadowDetection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
val = get(hObject,'Value');
% Hint: get(hObject,'Value') returns toggle state of shadowDetection
img = handles.currImg;

img2 = selectedRoads(img,handles.CC,handles.X);
if val ==1
    
    shadows(img2);
else
    imshow(img2);
end



% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox3


% --- Executes on button press in ShowAll.
function ShowAll_Callback(hObject, eventdata, handles)
% hObject    handle to ShowAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
val = get(hObject,'Value')

CC=handles.CC;
X=handles.X;
ci = handles.currImg;
if (val == 1)
    %allRoads = label2rgb(labelmatrix(CC), 'parula', 'b', 'shuffle');
    img2 = showAllRoads(ci,CC,X);
    img3 = selectedRoads(img2,CC,X);
    imshow(img3);
    handles.currImg = img2;
else
    handles.currImg = handles.img;
    img2 = selectedRoads(handles.img,CC,handles.X);
    imshow(img2);
end
handles.X = X;
handles.CC= CC;
guidata(hObject,handles);



% Hint: get(hObject,'Value') returns toggle state of ShowAll



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1


% --- Executes on mouse press over axes background.
function axes1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Selecter.
function Selecter_Callback(hObject, eventdata, handles)

% hObject    handle to Selecter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CC=handles.CC;
X = handles.X;
img = handles.currImg;
while (get(hObject,'Value')==1)
    X=Interactivity(img,CC,X);
    imshow(selectedRoads(img, CC,X));
    
end
handles.X = X;

guidata(hObject,handles);
    
% Hint: get(hObject,'Value') returns toggle state of Selecter


% --- Executes on button press in CustButton.
function CustButton_Callback(hObject, eventdata, handles)
% hObject    handle to CustButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Custom.m;


% --- Executes on button press in Faker.
function Faker_Callback(hObject, eventdata, handles)
% hObject    handle to Faker (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

img = handles.img;
fullpathname = handles.fullpathname;
[a,b] = size(fullpathname);
num = 0;
for i= 1:b
    if (fullpathname(i) =='.')
        num = i
    end
end
str1 = fullpathname(1:num-1);
str2 = fullpathname(num:b);
fakepath = strcat(str1,'fake',str2);

fakeImg = imread(fakepath);

%Changes string of filename textbox
%Permanent declaration throughout the GUI 

h= msgbox('Fake it until you make it.');
imshow(img);
handles.currImg = img;
%h= msgbox({'I am having trouble finding the roads.' 'Please click on an obvious road for me'});
%%%%Runs the initial segmenter to start off the program.
CC= majorSegmentation(fakeImg);
handles.CC = CC;
delete(h);%Deletes the Message Box after segmenter is done.
X = zeros(1,CC.NumObjects); %Initializes selected component matrix.
handles.X = X;
   
  
guidata(hObject,handles);


% --- Executes on button press in clearer.
function clearer_Callback(hObject, eventdata, handles)
cla;
set(handles.FileName,'String','');
set(handles.Selecter,'Value',0);
set(handles.shadowDetection,'Value',0);
set(handles.ShowAll,'Value',0);
guidata(hObject,handles);


% hObject    handle to clearer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Saver.
function Saver_Callback(hObject, eventdata, handles)
% hObject    handle to Saver (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in SegMethod.
function SegMethod_Callback(hObject, eventdata, handles)
val = get(hObject,'Value');
if val==1
    h= msgbox('Initializing. Please Wait');
    CC =majorSegmentation(handles.img);
    delete(h);
    
    X=zeros(1,CC.NumObjects);
elseif val==2
   % set(handles.SegMethod,'String','Simple Segmentation');
    h= msgbox('Initializing. Please Wait');
    CC =simpleSegmentation(handles.img);
    delete(h);
    
    X=zeros(1,CC.NumObjects);
else
    %set(handles.SegMethod,'String','Overpass Segmentation');
     h= msgbox('Initializing. Please Wait');
    CC = overpassSegmentation(handles.img);
    delete(h);
    X=zeros(1,CC.NumObjects);
end
set(handles.Selecter,'Value',0);
set(handles.shadowDetection,'Value',0);
set(handles.ShowAll,'Value',0);
handles.CC = CC;
handles.X = X;
guidata(hObject,handles);

% hObject    handle to SegMethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns SegMethod contents as cell array
%        contents{get(hObject,'Value')} returns selected item from SegMethod


% --- Executes during object creation, after setting all properties.
function SegMethod_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SegMethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
