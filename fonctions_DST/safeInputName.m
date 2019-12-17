function nameId=safeInputName(expPath, add2name)
% Safely ask for a name to save a file;
% Test whether the file already exists in expPath (absolute path), and if yes, recursively prompts for creating another one
% add2name will be added at the end of the name

if exist('add2name','var')==0, add2name=''; end

nameId='';
while isempty(nameId)||exist(fullfile(expPath,[nameId,'.mat']),'file')

    nameId = input('Enter participant''s ID:  ', 's');
    nameId=[nameId,add2name];
    if exist(fullfile(expPath,[nameId,'.mat']),'file')
        disp('Participant''s ID already exists. Please input a different name')
        nameId=safeInputName(expPath,add2name);
    end
end

