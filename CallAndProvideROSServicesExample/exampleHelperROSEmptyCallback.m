function resp = exampleHelperROSEmptyCallback(~,~,resp)
%exampleHelperROSEmptyCallback Callback function used by a ROS service server
%   exampleHelperROSEmptyCallback(~,~,RESP) returns no arguments. it simply
%   displays a message indicating that it has been called.
%
%   See also ROSServicesExample, exampleHelperROSCreateSampleNetwork.

%   Copyright 2014-2015 The MathWorks, Inc.

disp(newline)
disp('-------------------------------------------------------------------')
disp('Service Server is running.');
disp('ROS Service client issued a call');
disp('Would normally process input resp and produce a useful output again in resp')
disp('-------------------------------------------------------------------')
end