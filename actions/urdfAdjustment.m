function robot = urdfAdjustment(robot,name)
% Adjusts Forward Kins according to URDF

    % Set specific adjustments depending on the robot
    if  strcmp(name,'UR5e')
        tform=UR5e.Bodies{3}.Joint.JointToParentTransform;    
        UR5e.Bodies{3}.Joint.setFixedTransform(tform*eul2tform([pi/2,0,0]));
        
        tform=UR5e.Bodies{4}.Joint.JointToParentTransform;
        UR5e.Bodies{4}.Joint.setFixedTransform(tform*eul2tform([-pi/2,0,0]));
        
        tform=UR5e.Bodies{7}.Joint.JointToParentTransform;
        UR5e.Bodies{7}.Joint.setFixedTransform(tform*eul2tform([-pi/2,0,0]));
    end
end