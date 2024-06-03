function databasecreate(variables,filename)
for i = 1:length(variables)
    eval(variables(i)+"= evalin('caller',variables(i))");
end
clear i variables
save(filename,'*');
clc
end