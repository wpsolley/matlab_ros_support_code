%exampleHelperROSCreateSampleNetwork 
%   Example of a ROS network with two services. 
%
%   Modified by Dr. Juan Rojas, 2024Feb. 
%   Copyright 2014-2021 The MathWorks, Inc.

% Initialize 3 nodes at ROS master at 'localhost'. 
% If you want to connect to an external master, use that IP address.
masterHost = 'localhost';

node_1 = ros.Node('node_1'); % If masterHost is localHost no need to add
node_2 = ros.Node('node_2', masterHost);
node_3 = ros.Node('node_3', masterHost);

%% Load Saved Data: scan  & TF
% Example data from pre-existing messages
messageData = load('specialROSMessageData.mat','scan','tf');

%% Pose and Scan Publishers  

%% Pose 
% A. Node 1 publisher object for the '/pose' topic 

% A.1. Node 1 Publisher (data not yet published to network, later with send() ).
twistPub = ros.Publisher(node_1,'/pose','geometry_msgs/Twist','DataFormat','struct');

% A.2. Create a variable of type of geometry_msgs/Twist (will be populated later)
twistPubmsg = rosmessage(twistPub);

%% Scan
% Create publisher and subscriber objects for the '/scan' topic (data not yet published to network, later with send() ).

% B.1. Node 3 Publisher (data not yet published to network, later with send() ).
scanPub = ros.Publisher(node_2,'/scan','sensor_msgs/LaserScan','DataFormat','struct'); 

% B.2. Create a variable of type of geometry_msgs/Twist (will be populated later)
% scanPubmsg = messageData.scan; % Not used since in this example no data is actually going to be created

%% Subscribers

% C.1 Node 3 Subscriber to pose
twistSub = ros.Subscriber(node_3,'/pose','geometry_msgs/Twist','DataFormat','struct', 'BufferSize', 10); % Buffer size helps to accumulate msgs if publisher faster than subsriber, default value is 1

% D.1 1 nodes will subscribe
scanSub1 = ros.Subscriber(node_3,'/scan','sensor_msgs/LaserScan','DataFormat','struct');

% Learn  more about the sensor_msgs/Laser scan message on ROS website documentation: 
% https://docs.ros.org/en/noetic/api/sensor_msgs/html/msg/LaserScan.html

%% Create Service Servers

% Service servers need to create a service topic and a service message type. 
% We will create 2 service servers: add and reply. 

% A. add service server
add_srv = ros.ServiceServer(node_3, ...                        % Node 
                            '/add', ...                        % Service topic
                            'roscpp_tutorials/TwoInts',...     % Service msg type
                            'DataFormat','struct');            % Struct

% B. reply service server
reply_srv = ros.ServiceServer(node_3, ...                           % Node
                              '/reply', ...                         % Service Topic
                              'std_srvs/Empty',...                  % Service msg type
                               @exampleHelperROSEmptyCallback, ...  % Callback - job defined
                               'DataFormat','struct');              % Structure

%% Sending the DATA

% In this section we will be doing 2 big things:
% 1. Update data for twistPub and scanPub
% 2. Repeatedely send out data at a particular rate (i.e. 10Hz).
%    Data will change each time it is sent out.

% To accomplish this, we will use a function called ExampleHelperROSTimer.
% This method takes 2 arguments: (i) rate and (ii) data. 
%
% We will integrate all data (i.e. publisher objects and message data) into 1 structure timeHandles
%   - Populate data and send inside exampleHelperROSSimTimer
%   - Call it at 10Hz via ExampleHelperROSTimer
%
% Create a structure timerHandles that will combine publisher objects and messages into one structure. 
%
% Publisher Objects
timerHandles.twistPub = twistPub;
timerHandles.scanPub = scanPub;

% Messages
timerHandles.twistPubmsg = twistPubmsg;
timerHandles.scanPubmsg = messageData.scan;

% 
simTimer = ExampleHelperROSTimer(0.1, ...                                   % How frequenctly should I publish? i.e. 10Hz
                                {@exampleHelperROSSimTimer,timerHandles});  % exampleHelperROSSimTimer is a program that populates the pose message. Takes in timerHandles

%   Loop will run ENDLESSLY (like a forever loop) changing data over time.
%   Only ends when you press ctrl+c. At which time clear memory
clear messageData
