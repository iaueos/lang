program TextFit;
Uses Crt, dos;

var useout, doing, paramsc : integer;
    paramfile, outdir, inputfile : string;
    params : array[1..64] of string;

const
    LB = #13#10;
    BLANK = #09#32;
    MAX_PRM = 64;
    doTRIM = 0;
    doLEFT_TRIM = 1;
    doRIGHT_TRIM = 2;
    doLINER = 3;
    doSTRIP_TAG = 4;
    doSTRIP_LINE = 5;
    doSTRIP_BETWEEN_DELIMITER = 6;
    doGET_BETWEEN_WITH_DELIMITER = 7;
    doGET_BETWEEN_DELIMITER = 8;
    doLINKED_AHREF = 9;
    doBROKEN_AHREF = 10;
    DIR_DELI = '\';
    ACTION_LIST = 'T..LT.RT.L..ST.SL.SB.GB.GO.HL.BL.';

function GetNameOnly(s : string) : string;
var i,j : integer;
    sret : string;
label ret;
begin
    sret := '';
    i := pos('"', s);
    if i < 1 then goto ret;
    if (i+1) < length(s) then
        s := copy(s, i+1, length(s)-i)
    else
        goto ret;
    i := pos('"', s);
    j := pos('#', s);
    if (i+j) < 1 then goto ret;
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

function FileExists(FileName: string): Boolean;
var Sr : SearchRec;
begin
    if FileName[length(FileName)] = DIR_DELI then
        FileName := copy(FileName,1,length(FileName) -1);
    FindFirst(FileName, $3F, Sr);
    if DosError = 0 then
        FileExists := true
    else
        FileExists := false;
end;

function ExtractFilePath(s : string):string;
var i,j : integer;
begin
    j := 0;
    for i := length(s) downto 1 do
        if (s[i] = DIR_DELI) then
        begin
            j := i;
            break;
        end;
    if j >= 1 then
       ExtractFilePath := copy(s,1,j)
    else
       ExtractFilePath := '';
end;

function ExtractFileName(s : string):string;
var i,j : integer;
begin
    j := length(s);
    for i := length(s) downto 1 do
        if (s[i] = DIR_DELI) then
        begin
            j := i + 1;
            break;
        end;
    if j > length(s) then
        ExtractFileName := ''
    else begin
            if j < length(s) then
                ExtractFileName := copy(s, j, length(s)-j+1)
            else
                ExtractFileName := s;
         end;
end;

function FileNameOnly(s : string) : string;
var s1 : string; i,j : integer;
begin
    s1 := s;
    for i := length(s1) downto 1 do
    begin
        if s1[i] = '.' then
        begin
           j := i;
           break;
        end;
    end;
    if j > 0  then s1 := copy(s1,1,j-1);
    FileNameOnly := s1;
end;

function trimleft(s : string):string;
var i,j : integer;
begin
    j := length(s);
    for i := 1 to j do
        if pos(s[i], BLANK) = 0 then
        begin
            j := i;
            break;
        end;
    trimleft := copy(s, j, length(s)-j+1);
end;

function trimright(s : string):string;
var i,j : integer;
begin
    j := length(s);
    for i := j downto 1 do
        if pos(s[i], BLANK) = 0 then
        begin
            j := i;
            break;
        end;
    trimright := copy(s, 1, j);
end;

function trim(s : string):string;
begin
     trim := trimright(trimleft(s));
end;

function uppercase(s : string):string;
var i : integer;
begin
    for i := 1 to length(s) do
        s[i] := Upcase(s[i]);
    uppercase := s;
end;

procedure DoProcess(file_1, file_2 : string);
var i, j, k, l, m, n : integer;
    f1, f2 : text;
    f1name,s,s1,s2 : string;
    feedback : boolean;
begin
    k := paramsc;
    f1name := ExtractFilePath(file_1);
    assign(f1,file_1);
    assign(f2,file_2);
    {$I-} reset(f1); {$I+}
    if ioresult <> 0 then exit;
    {$I-} rewrite(f2); {$I+}
    if ioresult <> 0 then exit;
    case doing of
    doTRIM :
        while not eof(f1) do
        begin
            readln(f1,s);
            s := trim(s);
            writeln(f2,s);
        end;
    doLEFT_TRIM :
        while not eof(f1) do
        begin
            readln(f1,s);
            s := trimleft(s);
            writeln(f2,s);
        end;
    doRIGHT_TRIM :
        while not eof(f1) do
        begin
            readln(f1,s);
            s := TrimRight(s);
            writeln(f2,s);
        end;
    doLINER :
        begin
            s1 := ''; i := 0;
            while not eof(f1) do
            begin
                readln(f1,s);
                s := trim(s);
                if length(s1) < 1 then
                    begin
                        if i > 0 then writeln(f2,'');
                        write(f2,s);
                    end
                else
                    begin
                        write(f2, ' ');
                        write(f2, s);
                    end;
                { if length(s) < 1 then writeln(f2,LB); }
                s1 := s;
                inc(i);
            end;
            writeln(f2,s1);
        end;
    doSTRIP_TAG :
        begin
            l := 0; s1 := '';
            while not eof(f1) do
            begin
                readln(f1,s);
                repeat
                    feedback := false;
                    if l < 1 then
                    begin
                        m := pos('<', s);
                        if m > 0 then
                        begin
                            n := m - 1;
                            if n > 0 then
                            begin
                                s1:=s;
                                s := copy(s, 1, n);
                                write(f2,s);
                                if n < length(s1) then
                                    s := copy(s1, n+1, length(s1)-n)
                                else
                                    s := '';
                                s1 := '';
                            end;
                            l := 1;
                        end;
                    end; { if }
                    if l > 0 then
                    begin
                        m := pos('>', s);
                        if m > 0 then
                        begin
                            n := m + 1;
                            l := 0;
                            if n < length(s) then
                                begin
                                    s1 := copy(s, n, length(s)-n+1);
                                    s := s1;
                                    feedback := true;
                                end
                            else
                                s := '';
                        end
                        else s := '';
                    end; { if l > 0 }
                until not feedback;
                writeln(f2,s);
            end; { while }
        end;
    doSTRIP_LINE :
        if k > 0 then
        begin
            s2 := params[1];
            s1 := '';
            while not eof(f1) do
            begin
                readln(f1,s);
                if pos(uppercase(s2), uppercase(s)) = 1 then
                    continue;
                writeln(f2,s);
            end;
        end;
    doSTRIP_BETWEEN_DELIMITER :
        if k > 1 then
        begin
            l := 0; s1 := ''; s2 := '';
            while not eof(f1) do
            begin
                readln(f1,s);
                repeat
                    if l < 1 then
                    begin
                        for j := 1 to (k div 2) do
                        begin
                            m := pos(UpperCase(params[(j * 2) - 1]), UpperCase(s));
                            if m > 0 then
                            begin
                                n := m - 1;
                                if n > 0 then
                                begin
                                    s1:=s;
                                    s := copy(s, 1, n);
                                    write(f2,s);
                                    n := m + length(UpperCase(params[(j * 2) - 1]));
                                    if n < length(s1) then
                                        s := copy(s1, n, length(s1)-n+1)
                                    else
                                        s := '';
                                    s1 := '';
                                end;
                                l := j * 2;
                                break;
                            end;
                        end; { for }
                        if l < 1 then
                        begin
                            write(f2,s);
                            s := '';
                        end;
                    end; { if l < 1 }
                    if l > 0 then
                    begin
                        m := pos(uppercase(params[l]), UpperCase(s));
                        if m > 0 then
                        begin
                            n := m + length(params[l]);
                            l := 0;
                            if n < length(s) then
                                begin
                                    s := copy(s, n, length(s)-n+1);
                                    continue;
                                end
                            else
                                begin
                                    s := '';
                                end;
                        end
                        else s := '';
                    end; { if l > 0 }
                    break;
                until false;

                writeln(f2,'');
            end; { while }
        end; { if }
    doGET_BETWEEN_DELIMITER :
        if k > 1 then
        begin
            l := 0; s1 := ''; s2 := '';
            while not eof(f1) do
            begin
                if length(s1) < 1 then
                    readln(f1,s)
                else
                    begin
                        s := s1;
                        s1 := '';
                    end;
                if l < 1 then
                begin
                    for j := 1 to (k div 2) do
                    begin
                        m := pos(UpperCase(params[(j * 2) - 1]), UpperCase(s));
                        if m > 0 then
                            begin
                                n := m+length(params[(j*2)-1]);
                                s := copy(s, n, length(s) - n + 1);
                                l := (j * 2);
                                break;
                            end
                    end; { for }
                    if l < 1 then
                    begin
                        s1 := '';
                        writeln(f2,'');
                        continue;
                    end;
                end; { if l < 1 }
                if l > 0 then
                begin
                    m := pos(uppercase(params[l]), UpperCase(s));
                    if m > 0 then
                    begin
                        n := m - 1;
                        s1 := s;
                        s := copy(s, 1, n);
                        if length(s1) > (m + length(params[l])) then
                            begin
                                write(f2,s);
                                s1 := copy(s1, n+length(params[l]), length(s1)-n-length(params[l])+1);
                            end
                        else
                            begin
                                s1 := '';
                                writeln(f2,s);
                            end;
                        l := 0;
                    end
                    else
                    begin
                        s1 := '';
                        writeln(f2,s);
                    end;
                end; { if l > 0 }
            end; { while }
        end; { if }
    doGET_BETWEEN_WITH_DELIMITER :
        if k > 1 then
        begin
            l := 0; s1 := ''; s2 := '';
            while not eof(f1) do
            begin
                if length(s1) < 1 then
                    readln(f1,s)
                else
                    begin
                        s := s1;
                        s1 := '';
                    end;
                if l < 1 then
                begin
                    for j := 1 to (k div 2) do
                    begin
                        m := pos(UpperCase(params[(j * 2) - 1]), UpperCase(s));
                        n := m + length(params[(j * 2) - 1]);
                        if m > 0 then
                            begin
                                write(f2, copy(s,m,n-m));
                                s := copy(s, n , length(s) - n + 1);
                                l := (j * 2);
                                break;
                            end
                    end; { for }
                    if l < 1 then
                    begin
                        s1 := '';
                        writeln(f2,'');
                        continue;
                    end;
                end; { if l < 1 }
                if l > 0 then
                begin
                    m := pos(uppercase(params[l]), UpperCase(s));
                    if m > 0 then
                    begin
                        n := m + length(params[l]) - 1;
                        s1 := s;
                        { s := copy(s, 1, n); }
                        s := copy(s, 1, n);
                        if length(s1) >= n then
                            begin
                                write(f2,s);
                                { s1 := copy(s1, n+length(params[l]), length(s1)-n-length(params[l])+1); }
                                s1 := copy(s1, n + 1 , length(s1)-n);
                            end
                        else
                            begin
                                s1 := '';
                                writeln(f2,s);
                            end;
                        l := 0;
                    end
                    else
                    begin
                        s1 := '';
                        writeln(f2,s);
                    end;
                end; { if l > 0 }
            end; { while }
        end; { if }
    doLINKED_AHREF, doBROKEN_AHREF :
        begin
            l := 0; s1 := ''; s2 := '';
            while not eof(f1) do
            begin
                if length(s1) < 1 then
                    readln(f1,s)
                else
                    begin
                        s := s1;
                        s1 := '';
                    end;
                if l < 1 then
                begin
                    m := pos('<A HREF=', UpperCase(s));
                    if m > 0 then
                    begin
                        s := copy(s, m, length(s) - m + 1);
                        if pos('/A>', UpperCase(s)) < 1 then
                            s2 := s2 + trim(s);
                        l := 1;
                    end
                end;
                if l < 1 then continue;
                if l > 0 then
                begin
                    m := pos('/A>', UpperCase(s));
                    if m > 0 then { string extracted process }
                    begin
                        n := m + 2;
                        s1 := s;
                        s := copy(s, 1, n);
                        l := 0;
                        s2 := s2 + trim(s);
                        { process ref }
                        if FileExists(f1name + GetNameOnly(s2)) then
                            begin
                                if (doing=doLINKED_AHREF) then writeln(f2,s2);
                            end
                        else
                            begin
                                if (doing=doBROKEN_AHREF) then writeln(f2,s2);
                            end;
                        { process ref }
                        s2 := '';
                        if length(s1) > (n + 1) then
                            begin
                                s1 := copy(s1, n, length(s1)-n+1);
                                continue;
                            end
                        else
                            s1 := '';
                    end;
                end;
            end;
        end;
    end;
    close(f1);
    close(f2);
end;

function WhereToSave(s : string) : string;
begin
    if useout = 0 then
        { WhereToSave := FileNameOnly(s) + '.out' }
        WhereToSave := ''
    else
        WhereToSave := outdir + ExtractFileName(s);
end;

var i:integer;
    f1name, f2name : string;
    fl, pf : text;

procedure Help(pesan : string);
begin
    if length(pesan) > 0 then Writeln(pesan+LB);
    writeln(
'TF (tm) 1.00 Copyright (c) 2000-2099 DAN Software, Inc. Aug 26,2000' + LB +
LB +
'Usage:     tf32 <action> [parameter_file] [<-option>] <filename | @filelist>' + LB +
'Examples:  tf32 st file, tf32 sb ahref file, tf32 go this -o c:\ file' + LB +
LB +
'<action>' + LB +
'  t: Trim spaces                       sl: Strip Line' + LB +
' lt: Left Trim                         sb: Strip Between delimiters' + LB +
' rt: Right Trim                        gb: Get Between including delimiters' + LB +
'  l: Join Lines                        go: Get between delimiters Only' + LB +
' st: Strip all beTween "<" and ">"     hl: find linked local HyperLink' +LB +
'                                       bl: find Broken local hyperLink' + LB +
LB +
'parameter_file required for action : sl, sb, gb, go' + LB +
LB +
'<option>' + LB +
'  o: set output directory default is to stdout' + LB +
'     eq : -o c:\ means write output to c:\' + LB +
'     do not set output directory same as input files location' + LB);
    Halt(0);
end;

var
    param, s : string;

begin
    paramfile := '';
    outdir := '';
    useout := 0;

    { decode parameters }

    if ParamCount < 2 then Help('Not enough parameters');

    { - determine what action to perform }

    param := uppercase(copy(trim(Paramstr(1))+'..',1,3));
    doing := pos(param, ACTION_LIST);
    if doing < 1 then
        doing := -1
    else
        doing := (doing - 1) div 3;
    if doing < 0 then Help('Not a valid action');

    if doing in [doSTRIP_LINE, doSTRIP_BETWEEN_DELIMITER,
                 doGET_BETWEEN_WITH_DELIMITER, doGET_BETWEEN_DELIMITER] then
        begin
            paramfile := ParamStr(2);
            i := 3;
        end;
    while i < Paramcount do
    begin
        param := paramstr(i);
        if param[1] = '-' then
        begin
            case UpCase(param[2]) of
            'O' : begin
                     useout := 1;
                     outdir := Paramstr(i+1);
		     inc(i,2);	
                  end;
            else Help('');
            end;
        end
        else
            break;
    end;

    if i > ParamCount then Help('');

    { determine input(s) }

    param := ParamStr(ParamCount);
    inputfile := param;

    if ((doing = doSTRIP_LINE) or
       (doing = doSTRIP_BETWEEN_DELIMITER) or
       (doing = doGET_BETWEEN_WITH_DELIMITER) or
       (doing = doGET_BETWEEN_DELIMITER)) and (length(paramfile)<1) then
       Help('Action sl, sb, gb, go need parameter');

    if (useout > 0) and (not FileExists(outdir)) then
       Help('Output directory not exists');

    if length(outdir) > 0 then s := outdir[length(outdir)] else s := '';
    if (s <> DIR_DELI) then outdir := outdir + DIR_DELI;

    if inputfile[1] = '@' then
    begin
        s := copy(inputfile,2,length(inputfile)-1);
        if not FileExists(s) then Help('File : ' + s + ' not found');
    end;

    { open parameter file if defined }
    if Length(ParamFile) > 0 then
    begin
        if not FileExists(paramfile) then Help('Parameter file not found');
        assign(pf, paramfile);
        reset(pf);
        i := 0;
        while not eof(pf) and (i < MAX_PRM) do
        begin
            readln(pf, s);
            s := trim(s);
            if length(s) > 0 then
            begin
                inc(i);
                params[i]:=s;
            end;
        end;
        close(pf);
        paramsc := i;
    end;

    { processing }

    if inputfile[1] = '@' then
    begin
        inputfile := copy(inputfile,2,length(inputfile)-1);
        assign(fl,inputfile);
        reset(fl);
        while not eof(fl) do
        begin
            readln(fl, s);
            s := trim(s);
            if not FileExists(s) then begin Writeln(LB+'!!! ' + s + ' not found !!!'+LB); continue; end;
            f1name := s;
            f2name := WhereToSave(f1name);
            DoProcess(f1name,f2name)
        end;
        close(fl);
    end
    else
    begin
        f1name := inputfile;
        if not FileExists(f1name) then begin Writeln(LB+'!!! ' + f1name + ' not found !!!'+LB); Halt(0); end;
        f2name := WhereToSave(f1name);
        DoProcess(f1name,f2name)
    end;
end.
