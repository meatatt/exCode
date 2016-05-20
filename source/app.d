module app;

import std.stdio;
import exCode;

void main(){
	enum ustr="你好，中国！";
	version (Windows)
		writeln(UNI2GBK(ustr));
	version (linux)
		writeln(GBK2UNI(UNI2GBK(ustr)));
}