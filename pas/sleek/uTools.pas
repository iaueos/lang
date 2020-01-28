unit uTools;

(*
Unit to manipulate, extract, trim text specified
Please read README.TXT for more information about functions included here.
*)

interface

uses StrUtils, SysUtils, Classes, Math;

const
	LB = #13#10;
	BLANK = #09#32;
	doTRIM = 0;
	doLEFT_TRIM = 1;
	doRIGHT_TRIM = 2;
	doLINER = 3;
	doSTRIP_TAG = 4;
	doSTRIP_LINE = 5;
	doSTRIP_BETWEEN_DELIMITER = 6;
	doGET_BETWEEN_WITH_DELIMITER = 7;
	doGET_BETWEEN_DELIMITER = 8;
	doCITES = 9;
	doInTagReplace = 10;
	DIR_DELI = '\';
	geTAG0 = '[/';
	geTAG1 = '/]';
	geWILD = geTAG0 + '*' + geTAG1;
	geEMPTY = geTAG0 + '_' + geTAG1;

function lxiv(i : integer) : string;
function GetTemporary(path : string; j : integer = 0; prefix : string = '~'; extension : string = '') : string;function GetNameOnly(s : string) : string;
function FileNameOnly(s : string) : string;
function Refine(var sI : string; var myParam : TStrings; bSep, bIn, bOut : boolean) : string;
function Gather(var sI : string; var myParam : TStrings; bSep, bIn, bOut : boolean) : string;
procedure DoIt(todo : integer; var lines, InputFile : string; var myParam : tStrings);
function FindSharp(ori : string) : string;
function FindBak(ori : string) : string;
function LoadFromFile(fileName : string) : string;
function SaveToFile(FileName : string; var s : string) : boolean;
function PosRev(sub, s : string) : integer;
function GetEscape(s : string) : string;
function StrIpos(needle, haystack : string; start : integer;var lenfound : integer) : integer;
function Boyer(const pat, text: string; offset : Cardinal =1): integer;
function BoyerMoore(const pat, text : string; offset : Cardinal = 1 ) : integer;

implementation

{Boyer-Moore-Horspool text searching}
function Boyer(const pat, text: string; offset : Cardinal =1): integer;
 var i, j, k, m, n, o: integer;
	 skip: array[0..255] of integer;
	 found: boolean;
 begin
   // MarkPos(offset, length(pat), false, IntToStr(offset));
   // Writeln('1234567890123456789012345678901234567890123456789012345678901234567890');
   // Writeln(text);
   found := FALSE;
   m := length(pat);
   n := length(text);            {*** Search ***}
   o := offset;
   Result := 0;	   
	if (m < 1) or (o > (n - m + 1)) then
	begin
		exit;
	end;
	if o < 1 then o := 1;
	
	if m < 3 then begin Result := PosEx(pat, text, o); exit; end;

   {*** Preprocessing ***}
   for k:=0 to 255 do
		skip[k] := m;
   for k:=1 to m-1 do
		skip[ord(pat[k])] := m-k;

   k := m+o-1;

   while not found and (k <= n) do
	begin
		i := k; j := m;

		//MarkPos(i-m+1, m, true, IntToStr(i));
		while (j > 0) do
			 if text[i] <> pat[j] then
				break
			 else 
				begin
					Dec(j);
					Dec(i);
				end;	
		//MarkDot(i+1, m-j);

		if j = 0 then
		begin
			 Result := i+1;
			 found := TRUE;
		end;
		k := k + skip[ord(text[k])];
	end;
 end;

function BoyerMoore(const pat, text : string; offset : Cardinal = 1 ) : integer;
var pre : array[0..255] of integer;
	suff, gs : array of integer;
	f,g, i, j, l, m, n, o : integer;
begin
	m := length(pat); n := length(text);
	o := offset;
	if (m < 1) or (o > (n - m + 1)) then
	begin
		Result := 0;
		exit;
	end;
	if o < 1 then o := 1;

	if m < 3 then // why bother searching short string using this complex function ?
	begin
		Result := PosEx(pat, text, offset);
		exit;
	end;
	// Preprocessing

		SetLength(suff, m);
		suff[m-1] := m;
		g := m-1;
		i := m-2;
		f := 0;
		while i >= 0 do
		begin
			if (i > g) and (suff[i + m - 1 - f] < (i - g)) then
				suff[i] := suff[i + m - 1 - f]
			else
				begin
					if (i < g) then
						g := i;
					f := i;
					while (g >= 0) and (pat[g+1] = pat [g+m-f]) do
						Dec(g);
					suff[i] := f - g;
				end;
			dec(i);
		end;

		SetLength(gs, m);
		for i := 0 to m-1 do
		begin
			gs[i] := m;
		end;
		j := 0;

	   i := m - 1;
	   while i >= -1 do
	   begin
		  if (i = -1) or (suff[i] = i + 1) then
			while j < m - 1 - i do
			begin
				if gs[j] = m then
					gs[j] := m - 1 - i;
				inc(j);
			end;
		  dec(i);
	   end;
	   for i := 0 to m - 2 do
		  gs[m - 1 - suff[i]] := m - 1 - i;

	for i := 0 to 255 do
		pre[i] := m;
	for i := 1 to m do
		pre[ord(pat[i])] := m-i;

	// Searching
	l := 0;
	j := o - 1;
	while (j <= n -m) do
	begin
		i := m - 1;
		while (i>=0) and (pat[i+1] = text[i+j+1]) do
			Dec(i);
		if (i < 0) then
		begin
			l := j + 1;
			Inc (j , gs[0]);
		end
		else
			begin
				Inc(j , Max(gs[i], pre[ord(text[i+j+1])]-m+1+i));
			end;

		if l > 0 then break;
	end;
	Result := l;
end;

function PosRev(sub, s : string) : integer;
var i,j : integer;
begin
	Result := 0;
	j := length(s);
	for i := j downto 1 do
	begin
		if Copy(s, i, 1) = sub then
			begin
				Result := i;
				break;
			end;
	end;
end;

function FindSharp(ori : string) : string;
var p, j : integer;
	s,s1, s2 : string;
begin
	p := PosRev('.', ori);
	if p > 0 then
		begin
			s1 := copy(ori, 1, p -1);
			s2 := copy(ori, p, length(ori) - p + 1);
		end
	else
		begin
			s1 := ori;
			s2 := '';
		end;
	j := 0;
	repeat
		Inc(j);
		s := s1 + '#' + InttoStr(j) + s2;
	until not FileExists(s) or (j > 100);
	result := s;
end;

function FindBak(ori : string) : string;
var s,s1 : string;
	j : integer;
begin
	s1 := copy( ori, 1, posRev('.', ori) -1) ;
	j := 0 	;
	repeat
		Inc(j);
		if j > 0 then
			begin
				s := s1 + '#' + InttoStr(j)
			end
		else
			s := s1;
		s := s + '.bak';
	until not FileExists(s) or (j > 100);
	result := s;
end;

function LoadFromFile(fileName : string) : string;
var f : TFileStream;
	b : Pchar;
	fs, i : LongInt;
	s : string;
begin
	try
		f := TFileStream.Create(fileName, fmOpenRead, fmShareDenyWrite);
	except
		Writeln('Error Opening ... ', fileName);
		result := '';
		exit;
	end;
	fs := f.Size;
	GetMem(b, fs);
	i := f.Read(b^, fs);
	f.Free;
	SetString(s, b, i);
	FreeMem(b);
	Result := s;
end;

function SaveToFile(FileName : string; var s : string) : boolean;
var f : TFileStream;
	b : Pchar;
begin
	try
		f := TFileStream.Create(fileName, fmCreate, fmShareDenyWrite);
	except
		Writeln('Error Saving ... ', fileName);
		Result := False;
		exit;
	end;
	b:= PChar(s);
	f.Write(b^, Length(s));
	
	f.Free;
	Result := true;
end;

function lxiv(i : integer) : string;
var s : string;
const ABC64 = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_@';
begin
s := '';
repeat
	s :=ABC64[(i and 63) + 1] + s; // add character on ABC64 to s based on i mod 64 
	i := i shr 6; // faster implementation of i := i div 64 
until i < 1;
Result := s;
end;

function GetTemporary(path : string; j : integer = 0; prefix : string = '~'; extension : string = '') : string;
var i : integer; fn : string;
	t : TTimeStamp;
begin
i := 0;
t := DateTimeToTimeStamp(Now);
repeat
		fn := path + prefix + lxiv(t.Date) + lxiv( t.Time + i + j ) + extension;
		Inc(i);
until not FileExists(fn) or (i > 100);
Result := fn;
end;

function GetTempIn(path : string) : string;
var i : integer; fn : string;
begin
i := 0;
repeat
	fn := '~'+lxiv(DateTimeToTimeStamp(Now).Time + i);
	i := i + 1;
until not FileExists(path + fn) or (i > 100);
Result := fn;
end;

function GetNameOnly(s : string) : string;
var i,j : integer;
	sret : string;
label ret;
begin
	sret := '';
	i := pos('"', s);
	if i < 1 then 
		goto ret;
	if (i+1) < length(s) then
		s := copy(s, i+1, length(s)-i)
	else
		goto ret;
	i := pos('"', s);
	j := pos('#', s);
	if (i+j) < 1 then 
		goto ret;
	if (j < i) and (j > 0) then i := j;
	if i < 2 then goto ret;
	s := copy(s, 1, i - 1);
	i := pos('/',s);
	while i > 0 do
	begin
		Insert(DIR_DELI, s, i);
		Delete(s, i+1, 1);
		i := pos('/',s);
	end;
	sret := s;
ret:
	GetNameOnly := sret;
end;

function FileNameOnly(s : string) : string;
var s1 : string; i,j : integer;
begin
	j := 0;
	s1 := s;
	for i := length(s1) downto 1 do
	begin
		if s1[i] = '.' then
			begin
				j := i;
				break;
			end;
	end;
	if j > 0  then
		s1 := copy(s1,1,j-1);
	FileNameOnly := s1;
end;

function GetEscape(s : string) : string;
const x : Array[0..7] of String = ( '\r', #13, '\n', #10, '$', #13#10, '\t', #9 ) ;
var j, k, l, m, n, o, p  : integer;
	middle, repl : string;
begin
	j := 0;
	while true do
	begin
		m := posEx(geTAG0, s, j);
		n := posEx(geTAG1, s, m);
		if (m > n) or (m = 0) then
			break;

		//j := n+1;
		middle := copy(s, m+2, n-m-2);
		repl := '';
		p := 0;
		while p < length(middle) do
		begin
			for k := 0 to 3 do
			begin
				l := k shl 1;
				o := posex(x[l], middle, p);
				if o > 0 then
					begin
						// Delete(middle, o, length(x[l]));
						repl := repl + x[l+1];
						// Insert(x[l + 1], middle, o);
						p := o + length(x[l]);
						break;
					end;
			end;
			if o < 1 then
				break;
		end;
		if length(repl) > 0 then
			begin
				Delete(s, m, length(middle) + 4);
				Insert(repl, s, m);
				j := m + length(repl);
			end
		else
			begin
				j := n + 2;
			end;
	end;
	Result := s;
end;

function Gather(var sI : string; var myParam : TStrings; bSep, bIn, bOut : boolean) : string;
var i, j, k, l, m, n, o, p, li, lj, i1, j1  : integer;
	s, s1 : string;
	t : array[1..5] of String;
	tsParam : TStringList;
begin
	tsParam := TStringList.Create;
	tsParam.Text := Uppercase(myParam.Text);

	k := myParam.Count;
	s := sI;
	if k < 1 then
		begin
			Gather := '';
			exit;
		end;
	sI := '';
	repeat
	l := length(s);
	s1 := UpperCase(s);  { case insensitive }

	{ find first occurance of anything}
	i := 0; j:= 1;
	o := l; p := 0; m:=0; n :=0; li := 0; lj :=0; i1 :=0; j1 :=0;

	while (j < k) do
	begin
		m := stripos(tsParam[ i ] , s1, 0, li);
		n := stripos(tsParam[ j ] , s1, m+li, lj);

		if (m > 0) and (n > m) and (m < o) then
			begin
				o := m; i1 := i;
				p := n; j1 := j;
			end;

		i := i + 2;
		j := i + 1;
	end;

	if (p > o) and (o > 0) then
		begin
			// m := o; li := length(myParam[i1]);
			// n := p; lj := length(myParam[j1]);
			m := stripos(tsParam[ i1 ] , s1, o, li);
			n := stripos(tsParam[ j1 ] , s1, p, lj);
		end;

	if (m > 0) and (n > 0) then
		begin {  between separator }
			t[1] := copy(s, 1, m-1);
			t[2] := copy(s, m, li);
			t[3] := copy(s, m+li, n - (m + li) );
			t[4] := copy(s, n, lj);
			s := copy(s, n+lj, l - (n + lj) + 1); { feedback reminder }

			if not bOut then { empty outside }
				t[1] := '';
			if not bIn then  { empty inside }
				t[3] := '';
		end
	else
		if m > 0 then
			begin { first separator found, second not }
				t[1] := copy(s, 1, m-1);
				t[2] := copy(s, m, li);
				t[3] := '';
				t[4] := '';
				s := copy(s, m+li, l - (m + li) + 1); { feedback remainder }
			end
		else
			begin { found nothin' }
				t[1] := s;
				t[2] := '';
				t[3] := '';
				t[4] := '';
				s := ''; { feedback remainder }
				if (not bOut) then t[1] := ''; { finally, nothing to see here }
			end;

		if not bSep then { empty Separator }
			begin
				t[2] := '';
				t[4] := '';
			end;

		{ Concatenate Results }
		sI := sI + t[1] + t[2] + t[3] + t[4];

	until ((n = 0) and (m = 0)) or (length(s) < 1);
	Gather := sI;

	tsParam.Free;
end;

function StrIpos(needle, haystack : string; start : integer;var lenfound : integer) : integer;
var ts : TStringList;
	i, k, l, m, n, o, p  : integer;
	tagSearch : String;

begin
	if posEx(geTAG0, needle, start) > 0 then
		begin
			needle := getEscape(needle);
		end;
	lenfound := length(needle);
	o := 1;
	p :=  PosEx(geWILD, needle, 0);
	if p > 0 then
		begin
			// split needle by geWILD
			// search string one by one until found
			ts := TStringList.Create;
			while p > 0 do
			begin
				ts.Add(copy(needle, o, p - o));
				o := p + length(geWILD);
				p :=  posEx(geWILD, needle, o);
				if p < 1 then // add last string
					begin
						n := length(needle);
						ts.Add(copy(needle, o, n - o + 1));
					end;
			end;
			tagSearch := '';
			if ts.Count >= 1 then
				begin
					if (pos('<', ts[0]) = 1) then
						begin
							k := pos(' ', ts[0]);
							if k > 0 then tagSearch := copy(ts[0], 2, k-2) else tagSearch := copy(ts[0], 2, length(ts[0])-1);
						end;
				end;
			p := start; m := 0;
			if ts.Count < 1 then
				p := 0;
			l := length(tagSearch);

			repeat
				for i := 0 to ts.Count - 1 do
				begin

					p := Boyer(ts[i], haystack, p);

					if i = 0 then
						m := p;
					if p < 1 then
						break;
				end;


			// do some extra filteri'n until its found last occurance of it
				if (m > 0) and (l > 0) and (p > 0) then
					begin
						k := Boyer( '<' + tagSearch, haystack, m + l + 1) ;

						// writeln('1 real = ', k, ' bmh = ' , tmp);
						if (k > m) and (k < p) then
							begin
								p := k; // restart search
								m := 0;
								continue;
							end;
					end;
				break;
			until false;
			if p > 0 then
				begin
					lenfound := (p+length(ts[ts.Count-1]))-m ;
					Result := m;
				end
			else
				begin
					lenfound := 0;
					Result := 0;
				end;
			ts.Free;
		end
	else
		begin
			Result := Boyer(needle, haystack, start);
		end;
end;

function Refine(var sI : string; var myParam : TStrings; bSep, bIn, bOut : boolean) : string;
var i, j, k, l, m, n, li, lj, tp, tagStart, tagEnd, tagLen: integer;
	s, s1, tagSearch : string;
	t : array[1..5] of String;
	tsParam : TStrings;
begin
	tsParam := TStringList.Create;
	tsParam.Text := UpperCase(myParam.Text);
	k := tsParam.Count;
	if k > 1 then
		begin
			i:=0;
			while i < k do      {  walk through all parameters }
			begin
				s := sI;  { s is gonna be filtered }
				sI := ''; { output string gonna be put here }
				j := i + 1;

				li := length(tsParam[i]);
				lj := length(tsParam[j]);

				if (pos('<', tsParam[i]) = 1) then
					begin
						tp := pos(' ', tsParam[ i ]);
						if tp > 0 then tagSearch := copy(tsParam[i], 2, tp-2) else tagSearch := copy(tsParam[i], 2, length(tsParam[i])-1);
					end
				else
					tagSearch := '';

				repeat           { parsing until separator in myParam not found }
					l := length(s);
					s1 := UpperCase(s);  { case insensitive }

						// m := pos(UpperCase( getEscape(tsParam[ i ]) ), s1);
					// n := posEx(UpperCase( tsParam[ j ] ), s1, m+li);

						m := stripos(tsParam[ i ] , s1, 0, li);
					n := stripos(tsParam[ j ] , s1, m+li, lj);

					// find if there's another same tag between opening and closing
					if (n > 0) and (m > 0) and  (length(tagSearch)> 0) then
					begin
						tagLen := length(tagSearch);
						tagStart := m + tagLen + 1;
						tagEnd := n;
						repeat
							tp := Boyer( '<' + tagSearch, s1, tagStart);
							if tp < 1 then break else tagStart := tp + tagLen + 1;

							if tp > tagEnd then break;
							tp := Boyer( '/' + tagSearch + '>', s1, tagEnd + tagLen + 2);

							if tp > 0 then tagEnd := tp;

						until tp < 1;
						n := tagEnd;

					end;
					if ((n > 0) and (m > 0)) then
						begin {  between separator }
							t[1] := copy(s, 1, m-1);
							t[2] := copy(s, m, li);
							t[3] := copy(s, m+li, n - (m + li) );
							t[4] := copy(s, n, lj);
							s := copy(s, n+lj, l - (n + lj) + 1); { feedback reminder }

							if not bOut then { empty outside }
								t[1] := '';
							if not bIn then  { empty inside }
								t[3] := '';

						end
					else
						if m > 0 then
							begin { first separator found, second not }
								t[1] := copy(s, 1, m-1);
								t[2] := copy(s, m, li);
								t[3] := '';
								t[4] := '';
								s := copy(s, m+li, l - (m + li) + 1); { feedback remainder }
							end
						else
							begin { found nothin' }
								t[1] := s;
								t[2] := '';
								t[3] := '';
								t[4] := '';
								s := ''; { feedback remainder }
								if (not bOut) and (j >= k - 1) then t[1] := ''; { finally, nothing to see here }
							end;

						if not bSep then { empty Separator }
							begin
								t[2] := '';
								t[4] := '';
							end;
						{ Concatenate Results }
						sI := sI + t[1] + t[2] + t[3] + t[4];
				until ((m = 0) and (n = 0)) or (length(s)<1); { found nothin' or nothin' to find anymore }
				i := i + 2;
			end;
		
		end;
	tsParam.Free;
	Refine := sI;
end;

procedure DoIt(todo : integer; var lines, InputFile : string; var myParam : tStrings);
var i, j, k, l, m, n : integer;
	s,s1,s2,t,u, LB : string;
	f : boolean;
	ts : TStrings;
const
	aRep : array[1..8] of string = ( ' ', '20', '''', '27', '(', '28', ')', '29' );
begin
	ts := TStringList.Create;
	k := myParam.Count;
	ts.Text := lines;
	s := lines;
	case todo of
	doTRIM :
		begin
			for i := 0 to ts.Count -1 do
				ts[i] := trim(ts[i]);
			lines := ts.Text;
		end;
	doLEFT_TRIM :
		begin
			for i := 0 to ts.Count -1 do
				ts[i] := trimleft(ts[i]);
			lines := ts.Text;
		end;
	doRIGHT_TRIM :
		begin
			for i := 0 to ts.Count -1 do
				ts[i] := trimright(ts[i]);
			lines := ts.Text;
		end;
	doLINER :
		begin
			s1 := ''; s2 := '';
			for i := 0 to ts.Count -1 do
			begin
				s := trim(ts[i]);
				if length(s1) < 1 then
					begin
						if i > 0 then s2 := s2 + LB;
						s2 := s2 + s;
					end
				else
					begin
						s2 := s2 + ' ' + s;
					end;
				s1 := s;
			end;
			lines := s2;
		end;
	doSTRIP_TAG :
		begin
			s := lines;
			s2 := '';
			i := 0;
			j := length(s);
			while i < j do
			begin
				m := posEx('<', s, i);
				if m < 1 then break;
				if m >= i then
				begin
					n := posEx('>', s, m);
					if n > 0 then
					begin
						m := posEx('<', s, n);
						if m < 1 then
						begin
							s2 := s2 + copy(s, n + 1, j -n );
							i := j;
						end
						else
						begin
							s2 := s2 + copy(s, n + 1, m - n - 1);
							i := m;
						end;
					end
					else
					begin
						i := j;
					end;
				end;
			end;
			lines := s2;
		end;
	doSTRIP_LINE :
		if k > 0 then
		begin
			i := 0;
			while i < ts.Count do
			begin
				f := false;
				for j := 0 to k -1 do
				begin
				if pos(uppercase(myParam[j]), uppercase(ts[i])) = 1 then
				begin
					ts.Delete(i);
					f := true;
					break;
				end;
				end;
				if f then continue;
				Inc(i);
			end;
			lines := ts.Text;
		end;
	doSTRIP_BETWEEN_DELIMITER :
		if k > 0 then
		begin
			lines := Refine(lines, myParam, false, false, true);
		end;
	doGET_BETWEEN_WITH_DELIMITER :
		if k > 0 then
		begin
			lines := Gather(lines, myParam, true, true, false);
		end;
	doGET_BETWEEN_DELIMITER :
		if k > 0 then
		begin
			lines := Gather(lines, myParam, false, true, false);
		end;
	doCITES :
	if k > 0 then
	begin
		u := ExtractFileName(InputFile);
		i := PosRev('.', u);
		if i > 0 then u := copy(u, 1, i-1);
		for i:= 1 to 4 do
		begin
			u := StringReplace(u, aRep[2*i - 1], '%' + aRep[2*i], [rfReplaceAll, rfIgnoreCase]);
		end;
		u := u + '_files';
		t := '';

		s := lines;
		s2 := '';
		i := 1;
		j := length(s);
		while i < j do
		begin
			m := posEx('<', s, i);
			if m < 1 then
			begin // out tag, copy remaining text
				s2 := s2 + copy(s, i, j);
				break;
			end
			else  // intag
			begin
				if m > i then // take what's left on it
				begin
					s2 := s2 + copy(s, i, m - i);
				end;
				if m >= i then
				begin
					n := posEx('>', s, m);
					s1 := '';
					if n > 0 then
					begin
						s1 := copy(s, m, n - m + 1);
						i := n + 1;
					end
					else
					begin
						s1 := copy(s, m, j -m + 1);
						i := j;
					end;
					s1 := StringReplace(s1, u, myParam[0], [rfReplaceAll, rfIgnoreCase]);
					s2 := s2 + s1;
				end;
			end;
		end;
		lines := s2;
	end;
	doInTagReplace:
	if k > 1 then
	begin
		s := lines;
		s2 := '';
		i := 1;
		j := length(s);
		while i < j do
		begin
			m := posEx('<', s, i);
			if m < 1 then
			begin // out tag, copy remaining text
				s2 := s2 + copy(s, i, j);
				break;
			end
			else  // intag
			begin
				if m > i then // take what's left on it
				begin
					s2 := s2 + copy(s, i, m - i);
				end;
				if m >= i then
				begin
					n := posEx('>', s, m);
					s1 := '';
					if n > 0 then
					begin
						s1 := copy(s, m, n - m + 1);
						i := n + 1;
					end
					else
					begin
						s1 := copy(s, m, j -m + 1);
						i := j;
					end;
					for l := 0 to (k div 2)-1 do
					begin
						if pos(myParam[l*2], s) > 0 then
						begin
							s1 := StringReplace(s1, myParam[l*2], myParam[l*2+1], [rfReplaceAll, rfIgnoreCase]);
						end;
					end;
					s2 := s2 + s1;
				end;
			end;
		end;
		lines := s2;
	end;
	end;
end;

end.
