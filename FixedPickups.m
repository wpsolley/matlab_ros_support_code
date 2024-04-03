function FixedPickups
rosshutdown
rosinit('10.51.57.138');
pause(2)
goHome('qr')
%Open End-Effector
grip_client = rosactionclient('/gripper_controller/follow_joint_trajectory','control_msgs/FollowJointTrajectory');                            
gripGoal    = rosmessage(grip_client)
gripPos     = 0;
gripGoal = packGripGoal(gripPos,gripGoal)
sendGoal(grip_client,gripGoal)
resetWorld
pause(1)


%Item coordinates
%rCan1 = [0.295, 0.503, 0.573, pi/2, 0.22];
%gCan1 = [-0.363, -0.006, 0.235, pi/2, 0.22];

% rCan3
gripperY = -0.02
gripperX = 0.799 ;
gripperZ = 0.3732;
pickFixedCan(gripperY, gripperX, gripperZ, pi/2, .515)
greenDropOff

% %Red can 1 vert
pickFixedCan(-0.503, 0.395, 0.13, pi/2, 0.22)
greenDropOff
pause(1)

%gCan1
pickFixedCan(-0.363, -0.006, 0.235, pi/2, 0.23)
greenDropOff
pause(1)

%Yellow bottle hoz, gripperRotation    = [0 -pi 0]
 gripperY = -0.526;
 gripperX = -0.073;
 gripperZ = 0.08;
 pickFixedCan(gripperY, gripperX, gripperZ, pi/2, .515)
 pause(1)
 blueDropOff
 pause(1)

%Yellow bottle hoz, gripperRotation    = [0 -pi 0]
gripperY = -0.526;
gripperX = -0.073;
gripperZ = 0.08;
pickFixedCan(gripperY, gripperX, gripperZ, -pi, .21)
 blueDropOff
pause(2)

%blue bottle vert
gripperY = 0.46;
gripperX = -0.07;
gripperZ = 0.22
pickFixedCan(gripperY, gripperX, gripperZ, -pi, .512)
blueDropOff

%Red can vert, high
gripperY = 0.667;
gripperX = 0.023;
gripperZ = 0.24;
pickFixedCan(gripperY, gripperX, gripperZ, -pi, .225)
greenDropOff

%Green can 3 vert
gripperY = 0.667;
gripperX = 0.023;
gripperZ = 0.13;
pickFixedCan(gripperY, gripperX, gripperZ, -pi, .225)
greenDropOff

%Green Can vert 1, in box
gripperY = 0.529;
gripperX = 0.469;
gripperZ = 0.14; 
pickFixedCan(gripperY, gripperX, gripperZ, -pi, .225)
greenDropOff

%Yellow Can vert 1, in box
gripperY = 0.45;
gripperX = 0.46;
gripperZ = 0.14;
pickFixedCan(gripperY, gripperX, gripperZ, -pi, .225)
greenDropOff

%Yellow Can vert 1
gripperY = -0.170194;
gripperX = 0.699955;
gripperZ = 0.13;
pickFixedCan(gripperY, gripperX, gripperZ, -pi, .225)
greenDropOff

%Yellow can 2 hoz
gripperY = 0.482;
gripperX = 0.65;
gripperZ = 0.085;
pause(1)
pickFixedCan(gripperY, gripperX, gripperZ, pi/4, .228)
pause(1)
greenDropOff







end