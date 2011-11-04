/**
 * mmkvfree logger
 * In Karlovy Vary, there is free city wifi network, but you have to login every 
 * 30 minutes, and that sux. This program is cure for that suxiness..
 * 
 * Author:  Bystroushaak (bystrousak@kitakitsune.org)
 * Version: 1.1.0
 * Date:    04.11.2011
 * 
 * Copyright: 
 *     This work is licensed under a CC BY.
 *     http://creativecommons.org/licenses/by/3.0/
 * 
 * Todo:
 *    Fix second get()
 *    Upravit cas na hh:mm:ss, ne h:m:s
*/
import std.stdio;
import std.string;
import std.array : replace;
import std.md5;
import core.thread; // sleep
import std.datetime;

import dhttpclient;
import dhtmlparser;



const string LOL_PWD = "full"; // password & username, lol

HTTPClient cl;



string getRedirectUrl(string s){
	auto dom = parseString(s);
	auto url = dom.find("meta")[0].params["content"];
	if (url.indexOf("=") > 0)
		url = url[url.indexOf("=") + 1 .. $];
	
	return url;
}


void login(string url){
	// get octet password string from js code
	string password;
	foreach(string line; cl.get(url).splitLines())
		if (line.indexOf("document.sendin.password") > 0){
			password = line;
			break;
		}
	password = password.split("hexMD5(")[1][0 .. $ - 2].replace("'", "").replace(" + document.login.password.value + ", "\\-");
	
	// get md5 hash of salt and LOL_PWD
	ubyte[] real_password;
	foreach(octet; password.split("\\")){ // convert octets to ubyte
		if (octet == "-")
			foreach(c; LOL_PWD)
				real_password ~= c;
		else if (octet != ""){
			real_password ~= std.conv.parse!ubyte(octet, 8);
		}
	}
	password = getDigestString(real_password).toLower();
	
	// send POST data to login
	url = url[0 .. url.indexOf("?")];
	cl.post(url, ["username":"full", "password":password, "dst":"", "popup":"true"]);
}


/// visit logout page (ip.ip.ip.ip/logout)
void logout(string url){
	url = url[0 .. url.indexOf("?")].replace("login", "logout");
	cl.get(url);
}


// jeez, phobos is sometimes so lame, strftime is not yet impelemented..
string getFormatedTime(SysTime t){
	return format("[%02d:%02d:%02d]", t.hour, t.minute, t.second);
}



int main(string[] args){
	string s;
	cl = new HTTPClient();
	
	try{
		s = cl.get("http://seznam.cz");
		while(! (s.indexOf(`xml/WISPAccessGatewayParam.xsd`) > 0 && s.indexOf(`login?dst=http%3A%2F%2Fseznam.cz%2F`) > 0)){
			writeln(getFormatedTime(Clock.currTime()), " You are connected, waiting 2m for disconnect.");
			Thread.sleep(dur!("seconds")(2 * 60));
			s = cl.get("http://seznam.cz");
		}
	}catch(URLException e){
		stderr.writeln("Can't resolve 'seznam.cz', check your internet connection!");
		return 1;
	}
	
	string url = getRedirectUrl(s);
	
	try{
		while(1){
			login(url);
			writeln(getFormatedTime(Clock.currTime()), " Logged in, waiting 25m to reconect..");
			
			Thread.sleep(dur!("seconds")(25 * 60));
			
			logout(url);
			writeln(getFormatedTime(Clock.currTime()), " Logged out.");
		}
	}catch(Exception e){ // network is down, or something like that..
		logout(url);
		writeln("Logged out.");
	}
	
	return 0;
}