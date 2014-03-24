% ------------------------------------------------------------------------------
% install.m
% ------------------------------------------------------------------------------
% 
% Installs the highly comparative time-series analysis code package from scratch.
% 
% ------------------------------------------------------------------------------
% Copyright (C) 2013,  Ben D. Fulcher <ben.d.fulcher@gmail.com>,
% <http://www.benfulcher.com>
% 
% If you use this code for your research, please cite:
% B. D. Fulcher, M. A. Little, N. S. Jones, "Highly comparative time-series
% analysis: the empirical structure of time series and their methods",
% J. Roy. Soc. Interface 10(83) 20130048 (2010). DOI: 10.1098/rsif.2013.0048
% 
% This work is licensed under the Creative Commons
% Attribution-NonCommercial-ShareAlike 3.0 Unported License. To view a copy of
% this license, visit http://creativecommons.org/licenses/by-nc-sa/3.0/ or send
% a letter to Creative Commons, 444 Castro Street, Suite 900, Mountain View,
% California, 94041, USA.
% ------------------------------------------------------------------------------

fprintf(1,['This script will set up the Highly Comparative Time-Series ' ...
                                'Analysis code package from scratch!\n'])
fprintf(1,['In the following order, we will' ...
                '\n- Add the paths,' ...
                '\n- Set up the database,' ...
                '\n- Add the operations,' ...
                '\n- Compile the toolboxes,' ...
                '\n- Test that things are working.'])

% ------------------------------------------------------------------------------
%% 1. Add the paths:
% ------------------------------------------------------------------------------
fprintf(1,'Adding the paths...')
try
	startup
	fprintf('done.\n')
catch emsg
	fprintf(1,'error.\n%s\n',emsg)
end

% ------------------------------------------------------------------------------
%% 2. Set up the database:
% ------------------------------------------------------------------------------
reply = '';
while isempty(reply)
    reply = input('Do you need help setting up a mySQL database? [y/n]');
    if ~ismember(reply,{'y','n'}), reply = ''; end
end
if strcmp(reply,'y') % Set up mySQL database
    fprintf(1,['Setting up the database now--NB: you need to have root access' ...
                            ' to a mySQL server to do this\n'])
    % Walks the user through creating the database from a root account and sets
    % up a user account and password
    SQL_create_db;
    fprintf(1,['Note that if you ever want to change the database access ' ...
                    'settings, you should alter the sql_settings.conf file' ...
                    ', or run SQL_create_db\n'])
end

% ------------------------------------------------------------------------------
%% 3. Create all tables in the database
% ------------------------------------------------------------------------------
SQL_create_all_tables;

% ------------------------------------------------------------------------------
%% 4. Populate the database with operations
% ------------------------------------------------------------------------------
fprintf(1,'Populating the database with operations (please be patient)...\n')
fprintf(1,'Adding Master operations...\n'); moptic = tic;
SQL_add('mops','Database/INP_mops.txt','',0)
fprintf(1,'Master operations added in %s.\n',BF_thetime(toc(moptic)))
fprintf(1,'Adding all operations...\n'); optic = tic;
SQL_add('ops','Database/INP_ops.txt','',0)
fprintf(1,'Operations added in %s.\n',BF_thetime(toc(optic)))

% ------------------------------------------------------------------------------
%% 5. Attempt to compile the executables in Toolboxes:
% ------------------------------------------------------------------------------
fprintf(1,['Attempting to compile the binary executables needed for evaluating ' ...
                                                        'some operations.\n'])
fprintf(1,['Please make sure that mex is set up with the right compilers for' ...
                                                            ' this system.\n'])
fprintf(1,['Note that errors here are not the end of the world, but mean that ' ...
                        'some operations may fail to execute correctly...\n'])
cd Toolboxes
compile_mex
cd('../');
fprintf(1,'Kind of amazing, but it seems like everything compiled ok!\n')
fprintf(1,['Ready when you are to add time series to the database using ' ...
                                                        'SQL_add...!\n']);

% Attempt to add a time series
% SQL_add('ts','INP_test_ts.txt')