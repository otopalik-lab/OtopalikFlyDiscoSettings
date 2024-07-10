function [] = makeToProcessSoftlinks(listfile)
% MAKETOPROCESSSOFTLINKS generates softlinks to experiment directories that need to be re-run
% in the FlyDiscoAnalysis pipeline. These softlinks are generated from a
% provided list (str for a .txt file) and the soft links will be added to the
% to-process folder in otopalikrobot. Good luck!


S = readlines(listfile);
newStr = strrep(S,'/Volumes/otopaliklab/','/groups/otopalik/otopaliklab/');
explist = newStr;
toprocessdir = 'groups/otopalik/otopaliklab/flydisco_data/to-process';

%ln -s source_file_or_directory_name  softlink_name
for i = 1:numel(explist)
    expdir = explist{i};
    [~,expname] = fileparts(expdir);
    outdir = fullfile(toprocessdir,expname);
    cmd = sprintf('ln -s %s %s', expdir, outdir);
    system(cmd)
end


end