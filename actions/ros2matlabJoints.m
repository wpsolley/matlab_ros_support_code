function mat_cur_q = ros2matlabJoints(ros_cur_jnt_state_msg,robot_names)
%----
% Takes a joint state message, extracts names and joint angles and
% rearranges correctly into matlab format
%
% Input
%
% robot_names {} - cell of joint names for given robot

% Get the latest current joint angle values via subscriber object
% non-blocking
 ros_cur_q = ros_cur_jnt_state_msg.LatestMessage;

 % UR5e Dictionary where keys are joint naves and values is the index order
 ur5e = dictionary(robot_names{1},1,...
                   robot_names{2},2,...
                   robot_names{3},3,...
                   robot_names{4},4,...
                   robot_names{5},5,...
                   robot_names{6},6,...
                   robot_names{7},7);

joint_index = zeros(1,7);
for i = 1:length(joint_index)

    % Create qi as an index by tapping the dictionary with name key and getting the index value
    qi(i) =  ur5e( ros_cur_jnt_state_msg.Name{i} ); % Name is a cell

    % Now extract from the ROS joint message and set into the mat structure
    mat_cur_q[ qi(i) ] = ros_cur_jnt_state_msg.LatestMessage.Position( qi(i) );
end

