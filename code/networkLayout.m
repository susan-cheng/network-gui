function varargout = networkLayout(varargin)
% NETWORKLAYOUT MATLAB code for networkLayout.fig
%      NETWORKLAYOUT, by itself, creates a new NETWORKLAYOUT or raises the existing
%      singleton*.
%
%      H = NETWORKLAYOUT returns the handle to a new NETWORKLAYOUT or the handle to
%      the existing singleton*.
%
%      NETWORKLAYOUT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NETWORKLAYOUT.M with the given input arguments.
%
%      NETWORKLAYOUT('Property','Value',...) creates a new NETWORKLAYOUT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before networkLayout_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to networkLayout_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help networkLayout

% Last Modified by GUIDE v2.5 18-Jan-2020 13:38:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @networkLayout_OpeningFcn, ...
                   'gui_OutputFcn',  @networkLayout_OutputFcn, ...
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes just before networkLayout is made visible.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function networkLayout_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to networkLayout (see VARARGIN)

cla reset;
set(handles.text_cite, 'Visible', 'Off');
handles.run = false;

%ott-antonsen parameters and default values
handles.oa.names = {'t0'; 'tf'; 'dt'; 'tau_e'; 'tau_i'; 'amp'; 'beta'; 'omega'; 'I_constant'; 'I_constant_frac'; 'sigma'; 'sigma_frac'; 'gee'; 'gei'; 'gie'; 'gii'};
handles.oa.values = {0; 200; 0.01; 2; 8; 0.4; 50; 0.25; 0.03; 1; 0.02; 1; 0.3; 0.15; 0.5; 0.2};
handles.oa.tableData = [handles.oa.names, handles.oa.values];

%theta parameters and default values
handles.th.names = {'Noise'; 'Ne'; 'Ni'; 't0'; 'tf'; 'dt'; 'tau_e'; 'tau_i'; 'amp'; 'beta'; 'omega'; 'I_constant'; 'I_constant_frac'; 'sigma'; 'sigma_frac'; 'gee'; 'gei'; 'gie'; 'gii'};
handles.th.values = {false; 1000; 1000; 0; 200; 0.1; 2; 8; 0.4; 50; 0.25; 0.03; 1; 0.02; 1; 0.3; 0.15; 0.5; 0.2};
handles.th.tableData = [handles.th.names, handles.th.values];

%both parameters and default values
handles.to.names = {'Noise (Theta only)'; 'Ne (Theta only)'; 'Ni (Theta only)'; 't0'; 'tf'; 'dt'; 'tau_e'; 'tau_i'; 'amp'; 'beta'; 'omega'; 'I_constant'; 'I_constant_frac'; 'sigma'; 'sigma_frac'; 'gee'; 'gei'; 'gie'; 'gii'};
handles.to.values = {false; 1000; 1000; 0; 200; 0.05; 2; 8; 0.4; 50; 0.25; 0.03; 1; 0.02; 1; 0.3; 0.15; 0.5; 0.2};
handles.to.tableData = [handles.to.names, handles.to.values];
handles.to.sig_ind = 14;
handles.to.th_ind = 3;

%load theta data in table
handles.model = 1;
set(handles.uitable_namevalue, 'Data', handles.th.tableData);

% Choose default command line output for networkLayout
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes networkLayout wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = networkLayout_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function OpenMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to OpenMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
file = uigetfile('*.fig');
if ~isequal(file, 0)
    open(file);
end

% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to PrintMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
printdlg(handles.figure1)

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to CloseMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
                     ['Close ' get(handles.figure1,'Name') '...'],...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.figure1)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on button press in pushbutton_update.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function pushbutton_update_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_update (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cla reset;
handles.run = true;

%get user choices for parameter values and graph type
data = get(handles.uitable_namevalue, 'Data');
values = num2cell([data{:, 2}]);
graphType = get(handles.popupmenu_graphtype, 'Value');

switch handles.model
    case 1 %theta
        %run model with new parameter values
        [handles.th.spikes, handles.th.se, handles.th.si] = networkThetaGUI(values);
        handles.th.values = values;
        %graph desired results
        handles.th.graphType = graphType;
        graphTheta(handles.axes_main, handles.th);
    case 2 %ott-antonsen
        %run model with new parameter values
        handles.oa.output = ottAntonsenGUI(values);
        handles.oa.values = values;
        %graph desired results
        handles.oa.graphType = graphType;
        graphOttAn(handles.axes_main, handles.oa);
    case 3 %both
        %run models with new parameter values
        values_oa = values; values_th = values;
        %values_oa(handles.to.sig_ind:handles.to.sig_ind+1) = [];
        values_oa(1:handles.to.th_ind) = [];
        %values_th(handles.to.sig_ind+2:handles.to.sig_ind+3) = [];
        handles.to.output = ottAntonsenGUI(values_oa);
        [~, handles.to.se, handles.to.si] = networkThetaGUI(values_th);
        handles.to.values = values;
        %graph desired results
        handles.to.graphType = graphType;
        graphBoth(handles.axes_main, handles.to);
end

%update handles structure
guidata(hObject, handles);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% -- Creates graphs for Theta model
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function graphTheta(a, th)

axes(a);

t0 = th.values{4};
tf = th.values{5};
dt = th.values{6};
time = t0:dt:tf;

switch th.graphType
    case 1 %se/si
        plot(time, th.se, time, th.si);
        legend('s_e', 's_i');

    case 2 %raster
        plotSpikeRaster(th.spikes);
        
        %relabel x axis
        x1 = xticklabels(a);
        x2 = cellfun(@str2num, x1);
        x2 = x2*dt+t0;
        x2 = cellstr(num2str(x2));
        xticklabels(x2);       
end

xlabel("Time (ms)");

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% -- Creates graphs for Ott-Antonsen model
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function graphOttAn(a, oa)

axes(a);

t0 = oa.values{1};
tf = oa.values{2};
dt = oa.values{3};
time = t0:dt:tf;

switch oa.graphType
    case 1 %re/ri
        re = oa.output(1, :);
        ri = oa.output(2, :);

        plot(time, re, time, ri);
        legend('r_e', 'r_i');
    case 2 %ve/vi
        ve = oa.output(3, :);
        vi = oa.output(4, :);
        
        plot(time, ve, time, vi);
        legend('v_e', 'v_i');
    case 3 %se/si
        se = oa.output(5, :);
        si = oa.output(6, :);
        
        plot(time, se, time, si);
        legend('s_e', 's_i');
end

xlabel("Time (ms)");

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% -- Creates graphs for both Theta and Ott-Antonsen model
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function graphBoth(a, to)

axes(a);

t0 = to.values{4};
tf = to.values{5};
dt = to.values{6};
time = t0:dt:tf;

se_oa = to.output(5, :);
si_oa = to.output(6, :);

%graph se/si
plot(time, to.se, time, to.si, time, se_oa, time, si_oa);
legend('Theta s_e', 'Theta s_i', 'OA s_e', 'OA s_i');
xlabel("Time (ms)");

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on selection change in popupmenu_graphtype.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function popupmenu_graphtype_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_graphtype (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_graphtype contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_graphtype
cla reset;
graphType = get(handles.popupmenu_graphtype, 'Value');
set(handles.text_cite, 'Visible', 'Off');

%changes graph type, does NOT rerun model
switch handles.model
    case 1 %theta
        handles.th.graphType = graphType;
        if handles.run
            graphTheta(handles.axes_main, handles.th);
        end
        
        if graphType == 2
            set(handles.text_cite, 'Visible', 'On');
        end
    case 2 %ott-antonsen
        handles.oa.graphType = graphType;
        if handles.run
            graphOttAn(handles.axes_main, handles.oa);
        end
end

% --- Executes during object creation, after setting all properties.
function popupmenu_graphtype_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_graphtype (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on selection change in popupmenu_model.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function popupmenu_model_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_model (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_model contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_model
cla reset;
handles.model = get(handles.popupmenu_model, 'Value');
set(handles.text_cite, 'Visible', 'Off');
handles.run = false;

%changes model and associated interface
switch handles.model
    case 1 %theta
        set(handles.uitable_namevalue, 'Data', handles.th.tableData);
        set(handles.popupmenu_graphtype, 'String', {'Se/Si'; 'Raster Plot'}, 'Value', 1);
    case 2 %ott-antonsen
        set(handles.uitable_namevalue, 'Data', handles.oa.tableData);
        set(handles.popupmenu_graphtype, 'String', {'Re/Ri'; 'Ve/Vi'; 'Se/Si'}, 'Value', 3);
    case 3 %theta and ott-antonsen
        set(handles.uitable_namevalue, 'Data', handles.to.tableData);
        set(handles.popupmenu_graphtype, 'String', {'Se/Si'}, 'Value', 1);
end
%updates handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function popupmenu_model_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_model (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
