function trajGoal = convert2ROSPointVec(mat_joint_traj, robot_joint_names, traj_steps, traj_duration, traj_goal)
%--------------------------------------------------------------------------
% convert2ROSPointVec
% Converts all of the matlab joint trajectory values into a vector of ROS
% Trajectory Points. 
%
% Inputs:
% mat_joint_traj (n x q) - matrix of n trajectory points for q joint values
% robot_joint_names {} - cell of robot joint names
% traj_steps (double) - num of steps in trajectory
% traj_duration double - duration of trajectory in seconds
% traj_goal (FollowJointTrajectoryGoal)
%
% Outputs
% vector of TrajectoryPoints (1 x n)
%--------------------------------------------------------------------------
  
    numPoints = size(jointWaypoints,1);
    timeStep = traj_duration / numPoints;
    
    trajGoal.Trajectory.JointNames = robot_joint_names;
    
    %% Set Tolerances
    % Create Tolerance Message
    trajGoal.GoalTolerance(idx) = rosmessage('control_msgs/JointTolerance');

    % Populate
    trajGoal.GoalTolerance(idx).Name = trajGoal.Trajectory.JointNames{idx};
    trajGoal.GoalTolerance(idx).Position = 0;
    trajGoal.GoalTolerance(idx).Velocity = 0;
    trajGoal.GoalTolerance(idx).Acceleration = 0;

    %% Set Points

    % Set an array of cells
    points = cell(1,numPoints);

    % Create Point message
    point = rosmessage('trajectory_msgs/JointTrajectoryPoint');

    for i = 1:numPoints

        % Extract each waypoint
	    point.Positions     = mat2rosJoints( mat_joint_traj(i, :) );    

        % Set time with format as structure
	    point.TimeFromStart = rosduration( (i-1) * timeStep, 'DataFormat','struct');    
	    
        % Set inside points cell
        points{i} = point;   
    end
    
    trajGoal.Trajectory.Points = [ points{:} ];
end