%function pickTopDownCan

%Call moveTopDownCan
moveTopDownCan;

%Introduce delay to distinguish steps
pause('on')
pause(4)

%Closing Gripper
grip_client = rosactionclient('/gripper_controller/follow_joint_trajectory','control_msgs/FollowJointTrajectory');                            
gripGoal    = rosmessage(grip_client)
gripPos     = 0.225;
gripGoal = packGripGoal(gripPos,gripGoal)
sendGoal(grip_client,gripGoal)
%end