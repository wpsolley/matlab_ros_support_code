function pickFixedCan(x, y, z, theta, grip)
    %----------------------------------------------------------------------
    % This functions combines moveTopDownCan, pickTopDownCan, and
    % pickTopDownLift and adds parameters to generalize them for a can in
    % any configuration.
    %
    % Inputs:
    % doubles for coordinates x, y, and z
    % angle of rotation for gripper theta
    % tightness of gripper grip (0.22 upright can, 0.512 upright bottle)
    %
    % Outputs
    %
    %----------------------------------------------------------------------

%Trajectory to position above can - initialization
trajAct = rosactionclient('/pos_joint_traj_controller/follow_joint_trajectory',...
                          'control_msgs/FollowJointTrajectory')
trajGoal = rosmessage(trajAct)
trajAct.FeedbackFcn = []; 

grip_client = rosactionclient('/gripper_controller/follow_joint_trajectory', 'control_msgs/FollowJointTrajectory');
gripGoal    = rosmessage(grip_client);
gripPos     = 0.0;
gripGoal = packGripGoal(gripPos,gripGoal)
sendGoal(grip_client,gripGoal)



%Robot initialization
jointSub = rossubscriber("/joint_states")
jointStateMsg = jointSub.LatestMessage
UR5e = loadrobot('universalUR5e', DataFormat="row")
tform=UR5e.Bodies{3}.Joint.JointToParentTransform;    
UR5e.Bodies{3}.Joint.setFixedTransform(tform*eul2tform([pi/2,0,0]));

tform=UR5e.Bodies{4}.Joint.JointToParentTransform;
UR5e.Bodies{4}.Joint.setFixedTransform(tform*eul2tform([-pi/2,0,0]));

tform=UR5e.Bodies{7}.Joint.JointToParentTransform;
UR5e.Bodies{7}.Joint.setFixedTransform(tform*eul2tform([-pi/2,0,0]));

%Inverse Kinematics solver
ik = inverseKinematics("RigidBodyTree",UR5e); % Create Inverse kinematics solver
ikWeights = [0.25 0.25 0.25 0.1 0.1 .1]; % configuration weights for IK solver [Translation Orientation] see documentation

jointStateMsg = receive(jointSub,3) % receive current robot configuration
%IK Guesses

initialIKGuess = homeConfiguration(UR5e)
jointStateMsg.Name
initialIKGuess(1) = jointStateMsg.Position(4);  % Shoulder Pan
initialIKGuess(2) = jointStateMsg.Position(3);  % Shoulder Tilt
initialIKGuess(3) = jointStateMsg.Position(1);  % Elbow
initialIKGuess(4) = jointStateMsg.Position(5);  % W1
initialIKGuess(5) = jointStateMsg.Position(6);  % W2
initialIKGuess(6) = jointStateMsg.Position(7);  % W3;

%Hovering End-Effector Pose
gripperY = x;
gripperX = y;
gripperZ = z + 0.25;
gripperTranslation = [gripperY gripperX gripperZ];
gripperRotation    = [theta -pi 0]; %  [Z Y Z] radians
tform = eul2tform(gripperRotation); % ie eul2tr call
tform(1:3,4) = gripperTranslation'; % set translation in homogeneous transf

%Trajectory to position above rCan3 - implementation
[configSoln, solnInfo] = ik('tool0',tform,ikWeights,initialIKGuess)
UR5econfig = [configSoln(3)... 
              configSoln(2)...
              configSoln(1)...
              configSoln(4)...
              configSoln(5)...
              configSoln(6)]
trajGoal = packTrajGoal(UR5econfig,trajGoal)
sendGoalAndWait(trajAct,trajGoal)

%Introduce delay between steps
%pause('on');
%pause(5);

%Moving down to can
jointStateMsg = receive(jointSub,3) % receive current robot configuration
%IK Guesses
initialIKGuess = homeConfiguration(UR5e)
jointStateMsg.Name
initialIKGuess(1) = jointStateMsg.Position(4);  % Shoulder Pan
initialIKGuess(2) = jointStateMsg.Position(3);  % Shoulder Tilt
initialIKGuess(3) = jointStateMsg.Position(1);  % Elbow
initialIKGuess(4) = jointStateMsg.Position(5);  % W1
initialIKGuess(5) = jointStateMsg.Position(6);  % W2
initialIKGuess(6) = jointStateMsg.Position(7);  % W3;

%Lowered End-Effector Pose
gripperY = x;
gripperX = y;
gripperZ = z;
gripperTranslation = [gripperY gripperX gripperZ];
gripperRotation    = [theta -pi 0]; %  [Z Y Z] radians
tform = eul2tform(gripperRotation); % ie eul2tr call
tform(1:3,4) = gripperTranslation'; % set translation in homogeneous transf
pause(1)
%Trajectory to rCan3 - implementation
[configSoln, solnInfo] = ik('tool0',tform,ikWeights,initialIKGuess)
UR5econfig = [configSoln(3)... 
              configSoln(2)...
              configSoln(1)...
              configSoln(4)...
              configSoln(5)...
              configSoln(6)]
trajGoal = packTrajGoal(UR5econfig,trajGoal)
sendGoalAndWait(trajAct,trajGoal)

%Closing Gripper
grip_client = rosactionclient('/gripper_controller/follow_joint_trajectory','control_msgs/FollowJointTrajectory');                            
gripGoal    = rosmessage(grip_client)
gripPos  = grip;
gripGoal = packGripGoal(gripPos,gripGoal)
sendGoalAndWait(grip_client,gripGoal)

%Lifted End-Effector Pose
gripperY = x;
gripperX = y;
gripperZ = 0.7;
gripperTranslation = [gripperY gripperX gripperZ];
gripperRotation    = [theta -pi 0]; %  [Z Y Z] radians
tform = eul2tform(gripperRotation); % ie eul2tr call
tform(1:3,4) = gripperTranslation'; % set translation in homogeneous transf
pause(1)
%Trajectory to position above rCan3 - implementation
[configSoln, solnInfo] = ik('tool0',tform,ikWeights,initialIKGuess)
UR5econfig = [configSoln(3)... 
              configSoln(2)...
              configSoln(1)...
              configSoln(4)...
              configSoln(5)...
              configSoln(6)]
trajGoal = packTrajGoal(UR5econfig,trajGoal)

sendGoal(trajAct,trajGoal)

end