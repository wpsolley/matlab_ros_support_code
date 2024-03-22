function robot = urdfAdjustment(robot,name)
% Adjusts Forward Kins according to URDF

    % Set specific adjustments depending on the robot
    if  strcmp(name,'UR5e')

        % shoulder_link needs to be rotated by 90 degrees around Z wrt parent
        tform=robot.Bodies{3}.Joint.JointToParentTransform;    
        robot.Bodies{3}.Joint.setFixedTransform(tform*eul2tform([pi/2,0,0]));
        
        % upper_arm_link needs to be rotated by -90 degrees around Z wrt parent
        tform=robot.Bodies{4}.Joint.JointToParentTransform;
        robot.Bodies{4}.Joint.setFixedTransform(tform*eul2tform([-pi/2,0,0]));
        
        % Wrist_2_link needs to be rotated by -90 degrees around Z wrt parent
        tform=robot.Bodies{7}.Joint.JointToParentTransform;
        robot.Bodies{7}.Joint.setFixedTransform(tform*eul2tform([-pi/2,0,0]));

        % Add the tool
        link_tip = rigidBody("tip");
        link_tip.Joint = rigidBodyJoint("tool0-link_tip","fixed");
        tool2tip = se3(rpy2r(0,-pi/2,-pi/2),[0,0,0.1670]);
        link_tip.Joint.setFixedTransform(tool2tip);
        robot.addBody(link_tip,robot.BodyNames{10});
        %TODO: Do i need to create a trivial child???

        % Check
        robot.showdetails
    end
end