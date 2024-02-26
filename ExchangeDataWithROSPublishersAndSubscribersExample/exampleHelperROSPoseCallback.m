function exampleHelperROSPoseCallback(~, message)
    % exampleHelperROSPoseCallback Subscriber callback function for pose data    
    % This function will get called everytime a message is published to the
    % subscribed topic. Data will be stored in message.
    %
    % The global variables created below will be available everywhere in
    % matlab. 
    % 
    % You can use them elsewhere (i.e. your controller) to drive the robot.
    % Copyright 2014-2015 The MathWorks, Inc.
    
    % Declare global variables to store position and orientation
    global pos
    global orient
    
    % Extract position and orientation from the ROS message and assign the
    % data to the global variables.
    pos = [message.Linear.X ...
           message.Linear.Y ...
           message.Linear.Z];

    orient = [message.Angular.X ...
              message.Angular.Y ... 
              message.Angular.Z];
end