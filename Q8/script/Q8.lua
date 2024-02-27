local api=freeswitch.API()

local dbh = freeswitch.Dbh("odbc://freeswitch:aaqib:A@qib_1997")

local event = freeswitch.Event("CHANNEL_CREATE")
assert(dbh:connected())

dbh:test_reactive("SELECT * FROM Q8","DROP TABLE Q8","CREATE TABLE Q8 (empID int NOT NULL AUTO_INCREMENT,number int,calluuid varchar(255),fromNumber varchar(255),toNumber varchar(255), remoteIp varchar(255),PRIMARY KEY (empID))")

local uuid = tostring(session:getVariable("uuid"))
local fromNumber = tostring(session:getVariable("ani"))
local toNumber = tostring(session:getVariable("destination_number"))
local remoteIp = tostring(session:getVariable("network_addr"))
local function insertUser()
 return dbh:query("insert into Q8 (calluuid,fromNumber,toNumber,remoteIp) values(".."\""..uuid.."\""..",".."\""..fromNumber.."\""..",".."\""..toNumber.."\""..",".."\""..remoteIp.."\""..")")
end
session:execute("set","uuid="..uuid)
while (number_table==NULL) do

	dbh:query("select fromNumber from Q8 where fromNumber="..fromNumber,function(row) 
	number_table=string.format("%s",row.fromNumber)
	end)
	if (number_table==NULL) then
		digit=session:playAndGetDigits(1,2,2,5000,"#","ivr/you_aren\'t_auth_prompt.wav","voicemail/8000/vm-fail_auth.wav","\\d+")
		

		if (digit=="1") and (assert(insertUser())==true)then
		insertUser()
		session:execute("playback","ivr/now_auth.wav")
		end
		if (digit=="2") or (assert(insertUser())==false) then
		session:execute("playback","ivr/check_with_tech_dep.wav")
		end
	end

end

repeat
session:execute("playback","ivr/welcome_eco_prompt.wav")
	repeat
	langDigit=session:playAndGetDigits(1,2,2,5000,"#","ivr/select_language.wav","voicemail/8000/vm-fail_auth.wav","\\d+")
	until (langDigit~="0")
until (langDigit~="9")

repeat
digit=session:playAndGetDigits(5,10,1,10000,"#","ivr/enter_mo_no.wav","voicemail/8000/vm-fail_auth.wav","\\d+")
until (#digit==10)

dbh:query("update Q8 set number="..digit.." where fromNumber="..fromNumber)

local replay=0;

repeat 
	if (langDigit=="1")then
	digit=session:playAndGetDigits(1,1,3,10000,"#","ivr/hindi_prompt.wav","voicemail/8000/vm-fail_auth.wav","\\d+")
	end if (langDigit=="2")then
	digit=session:playAndGetDigits(1,1,3,10000,"#","ivr/english_prompt.wav","voicemail/8000/vm-fail_auth.wav","\\d+")
	end if (langDigit=="3")then
	digit=session:playAndGetDigits(1,1,3,10000,"#","ivr/gujarati_prompt.wav","voicemail/8000/vm-fail_auth.wav","\\d+")
	end
	replay = replay + 1
until (digit=="1" or digit=="2" or digit=="3" or replay>2)

if (digit=="1") then
session:execute("bridge","user/9812678@$${domain}")
end if (digit=="2") then
session:execute("voicemail","default $${domain} 1000")
end if (digit=="3") then
session:execute("playback","ivr/30_sec.mp3")
session:execute("conference","bridge:"..uuid..":user/9812678@$${domain}")
end

