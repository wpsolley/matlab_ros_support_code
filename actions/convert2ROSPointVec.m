function ros_points_traj = convert2ROSPointVec(mat_joint_traj, traj_duration)
%------------
% Converts all of the matlab joint trajectory values into a vector of ROS
% Trajectory Points. 
%
% Inputs:
% mat_joint_traj (n x q) - matrix of n trajectory points for q joint values
% traj_duration double - duration of trajectory in seconds
%
% Outputs
% vector of TrajectoryPoints (1 x n)

    jointWaypointTimes = traj_duration;
    jointWaypoints = mat_joint_traj';
    numJoints = size(jointWaypoints,1);
    
    trajGoal.Trajectory.JointNames = {'elbow_joint','shoulder_lift_joint','shoulder_pan_joint','wrist_1_joint','wrist_2_joint','wrist_3_joint'};
    
    for idx = 1:numJoints
    
        trajGoal.GoalTolerance(idx) = rosmessage('control_msgs/JointTolerance');
        trajGoal.GoalTolerance(idx).Name = trajGoal.Trajectory.JointNames{idx};
        trajGoal.GoalTolerance(idx).Position = 0;
        trajGoal.GoalTolerance(idx).Velocity = 0;
        trajGoal.GoalTolerance(idx).Acceleration = 0;
    
    end
    
    trajPts = rosmessage('trajectory_msgs/JointTrajectoryPoint');
    trajPts.TimeFromStart = rosduration(jointWaypointTimes);
    trajPts.Positions = jointWaypoints;
    trajPts.Velocities = zeros(size(jointWaypoints));
    trajPts.Accelerations = zeros(size(jointWaypoints));
    trajPts.Effort = zeros(size(jointWaypoints));
    
    trajGoal.Trajectory.Points = trajPts;
end