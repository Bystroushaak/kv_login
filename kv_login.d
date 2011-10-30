/**
 * mmkvfree logger
 * In Karlovy Vary, there is free city wifi network, but you have to login every 
 * 30 minutes, and that sux. This program is cure for that suxiness..
 * 
 * Author:  Bystroushaak (bystrousak@kitakitsune.org)
 * Version: 1.0.0
 * Date:    30.10.2011
 * 
 * Copyright: 
 *     This work is licensed under a CC BY.
 *     http://creativecommons.org/licenses/by/3.0/
*/
import std.stdio;
import std.string;
import std.array : replace;
import std.md5;
import core.thread; // sleep

import dhttpclient;
import dhtmlparser;



const string LOL_PWD = "full";
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
	foreach(octet; password.split("\\")){
		if (octet == "-")
			foreach(c; LOL_PWD)
				real_password ~= c;
		else if (octet != ""){
			real_password ~= std.conv.parse!ubyte(octet, 8);
		}
	}
	password = getDigestString(real_password).toLower;
	
	url = url[0 .. url.indexOf("?")];
	cl.post(url, ["username":"full", "password":password, "dst":"", "popup":"true"]);
}


/// just visits logout page (ip.ip.ip.ip/logout)
void logout(string url){
	url = url[0 .. url.indexOf("?")].replace("login", "logout");
	cl.get(url);
}



int main(string[] args){
	cl = new HTTPClient();
	string s = cl.get("http://seznam.cz");
		
	if (! (s.indexOf(`xml/WISPAccessGatewayParam.xsd`) > 0 && s.indexOf(`login?dst=http%3A%2F%2Fseznam.cz%2F`) > 0)){
		writeln("You are connected, waiting 30m2s to disconnect.");
		Thread.sleep(dur!("seconds")((30 * 60) + 2));
	}
	
	string url = getRedirectUrl(s);
	
	try{
		while(1){
			login(url);
			writeln("Logged in, waiting 25m to reconect.");
			
			Thread.sleep(dur!("seconds")(25 * 60));
			
			logout(url);
			writeln("Logged out.");
		}
	}catch(Exception e){
		logout(url);
		writeln("Logged out.");
	}
	
	return 0;
}