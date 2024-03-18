% Pick and place

rosinit("192.168.131.1")

% Extract a list of models
models = getModels;

% Loop through them
ret = pick(model_pose);

% Logic to set bin according to object
placePose = selectBin(model_name); 
ret = place(placePose);