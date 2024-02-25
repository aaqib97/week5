
local event = freeswitch.Event("SEND_MESSAGE");
event:addHeader("profile","internal");
event:addHeader("content-length","10");
event:addHeader("content-type","text/plain");
event:addHeader("user","1001");
event:addHeader("host","192.168.1.6");
event:addBody("404 User Not Found");
event:fire();

