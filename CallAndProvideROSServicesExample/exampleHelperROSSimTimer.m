function exampleHelperROSSimTimer(~, ~, handles)
    %exampleHelperROSSimTimer - Timer update function called in startExamples to publish
    %   messages at well-defined intervals
    %   exampleHelperROSSimTimer(~,~,HANDLES) publishes /pose and /scan messages at
    %   regular intervals. The /scan message value remains constant while
    %   the /pose message value changes continually.
    %   
    %   See also exampleHelperROSCreateSampleNetwork
    
    %   Copyright 2014-2021 The MathWorks, Inc.
    
    % Assumes a twist message with linear and angular values. 
    % Update the pose message values
    if isvalid(handles.twistPub)

        handles.twistPubmsg.Linear.X = handles.twistPubmsg.Linear.X + (rand(1)-0.5)./10;
        handles.twistPubmsg.Linear.Y = handles.twistPubmsg.Linear.Y + (rand(1)-0.5)./10;
        handles.twistPubmsg.Linear.Z = handles.twistPubmsg.Linear.Z + (rand(1)-0.5)./10;

        handles.twistPubmsg.Angular.X = handles.twistPubmsg.Angular.X + (rand(1)-0.5)./10;
        handles.twistPubmsg.Angular.Y = handles.twistPubmsg.Angular.Y + (rand(1)-0.5)./10;
        handles.twistPubmsg.Angular.Z = handles.twistPubmsg.Angular.Z + (rand(1)-0.5)./10;
    
        % Publish the pose messages via send
        %  SEND(PUB,MSG) publishes a message MSG to the topic advertised by the publisher PUB.
        send(handles.twistPub,handles.twistPubmsg);
    end
       
    % Publish scan data. 
    if isvalid(handles.scanPub)
        % Before we publish, populate the header with the current time. 
        % Use rostime function. See 'help rostime' for more details.
        handles.scanPubmsg.Header.Stamp = rostime('now',... % return the current time
                                                  'system',... % return the computer's system time vs simulated time in topic /clock
                                                  'DataFormat',handles.scanPub.DataFormat); % return format as the type of scanPub.Dataformat which is struct
        
        % Publish the scan messages via send
        send(handles.scanPub,handles.scanPubmsg);
    end
end