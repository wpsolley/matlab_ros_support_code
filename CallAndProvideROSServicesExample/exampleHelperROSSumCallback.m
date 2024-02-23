function resp = exampleHelperROSSumCallback(~,req,resp)
%exampleHelperROSSumCallback Callback function for a service to add two integers
%   RESP = exampleHelperROSSumCallback(~,REQ,RESP) adds the two integers A
%   and B in the service request message REQ and returns them to the client
%   in the response message RESP.
%
%   And empty response message is given as an argument to this function and
%   after assigning data to it, it has to be returned as a single output
%   argument. This output will be sent to the service client.
%
%   See also ROSServicesExample.

%   Copyright 2014-2015 The MathWorks, Inc.

resp.Sum = req.A + req.B;

end