/**
 * 
 * 
 * Author:  Bystroushaak (bystrousak@kitakitsune.org)
 * Version: 0.0.1
 * Date:    
 * 
 * Copyright: 
 *     This work is licensed under a CC BY.
 *     http://creativecommons.org/licenses/by/3.0/
*/
import std.stdio;
import std.string;

import dhttpclient;
import dhtmlparser;

string getRedirectUrl(string s){
	auto dom = parseString(s);
	auto url = dom.find("meta")[0].params["content"];
	if (url.indexOf("=") > 0)
		url = url[url.indexOf("=") + 1 .. $];
	
	return url;
}

int main(string[] args){
	HTTPClient c = new HTTPClient();
	string s = c.get("http://seznam.cz");
	
	if (! (s.indexOf(`xml/WISPAccessGatewayParam.xsd`) > 0 && s.indexOf(`login?dst=http%3A%2F%2Fseznam.cz%2F`) > 0)){
		stderr.writeln("You are connected!");
		return 1;
	}
	
	string url = getRedirectUrl(s);
	
	return 0;
}