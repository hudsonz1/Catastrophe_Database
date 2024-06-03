codepath = fileparts(matlab.desktop.editor.getActiveFilename); 
cd(codepath);
allpaths = genpath(codepath);
addpath(genpath(codepath));


Orbitsfiles = what('orbit_families');
Families = erase(Orbitsfiles.mat,'.mat');
Families_desc = cellfun(@(x) strcat(extractBefore(x,2),extract(x,digitsPattern)),Families,'UniformOutput',false);

cd(append(codepath,'\01 orbits\specific_orbit_families'))
explosioncell = struct2cell(dir('sp_*'));

explosionparts = split(explosioncell(1,:),'_');
% 
% explosionmonth = datestr(datetime(1,eval(explosionparts{3}),1),'mmmm');

exp_idx = listdlg("PromptString",{'Select orbit databases'},"ListString",explosioncell(1,:));

%%
t0exp_all = [];
JC0_all = [];

texp_all = {};
sexp_all = {};
s0exp_all = [];
out_of_system_all = [];
orbit_debris_all = [];
JC_all = [];
impact_moon_all = [];
impact_earth_all = [];

for i = 1:length(exp_idx)
    expfiles = what(append(explosioncell{1,exp_idx(i)},'\explosions'));
    parts = split(expfiles.mat,'_');
    JC0 = cellfun(@eval,replace(parts(:,3),'-','.'));
    t0exp = cellfun(@eval,replace(parts(:,4),'-','.'));
    
    sp_exp_idx{i} = listdlg("PromptString",{'Select explosions'},"ListString",erase(expfiles.mat,'.mat'));

    for j = 1:length(sp_exp_idx{i})
        disp(string(j))
        load(expfiles.mat{sp_exp_idx{i}(j)});
        t0exp_all = horzcat(t0exp_all,ones(1,length(texp))*t0exp(sp_exp_idx{i}(j)));
        JC0_all = horzcat(JC0_all,ones(1,length(JC))*JC0(sp_exp_idx{i}(j)));
        texp_all = horzcat(texp_all,texp);
        sexp_all = horzcat(sexp_all,sexp);
        s0exp_all = vertcat(s0exp_all,s0exp);
        out_of_system_all = horzcat(out_of_system_all,out_of_system);
        orbit_debris_all = horzcat(orbit_debris_all,orbit_debris);
        JC_all = horzcat(JC_all,JC);
        impact_moon_all = horzcat(impact_moon_all,impact_moon);
        impact_earth_all = horzcat(impact_earth_all,impact_earth);
    end

end

clearvars -except *_all

