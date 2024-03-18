function mat_joint_traj = convertPoseTraj2JointTraj(mat_traj)

    %-------------------------------------------------------------
    % Compute IKs for Cartesian trajectory. Will need to:
    % 1. Create an array of joint angles the same size as trajectory
    % 2. Instantiate a UR5 object
    % 3. Perform adjustments for URDF Fwd Kins
    % 4. Instantiate numerical IK object for Robot
    % 5. Loop through trajectory
    % 6. Extract solution w/ checks-- first one for right/elbow/down. 
    % 
    
    %1. Size in terms 4x4xn
    traj_sz = size(mat_traj);
    
    % Create trajectory of joint angles as a row matrix of 6 joint angles for the UR5e
    mat_joint_traj = size(traj_sz(1,3),6);
    
    %2. Create UR5
    UR5e = loadrobot('universalUR5e', DataFormat="row");
    
    % 3. Adjust the forward kinematics to match the URDF model in Gazebo:
    name = 'UR5e';
    UR5e = urdfAdjustment(UR5e,name);
    
    
    % 4. Create the numerical IK Solver
    ik = inverseKinematics("RigidBodyTree",UR5e);
    
    % Set solver weights
    ikWeights = [0.25 0.25 0.25 0.1 0.1 .1];
    
    % Set initial guess to current position
    joint_state_sub = rossubscriber("/joint_states");
    ros_cur_jnt_state_msg = receive(joint_state_sub,3);
   
    % Reorder from ROS format to Matlab format, need names.
    % Create ur5e names in cell structure equal to the type in ROS
    ur5e_joint_names = {'shoulder_pan_joint','shoulder_lift_joint','elbow_joint','wrist_1_joint','wrist_2_joint','wrist_3_joint','robotiq_85_left_knuckle_joint'}; % TODO: can we automate the extraction of these names
    mat_cur_q = ros2matlabJoints(ros_cur_jnt_state_msg,ur5e_joint_names);
    
    
    % Go through trajectory loop
    % Check for time complexity. Can we improve efficiency.
    for i = 1:traj_sz(1,3)
        [des_q, solnInfo] = ik('tool0',mat_traj(:,:,i),ikWeights,mat_cur_q); % Should we update initial guess with the latest q_traj value?
        
        % Set the column of q's to the row
        %q_sz = size(des_q);
        mat_joint_traj(i,:) = des_q(1,:);
    end
end

