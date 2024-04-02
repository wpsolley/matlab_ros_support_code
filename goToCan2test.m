% -------------------------------------------------------------------
%  Generated by MATLAB on 28-Mar-2024 17:19:40
%  MATLAB version: 23.2.0.2459199 (R2023b) Update 5
% -------------------------------------------------------------------
saveVarsMat = load('goToCan2test.mat');

UR5e = saveVarsMat.UR5e; % <1x1 rigidBodyTree> unsupported class

UR5econfig = [-1.0896018355010317 1.9157268051562537 6.1406470301623672 ...
              5.4570603339286956 6.28318530718 -3.2841309260837064];

ans = struct;
ans.MessageType = 'control_msgs/FollowJointTrajectoryResult';
ans.ErrorCode = int32(-4);
ans.SUCCESSFUL = int32(0);
ans.INVALIDGOAL = int32(-1);
ans.INVALIDJOINTS = int32(-2);
ans.OLDHEADERTIMESTAMP = int32(-3);
ans.PATHTOLERANCEVIOLATED = int32(-4);
ans.GOALTOLERANCEVIOLATED = int32(-5);
ans.ErrorString = 'wrist_1_joint path error -0.100297';

configSoln = [6.1406470301623672 1.9157268051562537 -1.0896018355010317 ...
              5.4570603339286956 6.28318530718 -3.2841309260837064];

gripGoal = saveVarsMat.gripGoal; % <1x1 ros.msggen.control_msgs.FollowJointTrajectoryGoal> unsupported class

gripPos = 0.8;

grip_client = saveVarsMat.grip_client; % <1x1 ros.SimpleActionClient> unsupported class

gripperRotation = [0 -3.1415926535897931 0];

gripperTranslation = [-0.02 0.799 0.185];

gripperX = -0.02;

gripperY = 0.799;

gripperZ = 0.185;

ik = saveVarsMat.ik; % <1x1 inverseKinematics> unsupported class

ikWeights = [0.25 0.25 0.25 0.1 0.1 0.1];

initialIKGuess = [94.2475953484826 -4.1599243680856546E-5 -67.544242196503419 ...
                  23.561944881612188 18.849498782695996 9.2514475937832685E-6 ...
                  ];

jointStateMsg = saveVarsMat.jointStateMsg; % <1x1 ros.msggen.sensor_msgs.JointState> unsupported class

jointSub = saveVarsMat.jointSub; % <1x1 ros.Subscriber> unsupported class

pose = [0.799 -0.02 0.185 0 -3.1415926535897931 0];

solnInfo = struct;
solnInfo.Iterations = 43;
solnInfo.NumRandomRestarts = 0;
solnInfo.PoseErrorNorm = 2.7111807257543029E-13;
solnInfo.ExitFlag = 1;
solnInfo.Status = 'success';

surf_path = 'C:\Users\wpsol\Documents\GitHub\matlab_ros_support_code';

tform = ...
  [-1 -0 -1.2246467991473532E-16 -0.02;
   -0 1 -0 0.799;
   1.2246467991473532E-16 -0 -1 0.185;
   0 0 0 1];

trajAct = saveVarsMat.trajAct; % <1x1 ros.SimpleActionClient> unsupported class

trajGoal = saveVarsMat.trajGoal; % <1x1 ros.msggen.control_msgs.FollowJointTrajectoryGoal> unsupported class

clear saveVarsMat;