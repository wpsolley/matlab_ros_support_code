function ret = pick(model_pose)
    %----------------------------------------------------------------------
    % pick 
    % Top-level function to executed a complete pick. 
    % 
    % 01 Get Goal and Current Pose
    % 02 
    %
    % Inputs
    % model_pose (gazebo_msgs/GetModelStateResponse): contains Pose/Twist
    % info on desired model
    %
    % Outputs:
    % ret (bool): indicates whether pick succeeded or not. 
    %----------------------------------------------------------------------
    
    %% Local variables
    traj_steps          = 10;   % Num of traj steps
    traj_duration       = 2;    % Traj duration (secs)
    tf_listening_time   = 2;    % Time (secs) to listen for transformation in ros
    
    %% 1. Get Goal|Current Pose 
    % Pick will create a cartesian trajectory from current configuration to the pose of the model. 
    
    % Convert model_pose to matlab formats.
    mat_obj_pose = ros2matlabPose(model_pose);
    
    % 1b. Current Robot Pose in Cartesian Format:
    tftree = rostf('DataFormat','struct'); % tftree.AvailableFrames  will show poses for all frames

    % Get gripper_tip_link pose wrt to base via getTransform(tftree,targetframe,sourceframe):
    %   tftree object
    %   targetframe: this is your reference frame
    %   sourceframe: 
    current_pose = getTransform(tftree,'base','gripper_tip_link',rostime('now'), 'Timeout', 5);

    % Convert to matlab format
    mat_cur_pose = ros2matlabPose(current_pose);

    %% 2. Call ctraj.
    mat_traj = ctraj(mat_cur_pose,mat_obj_pose,traj_steps);
    
    %% 3. Convert to joint angles via IKs
    [mat_joint_traj,rob_joint_names] = convertPoseTraj2JointTraj(mat_traj);
    
    %% 4. Create action client, message, populate ROS trajectory goal and send
    % Instantiate the 
    pick_traj_act_client = rosactionclient('/pos_joint_traj_controller/follow_joint_trajectory',...
                                           'control_msgs/FollowJointTrajectory', ...
                                           'DataFormat', 'struct');
    
    % Create action goal message from client
    traj_goal = rosmessage(pick_traj_act_client); 
    
    % Convert/fill in trajectory_msgs/FollowJointTrajectory
    % TODO: update packTrajGoal
    traj_goal = convert2ROSPointVec(mat_joint_traj,rob_joint_names,traj_steps,traj_duration,traj_goal);
    %traj_goal = ros2matPackTraj(ros_points_traj,traj_goal,rob_joint_names);% TODO: need to get names out
    
    % Finally send ros trajectory with traj_steps
    [traj_result_msg,traj_result_state] = sendGoal(pick_traj_act_client,traj_goal); 
    
    %% 5. Pick if successfull (check structure of resultState). Otherwise...
    if traj_result_state
        [grip_result_msg,grip_result_state] = doGrip('pick'); %%TODO
    end
end