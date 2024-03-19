function robot = urdfAdjustment(robot,name)
% Adjusts Forward Kins according to URDF

    % Set specific adjustments depending on the robot
    if  strcmp(name,'robot')

        % shoulder_link needs to be rotated by 90 degrees around Z wrt parent
        tform=robot.Bodies{3}.Joint.JointToParentTransform;    
        robot.Bodies{3}.Joint.setFixedTransform(tform*eul2tform([pi/2,0,0]));
        
        % upper_arm_link needs to be rotated by -90 degrees around Z wrt parent
        tform=robot.Bodies{4}.Joint.JointToParentTransform;
        robot.Bodies{4}.Joint.setFixedTransform(tform*eul2tform([-pi/2,0,0]));
        
        % Wrist_2_link needs to be rotated by -90 degrees around Z wrt parent
        tform=robot.Bodies{7}.Joint.JointToParentTransform;
        robot.Bodies{7}.Joint.setFixedTransform(tform*eul2tform([-pi/2,0,0]));
    end
end