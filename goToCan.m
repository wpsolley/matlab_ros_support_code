%function [pose]=goToCan

%Closing Gripper
grip_client = rosactionclient('/gripper_controller/follow_joint_trajectory','control_msgs/FollowJointTrajectory');                            
gripGoal    = rosmessage(grip_client);
gripPos     = 0.8;
gripGoal    = packGripGoal(gripPos,gripGoal);
sendGoal(grip_client,gripGoal)

%Trajectory to position atop rCan3 - initialization
trajAct = rosactionclient('/pos_joint_traj_controller/follow_joint_trajectory', 'control_msgs/FollowJointTrajectory');
trajGoal = rosmessage(trajAct);
trajAct.FeedbackFcn = [];

%Robot initialization
jointSub = rossubscriber("/joint_states");
jointStateMsg = jointSub.LatestMessage;
UR5e = loadrobot('universalUR5e', DataFormat="row");
tform = UR5e.Bodies{3}.Joint.JointToParentTransform;
UR5e.Bodies{3}.Joint.setFixedTransform(tform*eul2tform([pi/2, 0, 0]));
tform = UR5e.Bodies{4}.Joint.JointToParentTransform;
UR5e.Bodies{4}.Joint.setFixedTransform(tform*eul2tform([-pi/2, 0, 0]));
tform = UR5e.Bodies{7}.Joint.JointToParentTransform;
UR5e.Bodies{7}.Joint.setFixedTransform(tform*eul2tform([-pi/2, 0, 0]));

%Inverse Kinematics solver
ik = inverseKinematics("RigidBodyTree", UR5e);
ikWeights = [0.25 0.25 0.25 0.1 0.1 0.1];

jointStateMsg = receive(jointSub,3);
%IK Guesses
initialIKGuess = homeConfiguration(UR5e);
initialIKGuess(1) = jointStateMsg.Position(4);
initialIKGuess(2) = jointStateMsg.Position(3);
initialIKGuess(3) = jointStateMsg.Position(1);
initialIKGuess(4) = jointStateMsg.Position(5);
initialIKGuess(5) = jointStateMsg.Position(6);
initialIKGuess(6) = jointStateMsg.Position(7);

%End-Effector Pose
gripperY = 0.799;
gripperX = -0.02;
gripperZ = 0.185;
gripperTranslation = [gripperX gripperY gripperZ];
gripperRotation = [0 -pi 0];
tform = eul2tform(gripperRotation);
tform(1:3,4) = gripperTranslation;

%Trajectory to position atop rCan3 - implementation
[configSoln, solnInfo] = ik('tool0', tform, ikWeights, initialIKGuess);
UR5econfig = [configSoln(3) configSoln(2) configSoln(1) configSoln(4) configSoln(5) configSoln(6)];
trajGoal = packTrajGoal(UR5econfig, trajGoal);
sendGoal(trajAct, trajGoal);

pose=[0.799,-0.02,0.185,0,-pi,0]
%end

