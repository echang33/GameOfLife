function varargout = Chang_problem3(varargin)
% CHANG_PROBLEM3 MATLAB code for Chang_problem3.fig
%      CHANG_PROBLEM3, by itself, creates a new CHANG_PROBLEM3 or raises the existing
%      singleton*.
%
%      H = CHANG_PROBLEM3 returns the handle to a new CHANG_PROBLEM3 or the handle to
%      the existing singleton*.
%
%      CHANG_PROBLEM3('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CHANG_PROBLEM3.M with the given input arguments.
%
%      CHANG_PROBLEM3('Property','Value',...) creates a new CHANG_PROBLEM3 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Chang_problem3_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Chang_problem3_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Chang_problem3

% Last Modified by GUIDE v2.5 16-Jan-2024 16:37:49

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Chang_problem3_OpeningFcn, ...
                   'gui_OutputFcn',  @Chang_problem3_OutputFcn, ...
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


% --- Executes just before Chang_problem3 is made visible.
function Chang_problem3_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Chang_problem3 (see VARARGIN)

% Choose default command line output for Chang_problem3
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Chang_problem3 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Chang_problem3_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function import_data_Callback(hObject, eventdata, handles)
% hObject    handle to import_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of import_data as text
%        str2double(get(hObject,'String')) returns contents of import_data as a double
input_file = get(handles.import_data, 'String');
decoder = @RLE_decoder
raw_data = decoder(input_file);


setappdata(handles.import_data,'matrix',raw_data);


% --- Executes during object creation, after setting all properties.
function import_data_CreateFcn(hObject, eventdata, handles)
% hObject    handle to import_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in load.
function load_Callback(hObject, eventdata, handles)
% hObject    handle to load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disp = getappdata(handles.import_data,'matrix');

% set generation counter to 0
gens = 0;

disp = padarray(disp,[1,1],0);

% plot
colormap(gray);
imagesc(disp)
title(strcat('generation',{' '},num2str(gens)))

% set data for matrix and generation
setappdata(handles.generations,"generation",gens);
setappdata(handles.import_data,'matrix',disp);

% --- Executes on button press in randomize.
function randomize_Callback(hObject, eventdata, handles)
% hObject    handle to randomize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% create random 50x50 matrix
soup = randi([0,1], 50,50);
padarray(soup,[1,1],0);


setappdata(handles.import_data,'matrix',soup);

gens = 0;

% plot, update data
colormap(gray);
imagesc(soup)
title(strcat('generation',{' '},num2str(gens)))
setappdata(handles.generations,"generation",gens);

% --- Executes on button press in clear.
function clear_Callback(hObject, eventdata, handles)
% hObject    handle to clear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% reset axes, data
axes(handles.axes1);
setappdata(handles.generations,'generation',0);
title('');
cla;

% --- Executes on button press in step.
function step_Callback(hObject, eventdata, handles)
% hObject    handle to step (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disp = getappdata(handles.import_data,'matrix');

% run GOL for matrix, display next gen
game = @GOL;
next = game(disp);
setappdata(handles.import_data,'matrix', next);

% update generation counter 
gens = getappdata(handles.generations,"generation");
if isequal(gens, double.empty)
    gens = 0;
end
gens = gens + 1;

% plot, update
colormap(gray);
imagesc(next)
title(strcat('generation',{' '},num2str(gens)))
setappdata(handles.generations,"generation",gens);

% --- Executes on selection change in frame_rate.
function frame_rate_Callback(hObject, eventdata, handles)
% hObject    handle to frame_rate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns frame_rate contents as cell array
%        contents{get(hObject,'Value')} returns selected item from frame_rate
val = get(handles.frame_rate,'Value');

if val == 2
    fr = 0.5;
elseif val == 3
    fr = 1;
elseif val == 4
    fr = 5;
elseif val == 5
    fr = 10;
elseif val == 6
    fr = 25;
elseif val == 7
    fr = 50;
elseif val == 8
    fr = 100;    
else
    fr = 1;    
end

% set framerate based on input
setappdata(handles.frame_rate,'framerate',fr);

% --- Executes during object creation, after setting all properties.
function frame_rate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to frame_rate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in generations.
function generations_Callback(hObject, eventdata, handles)
% hObject    handle to generations (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns generations contents as cell array
%        contents{get(hObject,'Value')} returns selected item from generations
val = get(handles.generations,'Value');

if val <= 22
    for i=1:22
        if i == val
            maxgens = (val-2)*5;
            break
        end
    end
else
    if val == 23
        maxgens = 150;
    elseif val == 24
        maxgens = 200;
    elseif val == 25
        maxgens = 250
    elseif val == 26
        maxgens = 500
    else
        maxgens = 9999999999;
    end
end
setappdata(handles.generations,"maxgens",maxgens);


% --- Executes during object creation, after setting all properties.
function generations_CreateFcn(hObject, eventdata, handles)
% hObject    handle to generations (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in stop.
function stop_Callback(hObject, eventdata, handles)
% hObject    handle to stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of stop


% --- Executes on button press in play.
function play_Callback(hObject, eventdata, handles)
% hObject    handle to play (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

matrix = getappdata(handles.import_data,'matrix');

[x,y] = size(matrix);

% first frame is starting matrix
F(1) = getframe(handles.axes1);

% if no generaion limit is set, run indefinitely
maxgens = getappdata(handles.generations,"maxgens");
if isequal(maxgens, double.empty)
    maxgens = 999999;
end

% run until the set generation, or until stop is hit 
i = 2;
for j = 1:1:maxgens
    go = get(handles.stop,'Value');
    if go == 1
        break;
    end
    fr = getappdata(handles.frame_rate,'framerate');
    if isequal(fr, double.empty)
        fr = 1;
    end
    game = @GOL;
    next = game(matrix);
    setappdata(handles.import_data,'matrix',next);
    
    gens = getappdata(handles.generations,"generation");
    if isequal(gens, double.empty)
        gens = 0;
    end
    gens = gens + 1;
    
    colormap(gray);
    imagesc(next)
    title(strcat('generation',{' '},num2str(gens)))
    setappdata(handles.generations,"generation",gens);

    F(i) = getframe(handles.axes1);
    
    matrix = next;
    
    stop = 1./fr - 0.1;
    pause(stop);
    go = get(handles.stop,'Value');
    i = i + 1;
end


setappdata(handles.play,'movieframes',F);


% --- Executes on button press in export_movie.
function export_movie_Callback(hObject, eventdata, handles)
% hObject    handle to export_movie (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

frames = getappdata(handles.play,'movieframes');
name = getappdata(handles.movie_name,'movie_name');
video = VideoWriter(strcat(name,'.avi'), "Uncompressed AVI");

% since array dynamically resizes, make every frame 1000x1000 so
% writeVideo function can be used
for a = 1:1:length(frames)
    frames(a).cdata = imresize(frames(a).cdata,[1000 1000]);
end

fr = getappdata(handles.frame_rate,'framerate');
if isequal(fr, double.empty)
    fr = 1;
end
video.FrameRate = fr;


open(video)
writeVideo(video,frames);
close(video)



function movie_name_Callback(hObject, eventdata, handles)
% hObject    handle to movie_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of movie_name as text
%        str2double(get(hObject,'String')) returns contents of movie_name as a double
name = get(handles.movie_name, 'String');
setappdata(handles.movie_name,'movie_name',name);


% --- Executes during object creation, after setting all properties.
function movie_name_CreateFcn(hObject, eventdata, handles)
% hObject    handle to movie_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in export_frame.
function export_frame_Callback(hObject, eventdata, handles)
% hObject    handle to export_frame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

frame = getframe(handles.axes1);
image = frame2im(frame);
filename = strcat(getappdata(handles.frame_name,'frame_name'),'.png');
imwrite(image , filename);



function frame_name_Callback(hObject, eventdata, handles)
% hObject    handle to frame_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of frame_name as text
%        str2double(get(hObject,'String')) returns contents of frame_name as a double

name = get(handles.frame_name, 'String');
setappdata(handles.frame_name,'frame_name',name);


% --- Executes during object creation, after setting all properties.
function frame_name_CreateFcn(hObject, eventdata, handles)
% hObject    handle to frame_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in expand.
function expand_Callback(hObject, eventdata, handles)
% hObject    handle to expand (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

matrix = getappdata(handles.import_data,'matrix');
new = padarray(matrix,[1,1],0);
setappdata(handles.import_data,'matrix',new);

gens = getappdata(handles.generations,"generation");
if isequal(gens, double.empty)
    gens = 0;
end

colormap(gray);
imagesc(new)
title(strcat('generation',{' '},num2str(gens)))
setappdata(handles.generations,"generation",gens);
