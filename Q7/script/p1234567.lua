
local dbh=freeswitch.Dbh("odbc://freeswitch:aaqib:A@qib_1997")

if (dbh:connected()) then
	session:consoleLog("info","**************Database Is Connected***************")
else
	session:consoleLog("info","**************Database Is Not Connected***************** ")
end
