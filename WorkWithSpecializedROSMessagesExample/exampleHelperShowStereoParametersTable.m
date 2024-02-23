%exampleHelperShowStereoParametersTable Display stereoParameters
% correspondence table. This script constructs a table that shows the 
% correspondence between a ROS sensor_msgs/CameraInfo message and 
% stereoParameters object.   
%
%   See also ROSSpecializedMessagesExample.

%   Copyright 2021 The MathWorks, Inc.

columnNames = ["ROS message","stereoParameters"];
rowNames = ["Translation of camera 2","Rotation of camera 2"]';
cameraFields = ["TranslationOfCamera2(1:2)","RotationOfCamera2"]';
rosFields = ["P(:,1:2)","inv(R1)*R2"]';
% Display table
table(rosFields,cameraFields, VariableNames=columnNames,RowNames=rowNames)