function goHome

    joint_state_sub = rossubscriber("/joint_states");
    ros_cur_jnt_state_msg = receive(joint_state_sub,1)

    pick_traj_act_client = rosactionclient('/pos_joint_traj_controller/follow_joint_trajectory',...
                                           'control_msgs/FollowJointTrajectory', ...
                                           'DataFormat', 'struct');
    
    % Create action goal message from client
    traj_goal = rosmessage(pick_traj_act_client); 
    
    % Convert to trajectory_msgs/FollowJointTrajectory
    traj_goal = convert2ROSPointVec(zeros(1,6),ros_cur_jnt_state_msg.Name,1,1,traj_goal);
    
    % Finally send ros trajectory with traj_steps
    sendGoal(pick_traj_act_client,traj_goal); 
end