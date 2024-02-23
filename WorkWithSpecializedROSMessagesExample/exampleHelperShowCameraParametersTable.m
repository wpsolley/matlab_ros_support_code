%exampleHelperShowCameraParametersTable Display cameraParameters
% correspondence table. This script constructs a table that shows the 
% correspondence between a ROS sensor_msgs/CameraInfo message and 
% cameraParameters object.   
%
%   See also ROSSpecializedMessagesExample.

%   Copyright 2021 The MathWorks, Inc.

columnNames = ["ROS message","camera parameters"];
rowNames = ["Intrinsic matrix","Radial distortion","Tangential distortion",...
            "Height","Width"];
cameraFields = ["IntrinsicMatrix","RadialDistortion","TangentialDistortion"...
                "ImageSize(1)","ImageSize(2)"]';
rosFields = ["K","D(1:2)","D(3:5)","Height","Width"]';
% Display table
table(rosFields,cameraFields, VariableNames=columnNames,RowNames=rowNames)