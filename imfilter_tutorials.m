function varargout = imfilter_tutorials(varargin)
% IMFILTER_TUTORIALS MATLAB code for imfilter_tutorials.fig
%      IMFILTER_TUTORIALS, by itself, creates a new IMFILTER_TUTORIALS or raises the existing
%      singleton*.
%
%      H = IMFILTER_TUTORIALS returns the handle to a new IMFILTER_TUTORIALS or the handle to
%      the existing singleton*.
%
%      IMFILTER_TUTORIALS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IMFILTER_TUTORIALS.M with the given input arguments.
%
%      IMFILTER_TUTORIALS('Property','Value',...) creates a new IMFILTER_TUTORIALS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before imfilter_tutorials_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to imfilter_tutorials_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help imfilter_tutorials

% Last Modified by GUIDE v2.5 06-May-2022 17:17:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @imfilter_tutorials_OpeningFcn, ...
                   'gui_OutputFcn',  @imfilter_tutorials_OutputFcn, ...
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


% --- Executes just before imfilter_tutorials is made visible.
function imfilter_tutorials_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to imfilter_tutorials (see VARARGIN)

% Choose default command line output for imfilter_tutorials
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes imfilter_tutorials wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% Set default images
axes(handles.axes_input); imagesc(zeros(100,100,3,'uint8')); axis off;
axes(handles.axes_output); imagesc(zeros(100,100,3,'uint8')); axis off;
axes(handles.axes_kernel); imagesc(zeros(3)); caxis([0 1]); colormap jet; grid on; axis off;

% Set 'enable' state of components
set(handles.text_radius,'Enable','Off');
set(handles.text_sigma,'Enable','Off');
set(handles.text_alpha,'Enable','Off');
set(handles.text_length,'Enable','Off');
set(handles.text_theta,'Enable','Off');
set(handles.edit_radius,'Enable','Off');
set(handles.edit_sigma,'Enable','Off');
set(handles.edit_alpha,'Enable','Off');
set(handles.edit_length,'Enable','Off');
set(handles.edit_theta,'Enable','Off');
set(handles.slider_theta,'Enable','Off');
set(handles.checkbox_transpose,'Enable','Off');

set(handles.pushbutton_load_image,'String','Load Image');

% Set default propertires of components
set(handles.slider_theta,'Min',0,'Max',360,'SliderStep',[1/360 10/360]);



% --- Outputs from this function are returned to the command line.
function varargout = imfilter_tutorials_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton_load_image.
function pushbutton_load_image_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_load_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global input_image; global output_image; 
global kernel_type; 
global h; global pad_opt; global output_size;

% get image filepath
[file,path] = uigetfile({'*.jpg;*.bmp;*.png;*.tif','Image Files (*.jpg;*.bmp;*.png;*.tif)';},'Select an Image');

if ~isempty(file)

% read image
input_image = imread(fullfile(path,file));

% get kernel type
type_list =  get(handles.popupmenu_kernel_type,'String');
value = get(handles.popupmenu_kernel_type,'Value');
kernel_type = type_list{value};

% specify kernel parameters
switch (kernel_type)
    case 'Average'
        size = str2double(get(handles.edit_size,'String'));
        h = fspecial(kernel_type,size);
    case 'Disk'
        radius = str2double(get(handles.edit_radius,'String'));
        h = fspecial(kernel_type,radius);
    case 'Gaussian'
        size = str2double(get(handles.edit_size,'String'));
        sigma = str2double(get(handles.edit_sigma,'String'));
        h = fspecial(kernel_type,size,sigma);
    case 'Laplacian'
        alpha = str2double(get(handles.edit_alpha,'String'));
        h = fspecial(kernel_type,alpha);
    case 'LoG'
        size = str2double(get(handles.edit_size,'String'));
        sigma = str2double(get(handles.edit_sigma,'String'));
        h = fspecial(kernel_type,size,sigma);
    case 'Motion'
        len = str2double(get(handles.edit_length,'String'));
        theta = str2double(get(handles.edit_theta,'String'));
        h = fspecial(kernel_type,len,theta);
    case 'Prewitt'
        tp = get(handles.checkbox_transpose,'Value');
        h = fspecial(kernel_type);
        if tp, h = h'; end
    case 'Sobel'
        tp = get(handles.checkbox_transpose,'Value');
        h = fspecial(kernel_type);
        if tp, h = h'; end
end

% get padding option
pad_opt = handles.uibuttongroup_padding_options.SelectedObject.String;

% get output size option
output_size = handles.uibuttongroup_output_size.SelectedObject.String;

% filtering
output_image = imfilter(input_image,h,pad_opt,output_size);

% visualization
axes(handles.axes_input); imagesc(input_image); axis off;
axes(handles.axes_output); imagesc(output_image); axis off;
axes(handles.axes_kernel); imagesc(h); axis off;

end


% --- Executes on selection change in popupmenu_kernel_type.
function popupmenu_kernel_type_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_kernel_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_kernel_type contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_kernel_type

global input_image; global output_image; 
global kernel_type; 
global h; global pad_opt; global output_size;

% get kernel type
type_list = cellstr(get(hObject,'String'));
kernel_type = type_list{get(hObject,'Value')};

% specify kernel parameters
switch (kernel_type)
    case 'Average'
        set(handles.text_size,'Enable','On'); set(handles.edit_size,'Enable','On');
        set(handles.text_radius,'Enable','Off'); set(handles.edit_radius,'Enable','Off');
        set(handles.text_sigma,'Enable','Off'); set(handles.edit_sigma,'Enable','Off');
        set(handles.text_alpha,'Enable','Off'); set(handles.edit_alpha,'Enable','Off');
        set(handles.text_length,'Enable','Off'); set(handles.edit_length,'Enable','Off');
        set(handles.text_theta,'Enable','Off'); set(handles.edit_theta,'Enable','Off');  
        set(handles.slider_theta,'Enable','Off');
        set(handles.checkbox_transpose,'Enable','Off');
        
        size = str2double(get(handles.edit_size,'String'));
        h = fspecial(kernel_type,size);
    case 'Disk'        
        set(handles.text_size,'Enable','Off'); set(handles.edit_size,'Enable','Off');
        set(handles.text_radius,'Enable','On'); set(handles.edit_radius,'Enable','On');
        set(handles.text_sigma,'Enable','Off'); set(handles.edit_sigma,'Enable','Off');
        set(handles.text_alpha,'Enable','Off'); set(handles.edit_alpha,'Enable','Off');
        set(handles.text_length,'Enable','Off'); set(handles.edit_length,'Enable','Off');
        set(handles.text_theta,'Enable','Off'); set(handles.edit_theta,'Enable','Off');  
        set(handles.slider_theta,'Enable','Off');
        set(handles.checkbox_transpose,'Enable','Off');
        
        radius = str2double(get(handles.edit_radius,'String'));
        h = fspecial(kernel_type,radius);
    case 'Gaussian'        
        set(handles.text_size,'Enable','On'); set(handles.edit_size,'Enable','On');
        set(handles.text_radius,'Enable','Off'); set(handles.edit_radius,'Enable','Off');
        set(handles.text_sigma,'Enable','On'); set(handles.edit_sigma,'Enable','On');
        set(handles.text_alpha,'Enable','Off'); set(handles.edit_alpha,'Enable','Off');
        set(handles.text_length,'Enable','Off'); set(handles.edit_length,'Enable','Off');
        set(handles.text_theta,'Enable','Off'); set(handles.edit_theta,'Enable','Off');  
        set(handles.slider_theta,'Enable','Off');
        set(handles.checkbox_transpose,'Enable','Off');
        
        size = str2double(get(handles.edit_size,'String'));
        sigma = str2double(get(handles.edit_sigma,'String'));
        h = fspecial(kernel_type,size,sigma);
    case 'Laplacian'        
        set(handles.text_size,'Enable','Off'); set(handles.edit_size,'Enable','Off');
        set(handles.text_radius,'Enable','Off'); set(handles.edit_radius,'Enable','Off');
        set(handles.text_sigma,'Enable','Off'); set(handles.edit_sigma,'Enable','Off');
        set(handles.text_alpha,'Enable','On'); set(handles.edit_alpha,'Enable','On');
        set(handles.text_length,'Enable','Off'); set(handles.edit_length,'Enable','Off');
        set(handles.text_theta,'Enable','Off'); set(handles.edit_theta,'Enable','Off');  
        set(handles.slider_theta,'Enable','Off');
        set(handles.checkbox_transpose,'Enable','Off');
        
        alpha = str2double(get(handles.edit_alpha,'String'));
        h = fspecial(kernel_type,alpha);
    case 'LoG'
        set(handles.text_size,'Enable','On'); set(handles.edit_size,'Enable','On');
        set(handles.text_radius,'Enable','Off'); set(handles.edit_radius,'Enable','Off');
        set(handles.text_sigma,'Enable','On'); set(handles.edit_sigma,'Enable','On');
        set(handles.text_alpha,'Enable','Off'); set(handles.edit_alpha,'Enable','Off');
        set(handles.text_length,'Enable','Off'); set(handles.edit_length,'Enable','Off');
        set(handles.text_theta,'Enable','Off'); set(handles.edit_theta,'Enable','Off');  
        set(handles.slider_theta,'Enable','Off');
        set(handles.checkbox_transpose,'Enable','Off');
        
        size = str2double(get(handles.edit_size,'String'));
        sigma = str2double(get(handles.edit_sigma,'String'));
        h = fspecial(kernel_type,size,sigma);
    case 'Motion'        
        set(handles.text_size,'Enable','Off'); set(handles.edit_size,'Enable','Off');
        set(handles.text_radius,'Enable','Off'); set(handles.edit_radius,'Enable','Off');
        set(handles.text_sigma,'Enable','Off'); set(handles.edit_sigma,'Enable','Off');
        set(handles.text_alpha,'Enable','Off'); set(handles.edit_alpha,'Enable','Off');
        set(handles.text_length,'Enable','On'); set(handles.edit_length,'Enable','On');
        set(handles.text_theta,'Enable','On'); set(handles.edit_theta,'Enable','On');  
        set(handles.slider_theta,'Enable','On');
        set(handles.checkbox_transpose,'Enable','Off');
        
        len = str2double(get(handles.edit_length,'String'));
        theta = str2double(get(handles.edit_theta,'String'));
        h = fspecial(kernel_type,len,theta);
    case 'Prewitt'        
        set(handles.text_size,'Enable','Off'); set(handles.edit_size,'Enable','Off');
        set(handles.text_radius,'Enable','Off'); set(handles.edit_radius,'Enable','Off');
        set(handles.text_sigma,'Enable','Off'); set(handles.edit_sigma,'Enable','Off');
        set(handles.text_alpha,'Enable','Off'); set(handles.edit_alpha,'Enable','Off');
        set(handles.text_length,'Enable','Off'); set(handles.edit_length,'Enable','Off');
        set(handles.text_theta,'Enable','Off'); set(handles.edit_theta,'Enable','Off');  
        set(handles.slider_theta,'Enable','Off');
        set(handles.checkbox_transpose,'Enable','On');
        
        tp = get(handles.checkbox_transpose,'Value');
        h = fspecial(kernel_type);
        if tp, h = h'; end
    case 'Sobel'        
        set(handles.text_size,'Enable','Off'); set(handles.edit_size,'Enable','Off');
        set(handles.text_radius,'Enable','Off'); set(handles.edit_radius,'Enable','Off');
        set(handles.text_sigma,'Enable','Off'); set(handles.edit_sigma,'Enable','Off');
        set(handles.text_alpha,'Enable','Off'); set(handles.edit_alpha,'Enable','Off');
        set(handles.text_length,'Enable','Off'); set(handles.edit_length,'Enable','Off');
        set(handles.text_theta,'Enable','Off'); set(handles.edit_theta,'Enable','Off');  
        set(handles.slider_theta,'Enable','Off');
        set(handles.checkbox_transpose,'Enable','On');
        
        tp = get(handles.checkbox_transpose,'Value');
        h = fspecial(kernel_type);
        if tp, h = h'; end
end

% filtering
output_image = imfilter(input_image,h,pad_opt,output_size);

% visualization
axes(handles.axes_output); imagesc(output_image); axis off;
axes(handles.axes_kernel); imagesc(h); axis off;



% --- Executes during object creation, after setting all properties.
function popupmenu_kernel_type_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_kernel_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton_same.
function radiobutton_same_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_same (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_same

global input_image; global output_image; 
global h; global pad_opt; global output_size;

% set output size option
output_size = 'Same';

% filtering
output_image = imfilter(input_image,h,pad_opt,output_size);

% visualization
axes(handles.axes_output); imagesc(output_image); axis off;
axes(handles.axes_kernel); imagesc(h); axis off;


% --- Executes on button press in radiobutton_full.
function radiobutton_full_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_full (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_full

global input_image; global output_image; 
global h; global pad_opt; global output_size;

% set output size option
output_size = 'Full';

% filtering
output_image = imfilter(input_image,h,pad_opt,output_size);

% visualization
axes(handles.axes_output); imagesc(output_image); axis off;
axes(handles.axes_kernel); imagesc(h); axis off;



% --- Executes on button press in radiobutton_symmetric.
function radiobutton_symmetric_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_symmetric (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_symmetric

global input_image; global output_image; 
global h; global pad_opt; global output_size;

% set output size option
pad_opt = 'Symmetric';

% filtering
output_image = imfilter(input_image,h,pad_opt,output_size);

% visualization
axes(handles.axes_output); imagesc(output_image); axis off;
axes(handles.axes_kernel); imagesc(h); axis off;


% --- Executes on button press in radiobutton_replicate.
function radiobutton_replicate_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_replicate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_replicate

global input_image; global output_image; 
global h; global pad_opt; global output_size;

% set output size option
pad_opt = 'Replicate';

% filtering
output_image = imfilter(input_image,h,pad_opt,output_size);

% visualization
axes(handles.axes_output); imagesc(output_image); axis off;
axes(handles.axes_kernel); imagesc(h); axis off;


% --- Executes on button press in radiobutton_circular.
function radiobutton_circular_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_circular (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_circular

global input_image; global output_image; 
global h; global pad_opt; global output_size;

% set output size option
pad_opt = 'Circular';

% filtering
output_image = imfilter(input_image,h,pad_opt,output_size);

% visualization
axes(handles.axes_output); imagesc(output_image); axis off;
axes(handles.axes_kernel); imagesc(h); axis off;



function edit_size_Callback(hObject, eventdata, handles)
% hObject    handle to edit_size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_size as text
%        str2double(get(hObject,'String')) returns contents of edit_size as a double

global input_image; global output_image; 
global kernel_type;
global h; global pad_opt; global output_size;

% specify kernel parameters
size = str2double(get(hObject,'String'));
switch (kernel_type)
    case 'Average'        
        h = fspecial(kernel_type,size);
    case 'Gaussian'                
        sigma = str2double(get(handles.edit_sigma,'String'));
        h = fspecial(kernel_type,size,sigma);
    case 'LoG'        
        sigma = str2double(get(handles.edit_sigma,'String'));
        h = fspecial(kernel_type,size,sigma);
end

% filtering
output_image = imfilter(input_image,h,pad_opt,output_size);

% visualization
axes(handles.axes_output); imagesc(output_image); axis off;
axes(handles.axes_kernel); imagesc(h); axis off;



% --- Executes during object creation, after setting all properties.
function edit_size_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_radius_Callback(hObject, eventdata, handles)
% hObject    handle to edit_radius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_radius as text
%        str2double(get(hObject,'String')) returns contents of edit_radius as a double

global input_image; global output_image; 
global kernel_type;
global h; global pad_opt; global output_size;

% specify kernel parameters
radius = str2double(get(hObject,'String'));
switch (kernel_type)
    case 'Disk'        
        h = fspecial(kernel_type,radius);
end

% filtering
output_image = imfilter(input_image,h,pad_opt,output_size);

% visualization
axes(handles.axes_output); imagesc(output_image); axis off;
axes(handles.axes_kernel); imagesc(h); axis off;


% --- Executes during object creation, after setting all properties.
function edit_radius_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_radius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_sigma_Callback(hObject, eventdata, handles)
% hObject    handle to edit_sigma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_sigma as text
%        str2double(get(hObject,'String')) returns contents of edit_sigma as a double

global input_image; global output_image; 
global kernel_type;
global h; global pad_opt; global output_size;

% specify kernel parameters
sigma = str2double(get(hObject,'String'));
switch (kernel_type)
    case 'Gaussian'                
        size = str2double(get(handles.edit_size,'String'));
        h = fspecial(kernel_type,size,sigma);
    case 'LoG'        
        size = str2double(get(handles.edit_size,'String'));
        h = fspecial(kernel_type,size,sigma);
end

% filtering
output_image = imfilter(input_image,h,pad_opt,output_size);

% visualization
axes(handles.axes_output); imagesc(output_image); axis off;
axes(handles.axes_kernel); imagesc(h); axis off;


% --- Executes during object creation, after setting all properties.
function edit_sigma_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_sigma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_alpha_Callback(hObject, eventdata, handles)
% hObject    handle to edit_alpha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_alpha as text
%        str2double(get(hObject,'String')) returns contents of edit_alpha as a double

global input_image; global output_image; 
global kernel_type;
global h; global pad_opt; global output_size;

% specify kernel parameters
alpha = str2double(get(hObject,'String'));
if alpha > 1
    alpha = 1;
elseif alpha < 0
    alpha = 0;
end
set(hObject,'String',num2str(alpha));

switch (kernel_type)
    case 'Laplacian'                
        h = fspecial(kernel_type,alpha);
end

% filtering
output_image = imfilter(input_image,h,pad_opt,output_size);

% visualization
axes(handles.axes_output); imagesc(output_image); axis off;
axes(handles.axes_kernel); imagesc(h); axis off;



% --- Executes during object creation, after setting all properties.
function edit_alpha_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_alpha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_length_Callback(hObject, eventdata, handles)
% hObject    handle to edit_length (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_length as text
%        str2double(get(hObject,'String')) returns contents of edit_length as a double

global input_image; global output_image; 
global kernel_type;
global h; global pad_opt; global output_size;

% specify kernel parameters
length = str2double(get(hObject,'String'));
switch (kernel_type)
    case 'Motion'                
        theta = str2double(get(handles.edit_theta,'String'));
        h = fspecial(kernel_type,length,theta);
end

% filtering
output_image = imfilter(input_image,h,pad_opt,output_size);

% visualization
axes(handles.axes_output); imagesc(output_image); axis off;
axes(handles.axes_kernel); imagesc(h); axis off;



% --- Executes during object creation, after setting all properties.
function edit_length_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_length (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_theta_Callback(hObject, eventdata, handles)
% hObject    handle to edit_theta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_theta as text
%        str2double(get(hObject,'String')) returns contents of edit_theta as a double

global input_image; global output_image; 
global kernel_type;
global h; global pad_opt; global output_size;

% specify kernel parameters
theta = str2double(get(hObject,'String'));
if theta > 360
    theta = 360;
elseif theta < 0
    theta = 0;
end
set(hObject,'String',num2str(theta));

switch (kernel_type)
    case 'Motion'                
        length = str2double(get(handles.edit_length,'String'));
        h = fspecial(kernel_type,length,theta);
end

set(handles.slider_theta,'Value',theta);

% filtering
output_image = imfilter(input_image,h,pad_opt,output_size);

% visualization
axes(handles.axes_output); imagesc(output_image); axis off;
axes(handles.axes_kernel); imagesc(h); axis off;



% --- Executes during object creation, after setting all properties.
function edit_theta_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_theta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider_theta_Callback(hObject, eventdata, handles)
% hObject    handle to slider_theta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

global input_image; global output_image; 
global kernel_type;
global h; global pad_opt; global output_size;

% specify kernel parameters
theta = round(get(hObject,'Value'));
switch (kernel_type)
    case 'Motion'                
        length = str2double(get(handles.edit_length,'String'));
        h = fspecial(kernel_type,length,theta);
end

set(handles.edit_theta,'String',num2str(theta));

% filtering
output_image = imfilter(input_image,h,pad_opt,output_size);

% visualization
axes(handles.axes_output); imagesc(output_image); axis off;
axes(handles.axes_kernel); imagesc(h); axis off;


% --- Executes during object creation, after setting all properties.
function slider_theta_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_theta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in checkbox_transpose.
function checkbox_transpose_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_transpose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_transpose

global input_image; global output_image; 
global kernel_type;
global h; global pad_opt; global output_size;

% specify kernel parameters
tp = get(hObject,'Value');
switch (kernel_type)
    case 'Prewitt'
        h = fspecial(kernel_type);
        if tp, h = h'; end
    case 'Sobel'
        h = fspecial(kernel_type);
        if tp, h = h'; end
end

% filtering
output_image = imfilter(input_image,h,pad_opt,output_size);

% visualization
axes(handles.axes_output); imagesc(output_image); axis off;
axes(handles.axes_kernel); imagesc(h); axis off;
