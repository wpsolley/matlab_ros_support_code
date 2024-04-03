function blueDropOff
%Action initialization
trajAct = rosactionclient('/pos_joint_traj_controller/follow_joint_trajectory',...
                          'control_msgs/FollowJointTrajectory')
trajGoal = rosmessage(trajAct)
trajAct.FeedbackFcn = []; 

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

%Blue Bin End-Effector Pose
gripperY = 0.5;
gripperX = -0.3;
gripperZ = 0.5;
gripperTranslation = [gripperY gripperX gripperZ];
gripperRotation    = [-pi/2 -pi 0]; %  [Z Y Z] radians
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

%Open End-Effector
grip_client = rosactionclient('/gripper_controller/follow_joint_trajectory','control_msgs/FollowJointTrajectory');                            
gripGoal    = rosmessage(grip_client)
gripPos     = 0;
gripGoal = packGripGoal(gripPos,gripGoal)
pause(1)
sendGoal(grip_client,gripGoal)
pause(1)
end