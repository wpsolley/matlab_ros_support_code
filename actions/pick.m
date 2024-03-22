function ret = pick(robot_pose, model_pose)
    %----------------------------------------------------------------------
    % pick 
    % Top-level function to executed a complete pick. 
    % 
    % 01 Get Goal and Current Pose
    % 02 
    %
    % Inputs
    % robot_pose  (gazebo_msgs/GetModelStateResponse): contains Pose/Twist
    % model_pose (gazebo_msgs/GetModelStateResponse): contains Pose/Twist
    % info on desired model
    %
    % Outputs:
    % ret (bool): indicates whether pick succeeded or not. 
    %----------------------------------------------------------------------
    
    %% Local variables
    debug               = 1;     % If set to true visualize traj before running  
    traj_steps          = 2;    % Num of traj steps
    traj_duration       = 2;    % Traj duration (secs)
    tf_listening_time   = 10;    % Time (secs) to listen for transformation in ros
    
    %% 1. Get Goal|Current Pose 
    % Pick will create a cartesian trajectory from current configuration to the pose of the model. 
    
    % Convert model_pose to matlab formats wrt robot (adjust the orientation of the gripper here)
    mat_W_T_R = ros2matlabPose(robot_pose);
    mat_W_T_M = ros2matlabPose(model_pose);

    % Change reference frame to be wrt to robot
    mat_R_T_M = inv(mat_W_T_R)*mat_W_T_M; 

    % Change reference fram to be from Gazebo to Rviz
    Rviz_T_Gazebo = rotz(pi);
    mat_R_T_M(1:3,4) = Rviz_T_Gazebo * mat_R_T_M(1:3,4);

    % Modify orientation of robot pose to be  a top-down pick
    %mat_R_T_M(1:3,1:3) = rpy2r(0, pi/2, pi/2);
    %mat_R_T_M(1:3,1:3) = eul2r([-pi/2 -pi 0]);

    % 1b. Current Robot Pose in Cartesian Format:
    tftree = rostf('DataFormat','struct'); % tftree.AvailableFrames  will show poses for all frames
    %tftree.BufferTime = tf_listening_time;

    % Get gripper_tip_link pose wrt tzo base via getTransform(tftree,targetframe,sourceframe):
    %   tftree object
    %   targetframe: this is your reference frame
    %   sourceframe: 
    try
        current_pose = getTransform(tftree,'base','gripper_tip_link', rostime('now'), 'Timeout', tf_listening_time);
    catch
        % Try again: did not manage to compute the transformation 
        current_pose = getTransform(tftree,'base','gripper_tip_link', rostime('now'), 'Timeout', tf_listening_time);
    end

    % Convert gripper pose to matlab format in rviz frame
    mat_R_T_G = ros2matlabPose(current_pose);
    mat_R_T_M(1:3,1:3) = mat_R_T_G(1:3,1:3); % Set pick coord frame same as grip startinga
    % Debug
    % Corroborate gripper_tip_link_pose by computing FKs with current joint
    % angles
    ur5e = loadrobot("universalUR5e",DataFormat="row");
    % mat_R_T_G_FK = ur5e.getTransform(deg2rad([30 40]),"link3")
    % Add tool transform...

    %% 2. Call ctraj.
    %mat_traj = ctraj(mat_R_T_G,mat_R_T_M,traj_steps); % Currently unstable due to first ik transformation of joints. Just do one point.
    mat_traj = mat_R_T_M;
    
    %% 3. Convert to joint angles via IKs
    [mat_joint_traj,rob_joint_names] = convertPoseTraj2JointTraj(ur5e,mat_traj);

    %% Visualize trajectory
    if debug
        r = rateControl(1);
        for i = 1:size(mat_joint_traj,1)
            ur5e.show(mat_joint_traj(i,:),FastUpdate=true,PreservePlot=false);
            r.waitfor;
        end
    end
    
    %% 4. Create action client, message, populate ROS trajectory goal and send
    % Instantiate the 
    pick_traj_act_client = rosactionclient('/pos_joint_traj_controller/follow_joint_trajectory',...
                                           'control_msgs/FollowJointTrajectory', ...
                                           'DataFormat', 'struct');
    
    % Create action goal message from client
    traj_goal = rosmessage(pick_traj_act_client); 
    
    % Convert to trajectory_msgs/FollowJointTrajectory
    traj_goal = convert2ROSPointVec(mat_joint_traj,rob_joint_names,traj_steps,traj_duration,traj_goal);
    
    % Finally send ros trajectory with traj_steps
    sendGoal(pick_traj_act_client,traj_goal); 

    % If you want to cancel the goal, run this command
    %cancelGoal(pick_traj_act_client);
    
    %% 5. Pick if successfull (check structure of resultState). Otherwise...
    % if traj_result_state
    %[grip_result_msg,grip_result_state] = 
    doGrip('pick'); %%TODO
    % end
end