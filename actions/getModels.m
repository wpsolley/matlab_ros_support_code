function models = getModels
% Queries Gazebo Simulator for models

get_models_client = rossvcclient('/gazebo/get_model_state', 'DataFormat','struct');
get_models_client_msg = rosmessage(get_models_client);
[resp,status,statustext] = call(get_models_client,get_models_client_msg)
end