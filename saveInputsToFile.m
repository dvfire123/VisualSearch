function [fileName, file] = saveInputsToFile(inputs, folder)
    %Save the inputs to file
    fileName = sprintf('%s-%s.vsdf', inputs{1}, inputs{2});
    file = fullfile(folder, fileName);
    
    fid = fopen(file, 'wt+');

    %Magic number most efficient here
    NUM_PARAMS = 8;
    for i = 1:NUM_PARAMS
       fprintf(fid, inputs{i});
       fprintf(fid, '\n');
    end
    
    fclose(fid);
end