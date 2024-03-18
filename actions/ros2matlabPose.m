function matlab_pose = ros2matlabPose(p)
    %----------------------------------------------------------------------
    % ROS geometry_msgs/Pose comes with Position.XYZ and Orientation.XYZW
    % p represents the model_pose in (x,y,z) and quaternion
    % Use RVC Toolbox to instantiate UnitQuaternion and build a homogeneous
    % transform by composing orientation and translation.
    %----------------------------------------------------------------------
    pos = [p.Position.X, p.Position.Y, p.Position.Z];
    q = UnitQuaternion(p.Orientation.W, [p.Orientation.X, p.Orientation.Y, p.Orientation.Z]);
    
    % Build matlab pose
    matlab_pose = q.T * transl(pos);
end