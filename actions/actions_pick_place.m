% Pick and place

% 01 Connect to ROS (use your own masterhost IP address)
% rosinit("192.168.122.128")

% 02 Extract a list of models
models = getModels; 

% Loop through each one to pick and place
for i=1:length(models.ModelNames)

    model_name = models.ModelNames{26};
    %model_name = models.ModelNames{i}
    model_pose = get_model_pose(model_name);
    
    % 03 Pick Model
    ret = pick(model_pose);
    
    % 04 Logic to set bin according to object
    placePose = selectBin(model_name); 
    ret = place(placePose);
end