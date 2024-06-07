%%%% FUNCTION
%
% Creates a .mat file
%
%%%% INPUTS %%%%
% - variables: list of variables to store
% - filename: name of the .mat file to be created
%
%%%% OUTPUTS %%%%
% - .mat file
%
%   Author: Marta Lopez Castro
%   Version: June 04, 2024
%
% *********************************************************************
% Copyright 2023 - 2025 David Canales Garcia; All Rights Reserved.
% *********************************************************************

function databasecreate(variables,filename)
for i = 1:length(variables)
    eval(variables(i)+"= evalin('caller',variables(i))");
end
clear i variables
save(filename,'*');
clc
end