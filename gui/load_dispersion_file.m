function load_dispersion_file(handles, lang)
% LOAD DISPERSION FILE
% Load dispersion file from Excel, then plot it on GUI.
%
% Author: Pablo Pizarro @ppizarror.com, 2017.
%
% This program is free software; you can redistribute it and/or
% modify it under the terms of the GNU General Public License
% as published by the Free Software Foundation; either version 2
% of the License, or (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.

set_status(handles, lang{5});

[baseName, folder] = uigetfile({'*.xlsx; *.xls', lang{85}}, lang{5}, ...
    getappdata(handles.root, 'last_opened_folder'));

% If filename is valid
if baseName ~= 0
    
    % Open file
    set_status(handles, lang{8}, 'k');
    filename = strcat(folder, baseName);
    set(handles.root, 'pointer', 'watch');
    
    try
        excel_data = xlsread(filename);
    catch
        set_status(handles, lang{25}, 'r');
        errordlg(lang{24}, lang{23})
        return
    end
    
    % Get size of excel loaded data
    [~, nColumn] = size(excel_data);
    
    % Constant import
    constants;
    
    % Check if number of columns are valid
    if nColumn == columns_dispersiondata
        
        % Save freq and vr_exp
        freq = excel_data(:, 1);
        vr_exp = excel_data(:, 2);
        
        % Store vectors on app
        setappdata(handles.root, 'disp_freq', excel_data(:, 1));
        setappdata(handles.root, 'disp_vrexp', excel_data(:, 2));
        
        % --- Plot data
        axes(handles.plt_dispersion_file);
        
        % Get plot style
        plt_style = getappdata(handles.root, 'plt_dispersion_style');
        
        % Plot curve
        plot(freq, vr_exp, plt_style);
        
        % Save filename
        setappdata(handles.root, 'dispersion_file', filename);
        
        % Set filename on gui
        if length(filename) > size_filename_dispersion_str
            filename = filename(length(filename)-size_filename_dispersion_str:end);
            filename = strcat('...', filename);
        end
        set(handles.status_direction_file, 'string', filename);
        setappdata(handles.root, 'dispersion_file_short', filename);
        
        % Enable context menu
        set(handles.disp_plt_viewlarger, 'Enable', 'on');
        set(handles.dispersion_plt_viewtable, 'Enable', 'on');
        
        % Set status
        set_status(handles, lang{35}, 'k');
        setappdata(handles.root, 'dispersion_ok', true);
        set(handles.root, 'pointer', 'arrow');
        setappdata(handles.root, 'last_opened_folder', folder);
        
        % Disable solution buttons
        disable_sol(handles, lang);
        
    else
        disp_error(handles, lang, 34);
        return
    end
    
    % If filename is invalid
else
    disp_error(handles, lang, 33);
    return
end

end

