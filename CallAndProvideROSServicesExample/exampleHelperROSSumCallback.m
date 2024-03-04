function resp = exampleHelperROSSumCallback(~,req,resp)
%   exampleHelperROSSumCallback Callback function for a service to add two integers
%
%   RESP = exampleHelperROSSumCallback(~,REQ,RESP) adds two integers REQ.A
%   and REQ.B in the service request message REQ and returns them to the client
%   in the response message RESP.
%
%   Inputs:
%   - req: struc with fields A and B
%   - resp: struc with fields Sum (originally empty)
% 
%   Outputs:
%   - resp: the server will add the two ints and place the result in resp.Sum
%   before returning it. This output will be sent to the service client.
% 
%   Modified by Juan Rojas
%   Copyright 2014-2015 The MathWorks, Inc.

resp.Sum = req.A + req.B;

end