// Written by meatatt.
// Thanks to Jimmy Chen for bug fixing.

module exCode;

import database;

import std.array: appender;
import std.ascii: isASCII;

@safe:

version(NO_FILTER)
	enum UseCodecFilter=false;
else
	enum UseCodecFilter=true;

private union UNIT{
	wchar uni;
	char[2] gbk;
	struct{
		char gbkH;
		char gbkT;
	}
}

// Convert string from Unicode To GBK wstring
string UNI2GBK(in wchar[] source){
	auto res=appender!string;
	UNIT unit;
	foreach(ref wc;source){
		static if (UseCodecFilter) if (isASCII(wc)){
			res.put(wc);
			continue;
		}
		if (wc>0x00A3&&wc<0xFFE6){
			unit.uni=uni_gbk[wc-0x00A4];
			if (unit.uni!=0){
				res.put(unit.gbk.idup);
				continue;
			}
		}
		static if (UseCodecFilter) res.put(U2G_E);
		else res.put(wc);
	}
	return res.data;
}

// Convert wstring from GBK To Unicode string
wstring GBK2UNI(in char[] source){
	auto res=appender!wstring;
	UNIT unit;
	for (uint i=1;i<source.length;++i){
		unit.gbk=source[i-1..i+1];
		static if (UseCodecFilter) if  (isASCII(unit.gbkH)){
			res.put(unit.gbkH);
			continue;
		}
		if (unit.uni>0x4080&&unit.uni<0xFEF8)
			if (wchar wc=gbk_uni[unit.uni-0x4081]){
				res.put(wc);
				unit.gbkT=0;
				++i;
				continue;
			}
		static if (UseCodecFilter) res.put(G2U_E);
		else res.put(unit.gbk.idup);
	}
	if(unit.gbkT!=0) res.put(unit.gbkT);
	return res.data;
}

enum char U2G_E='?';
enum wchar G2U_E='�';
