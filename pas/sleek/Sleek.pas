program Sleek;
{$APPTYPE CONSOLE}
{$DEBUGINFO ON}
{$RANGECHECKS ON}
{$IOCHECKS ON}
{$HINTS ON}
{$DESCRIPTION 'Sleek : Text filtering'}
{$DEFINE _TESTING}

Uses SysUtils, Classes, uTools, Contnrs, DateUtils;

function getLocaleSetting : TFormatSettings;
var t : TFormatSettings;
begin
    t.CurrencyFormat := CurrencyFormat;
    t.NegCurrFormat := NegCurrFormat;
    t.ThousandSeparator := ThousandSeparator;
    t.DecimalSeparator := DecimalSeparator;
    t.CurrencyDecimals := CurrencyDecimals;
    t.DateSeparator := '/';
    t.TimeSeparator := TimeSeparator;
    t.ListSeparator := ListSeparator;
    t.CurrencyString := CurrencyString;
    t.ShortDateFormat := 'dd-mm-yyyy';
    t.LongDateFormat := LongDateFormat;
    t.TimeAMString := TimeAMString;
    t.TimePMString := TimePMString;
    t.ShortTimeFormat := 'hh:nn';
    t.LongTimeFormat := 'hh:nn:ss';
    {t.ShortMonthNames := ShortMonthNames;
    t.LongMonthNames := LongMonthNames;
    t.ShortDayNames := ShortDayNames;
    t.LongDayNames := LongDayNames;}
    t.TwoDigitYearCenturyWindow := TwoDigitYearCenturyWindow;
    result := t;
end;

procedure Ending(s : string);
begin
    Writeln(s);
    Halt(0);
end;

procedure Help;
begin
    writeln(
        StringReplace(
'sleek (tm) 1.00 Copyright (c) 2000-2006 Daniel Oct 23,2006 $$' +
'Usage:     sleek -<action> <filename(s)> [/<param>]$$' +
'<action> = parameter action, can receive multiple action$' +
'  trim:                       behead <line>: delete lines that begins with it$'+
' ltrim: Left Trim               fine <file>: clean between delimiters$'+
' rtrim: Right Trim            gather <file>: Get Between including delimiters$'+
'  join: Join Lines           extract <file>: Get between delimiters Only$'+
' untag: remove all between tag$'+
'                             cites <folder>: change cited link to new folder$'+
'                               intag <file>: replace intag string$$'+
'<param> = operation parameter$'+
' /b : backup to filename.bak$'+
' /r : rename to filename#[number]$'+
' /t : keep original modified date-time$'+
' /o [folder]: determine output folder, if not specified then overwrite$'+
' /v : optVerbose show every activity$'+
' /s : output to stdout$'+
' /f : display file name$'
        ,'$', LB,  [rfReplaceAll] )
    );
    Halt(0);
end;

function getActionNumber(param : String) : integer;
const
    xAction : Array[0..10] of String =
    ('trim', 'ltrim', 'rtrim', 'join', 'untag', 'behead',
     'fine', 'gather', 'extract', 'cites', 'intag' );
var x , i : integer;
begin
    x := -1;
    for i := 0 to length(xAction) - 1  do
        if pos(param,xAction[i]) = 1 then
        begin
            x := i;
            break;
        end;
    Result := x;
end;

var ParamFile, OutputDirectory : string;
    i,j :integer;
    lastIn, fileIn, fileOut, filePrevious, s : string;

    myAct, myFile, myFileList, myParams, tParam : TStrings;
    myParamList : TObjectList;
    paramIndex, todo, pc, pp, originalTimeStamp : integer;
    f: TSearchRec;

    locale : TFormatSettings;

    optVerbose, optBackup, optRename, optScreen, optTimeOriginal, optFileName : boolean;

procedure Debug(a : String);
begin
    if optVerbose then
        Writeln(a);
end;

procedure Msg(a : string);
begin
    Writeln(a);
end;

begin
    locale := getLocaleSetting;

    ParamFile := '';
    OutputDirectory := '';
    optVerbose := false;
    optBackup := false;
    optRename := false;
    optScreen := false;
    optTimeOriginal := false;
    optFileName := false;

    myAct := TStringList.Create;
    myFile := TStringList.Create;
    myFileList := TStringList.Create;
    myParams := TStringList.Create;
    myParamList := TObjectList.Create;

    pc := ParamCount;
    { decode parameters }

    if pc < 2 then Help;

    { - determine what action to perform }
    // parse parameters
    paramIndex := 1;
    while (paramIndex <= pc) do
    begin
        s := ParamStr(paramIndex);
        case s[1] of
        '-' : // action
            begin
                // writeln('Action ', paramIndex);
                s := LowerCase(copy(paramStr(paramIndex),2, length(paramStr(paramIndex)) - 1));
                todo := getActionNumber(s);
                if (todo >= 0) and (todo < 11) then
                begin
                    if todo in [doSTRIP_LINE,
                                doSTRIP_BETWEEN_DELIMITER,
                                doGET_BETWEEN_WITH_DELIMITER,
                                doGET_BETWEEN_DELIMITER,
                                doInTagReplace,
                                doCITES] then
                    begin
                        if (paramIndex + 1) <= pc then
                        begin
                            ParamFile := paramStr(paramIndex + 1);
                            myAct.Add(s + ' ' + ParamFile);
                            Inc(paramIndex);
                            if todo in [
                                doSTRIP_LINE,
                                doSTRIP_BETWEEN_DELIMITER,
                                doGET_BETWEEN_WITH_DELIMITER,
                                doGET_BETWEEN_DELIMITER,
                                doInTagReplace ] then
                            begin

                                if not fileExists(ParamFile) then
                                    paramfile := ExtractFileDir(ParamStr(0)) + '\' + ExtractFileName(ParamFile);

                                if not FileExists(ParamFile) then
                                begin
                                    Ending(ParamFile + ' for ' + s + ' does not exist');
                                end
                                else
                                begin
                                    tParam := TStringList.Create;
                                    tParam.LoadFromFile(ParamFile);

                                    myParamList.Add( tParam );                              end;
                            end
                            else
                                begin
                                    tParam := TStringList.Create;
                                    tParam.Add(ParamFile);
                                    myParamList.Add(tParam);
                                end;
                        end
                        else
                        begin
                            Ending('some action require parameter');
                        end;
                    end
                    else
                    begin
                        myAct.Add(s);
                        myParamList.Add(nil);
                    end;
                end;
            end;
        '/' : // parameter
            begin
                s := LowerCase(copy(paramStr(paramIndex),2, length(paramStr(paramIndex)) - 1));
                // Writeln('Option ', paramIndex, ' = ' , s);
                if s = 'o' then
                begin
                    if pc < (paramIndex + 1) then
                        Ending('/o need output specified')
                    else
                        begin
                           OutputDirectory := paramStr(paramIndex+1);
                           Inc(paramIndex);
                        end;
                end;
                if (s = 't') then optTimeOriginal := true;
                if (s = 'b') then optBackup := true;
                if (s = 'r') then optRename := true;
                if (s = 'v') then
                begin
                    optVerbose := true;
                    optScreen := false;
                end;
                if (s = 's') then
                begin
                    optScreen := true;
                    optVerbose := false;
                end;
                if (s = 'f') then optFileName := true;
            end;
        else // file list
            begin
                    // Writeln('File ', paramIndex);
                myFile.Add(ParamStr(paramIndex));
            end;
        end;
        Inc(paramIndex);
    end;

    for i := 0 to myFile.Count - 1 do // list input files
    begin
        s := myFile[i];
        if (Pos('*', s)>0) or (Pos('?', s)>0) then
        begin
          ParamFile := ExtractFilePath(s);
          if ParamFile = '' then ParamFile := GetCurrentDir + '\';
          j := Findfirst(s, faAnyFile, f);
          if j <> 0 then
               Msg('No file match ' + s);
          repeat
            if ((f.Attr and faDirectory) = 0) and (j = 0) then
            begin
                myFileList.Add(f.Name)
            end;
            j := FindNext(f);
          until j <> 0;
          FindClose(f);
        end
        else
            if FileExists(s) then myFileList.Add(s);
    end;
    if myAct.Count < 1 then Ending('no action specified');
    if myFileList.Count < 1 then Ending('no file match'); // input files validity
    if length(OutputDirectory) > 0 then // output location validity
        if not DirectoryExists(OutputDirectory) then
        begin
            Debug('Making Directory : '+ OutputDirectory );
            if not CreateDir( OutputDirectory ) then
                Ending('Output Directory cannot be created');
        end;

    if optVerbose then
    begin
        Debug(LB+LB+'Actions: ');

        for i := 0 to myAct.Count - 1 do
        begin
            Debug(#9+IntToStr( i) + ' : '+ myAct[i]);
        end;

        Debug(LB+'File(s) : ');
        for i := 0 to myFile.Count - 1 do
        begin
            Debug(#9+ IntToStr( i ) +  ' : ' +  myFile[i]);
        end;

        Debug(LB+'Output Dir : '#13#10#9+  OutputDirectory);

        Debug(LB+'File List : ');
        for i := 0 to myFileList.Count - 1 do
        begin
            Debug(#9+IntToStr( i) + ' : '+ myFileList[i]);
        end;
    end;

    for i := 0 to myFileList.Count - 1 do
    begin
        fileIn := myFileList[i];
        if not FileExists(fileIn) then
        begin
          Msg( 'file "' + fileIn + '" not exists' );
          continue;
        end;
        originalTimeStamp := FileAge(fileIn);

        Debug(LB+fileIn+ '{');

        lastIn := LoadFromFile(fileIn);
        Debug(#9+ 'Read : ' +IntToStr( length(lastIn) ) ) ;
        for j := 0 to myAct.Count - 1 do
        begin
            // myParams.Clear;
            s := myAct[j];
            pp := pos(' ', s);

            Debug(#9+ s);

            if pp > 0 then
            begin
                myParams := TStrings(myParamList[j]) ;
                s := copy(s, 1, pp - 1 );
                todo := getActionNumber(s);
            end
            else
            begin
                todo := getActionNumber(s);
            end;
            DoIt(todo, lastIn, fileIn, myParams);
        end;
        if optScreen then
        begin
            if optFileName then
                Msg(fileIn + ':');
            Msg(lastIn);
            continue;
        end;

        if length(OutputDirectory) < 1 then
        begin
          // rename input file to something different, add extension based on option
          filePrevious := fileIn;
          if (optRename or optBackup) then
          begin
              if optRename then //  Find new name to Rename to
              begin
                    filePrevious := FindSharp(fileIn);
              end;

              if optBackup then // Find new name to backup to
              begin
                    filePrevious := FindBak(fileIn);
              end;
                Debug(#9#9'Rename '+ fileIn + #9 + filePrevious +LB +
                        #9#9'Write Output '+ fileIn);
              if not RenameFile(fileIn, filePrevious) then
                Msg('Cannot rename Input: '+ fileIn);

              if not SaveToFile(fileIn, lastIn) then
              begin
                Msg('Cannot Write Output : ');
              end;
          end
          else
          begin
            Debug(#9#9'Replace '+ fileIn);

                // delete input
                if not DeleteFile(fileIn) then
                    Msg('Cannot delete Input: '+fileIn);

                // save to output file
                if not SaveToFile(fileIn, lastIn) then
                begin
                    Msg('Cannot Write Output');
                end;
          end;

          if optTimeOriginal then
              BEGIN
                Debug(#9#9'set output to original TimeStamp');
                fileSetDate( fileIn, originalTimeStamp);
              END;
        end
        else // Output directory exists
        begin
            fileOut := OutputDirectory + DIR_DELI + ExtractFileName(fileIn);
            Debug(#9#9'Write to '+ fileOut);
            if FileExists(fileOut) then
                if (optRename or optBackup) then
                begin
                    if ( optRename )  then
                    begin
                        filePrevious := FindSharp(fileOut);
                    end;
                    if ( optBackup ) then
                    begin
                        filePrevious := FindBak(fileOut);
                    end;
                    // rename temp to fileOut
                    if not RenameFile(fileOut, filePrevious) then
                    Msg('Cannot rename existing output file : '+ fileOut);
                end;

            if not SaveToFile(fileOut, lastIn) then
            begin
                Msg('Cannot Write Output : '+ fileOut);
            end;

            if optTimeOriginal then
            BEGIN
                Debug(#9#9'set output to original TimeStamp');
                fileSetDate( fileOut, originalTimeStamp);
            END;
        end;
        Debug('}');
    end;
end.