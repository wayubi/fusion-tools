unit Converter;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, MMSystem, IniFiles, DBXpress, DB, SqlExpr, StrUtils,
  ExtCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
    function ExecuteSqlCmd(sqlcmd: String) : Boolean;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
    Form1: TForm1;
    sl : TStringList;
    txt, sql : TextFile;
    str : String;
    bindata : String;
    i, j : integer;

implementation
var
    SQLDataSet    :TSQLDataSet;
    SQLConnection :TSQLConnection;


    {$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);

begin

    ExecuteSqlCmd('DROP TABLE IF EXISTS `temptable`');
    ExecuteSqlCmd('CREATE TABLE `temptable` (`AID` INT NOT NULL ,`CNAME` TEXT NOT NULL);');


    { Populate TempTable }
    AssignFile(txt,'player.txt');
    Reset(txt);
    Readln(txt, str);
    while not eof(txt) do begin
        sl.Clear;
        bindata := '';
        Readln(txt, str);
        sl.DelimitedText := str;
        Readln(txt, str);
        for i := 6 to 14 do begin
            if (sl.Strings[i] <> '') then begin
                sl.Strings[i] := StringReplace(sl.Strings[i], '''', '\''',[rfReplaceAll, rfIgnoreCase]);
                if not ExecuteSqlCmd('INSERT INTO temptable VALUES ('''+sl.Strings[0]+''','''+sl.Strings[i]+''')') then begin
                    //DebugOut.Lines.Add('*** Save Character Item data error.');
                    Exit;
                end;
            end;
        end;
    end;

    { Creation of Accounts Table }
    AssignFile(txt,'player.txt');
    Reset(txt);
    Readln(txt, str);

    while not eof(txt) do begin
        sl.Clear;
        bindata := '';

        Readln(txt, str);
        sl.DelimitedText := str;
        Readln(txt, str);
        //Writeln(sql, 'INSERT INTO accounts VALUES (''' + sl.Strings[0] + ''',''' + sl.Strings[1] + ''', ''' + sl.Strings[2] + ''', ''' + sl.Strings[3] + ''', ''' + sl.Strings[4] + ''', ''' + sl.Strings[5] + ''', '''');');
        if not ExecuteSqlCmd('REPLACE INTO accounts VALUES (''' + sl.Strings[0] + ''',''' + sl.Strings[1] + ''', ''' + sl.Strings[2] + ''', ''' + sl.Strings[3] + ''', ''' + sl.Strings[4] + ''', ''' + sl.Strings[5] + ''', '''')') then begin
            //DebugOut.Lines.Add('*** Save Character Item data error.');
            Exit;
        end;
    end;

    { Creation of Cart Table }
    AssignFile(txt,'chara.txt');
    Reset(txt);
    Readln (txt, str);
    while not eof(txt) do begin
        sl.Clear;
        bindata := '';
        
        Readln(txt, str);
        sl.DelimitedText := str;
        j := strtoint(sl.Strings[0]);
        Readln(txt, str);
        Readln(txt, str);
        Readln(txt, str);
        sl.DelimitedText := str;

        if (strtoint(sl.Strings[0]) <> 0) then begin
            for i := 0 to (strtoint(sl.Strings[0]) - 1) do begin
                if i > 1 then bindata := bindata + ',';
                bindata := bindata + sl.strings[0+(i*10)] + ',';
                bindata := bindata + sl.strings[1+(i*10)] + ',';
                bindata := bindata + sl.strings[2+(i*10)] + ',';
                bindata := bindata + sl.strings[3+(i*10)] + ',';
                bindata := bindata + sl.strings[4+(i*10)] + ',';
                bindata := bindata + sl.strings[5+(i*10)] + ',';
                bindata := bindata + sl.strings[6+(i*10)] + ',';
                bindata := bindata + sl.strings[7+(i*10)] + ',';
                bindata := bindata + sl.strings[8+(i*10)] + ',';
                bindata := bindata + sl.strings[9+(i*10)];
            end;

            if not ExecuteSqlCmd('REPLACE INTO cart VALUES ('''+inttostr(j)+''', '''+bindata+''')') then begin
                //DebugOut.Lines.Add('*** Save Character Item data error.');
                Exit;
            end;
            //Writeln(sql, 'INSERT INTO cart VALUES (''' + inttostr(j) + ''', ''' + bindata + ''');');
        end;
        Readln(txt, str);
    end;

    { Creation of Character Flags }
    AssignFile(txt,'chara.txt');
    Reset(txt);
    Readln (txt, str);
    while not eof(txt) do begin
        sl.Clear;
        bindata := '';

        Readln(txt, str);
        sl.DelimitedText := str;
        j := strtoint(sl.Strings[0]);

        Readln(txt, str);
        Readln(txt, str);
        Readln(txt, str);
        Readln(txt, str);

        sl.DelimitedText := str;

        if strtoint(sl.Strings[0]) <> 0 then begin
            for i := 1 to (sl.Count - 1) do begin
                if i > 1 then bindata := bindata + ',';
                bindata := bindata + sl.Strings[i];
            end;

            bindata := 'REPLACE INTO character_flags VALUES (''' + inttostr(j) + '''' + ',' + '''' + bindata + ''')';

            ExecuteSqlCmd(bindata);
        end;
    end;

    { Creation of Characters Table }
    AssignFile(txt,'chara.txt');
    Reset(txt);
    Readln (txt, str);
    while not eof(txt) do begin
        sl.Clear;
        bindata := '';
        
        Readln(txt, str);
        sl.DelimitedText := str;
        j := strtoint(sl.Strings[0]);
        sl.DelimitedText := str;

        if (strtoint(sl.Strings[0]) <> 0) then begin
            for i := 0 to 40 do begin
                sl.Strings[i] := StringReplace(sl.Strings[i], '''', '\''',[rfReplaceAll, rfIgnoreCase]);
                bindata := bindata + '''' + sl.Strings[i] + ''',';
            end;

            bindata := bindata + sl.Strings[50]+',';
            bindata := bindata + sl.Strings[51];

            str := 'SELECT AID FROM temptable where CNAME = "'+sl.Strings[1]+'"';
            if ExecuteSqlCmd(str) then begin
                i := 99;
                while not SQLDataSet.Eof do begin
                    bindata := '' + bindata + ',' + inttostr(SQLDataSet.FieldValues['AID']) + '';
                    i := 98;
                    break;
                end;
            end;

            if (i = 98) then begin
                ExecuteSqlCmd('REPLACE INTO characters VALUES ('+bindata+')');
            end;
            bindata := '';
            
            //Writeln(sql, '');
        end;
        Readln(txt, str);
        Readln(txt, str);
        Readln(txt, str);
        Readln(txt, str);
    end;

    { Creation of Guild Allies Table -- Not Implemented -- Bad SQL Structure }
    { Creation of Guild Hostiles Table -- Not Implemented -- Bad SQL Structure }

    { Creation of Guild Banish Table }
    AssignFile(txt,'guild.txt');
    Reset(txt);
    Readln (txt, str);
    while not eof(txt) do begin
        sl.Clear;
        bindata := '';
        
        Readln (txt, str);
        sl.DelimitedText := str;
        j := strtoint(sl.Strings[0]);

        Readln (txt, str);
        Readln (txt, str);
        Readln (txt, str);
        Readln (txt, str);
        sl.DelimitedText := str;

        for i := 0 to (strtoint(sl.Strings[0]) - 1) do begin
            bindata := 'REPLACE INTO guild_banish VALUES ('+inttostr(j)+','+sl.Strings[i*3+3]+','+sl.Strings[i*3+4]+','+sl.Strings[i*3+5]+')';
            ExecuteSqlCmd(bindata);
        end;
    end;

    { Creation of Guild Castle Table }
    AssignFile(txt,'gcastle.txt');
    Reset(txt);
    Readln (txt, str);
    while not eof(txt) do begin
        sl.Clear;
        bindata := '';

        Readln (txt, str);
        sl.DelimitedText := str;

        for i := 0 to 16 do begin
            bindata := bindata + '''' + sl.Strings[i] + '''';
            if i < 16 then bindata := bindata + ',';
        end;

        bindata := 'REPLACE INTO guild_castle VALUES ('+bindata+')';
        ExecuteSqlCmd(bindata);
    end;

    { Creation of Guild Info Table }
    AssignFile(txt,'guild.txt');
    Reset(txt);
    Readln (txt, str);
    while not eof(txt) do begin
        sl.Clear;
        bindata := '';

        Readln (txt, str);
        sl.DelimitedText := str;

        bindata := 'REPLACE INTO guild_info VALUES (';
        for i := 0 to 11 do begin
            sl.Strings[i] := StringReplace(sl.Strings[i], '''', '\''',[rfReplaceAll, rfIgnoreCase]);
            bindata := bindata + '''' + sl.Strings[i] + '''';
            bindata := bindata + ',';
        end;

        Readln (txt, str);
        Readln (txt, str);
        Readln (txt, str);
        sl.DelimitedText := str;

        bindata := bindata + '''';
        for i := 0 to (strtoint(sl.Strings[0]) - 1) do begin
            if i > 0 then bindata := bindata + ',';
            bindata := bindata + sl.Strings[0+(i*2)] + ',';
            bindata := bindata + sl.Strings[1+(i*2)];
        end;

        bindata := bindata + ''')';
        ExecuteSqlCmd(bindata);

        Readln (txt, str);
    end;

    { Creation of Guild Members Table }
    AssignFile(txt,'guild.txt');
    Reset(txt);
    Readln (txt, str);
    while not eof(txt) do begin
        sl.Clear;
        bindata := '';

        Readln (txt, str);
        sl.DelimitedText := str;
        j := strtoint(sl.Strings[0]);

        Readln (txt, str);
        sl.DelimitedText := str;

        for i := 0 to ((sl.Count div 3)-1) do begin
            if (strtoint(sl.Strings[0+(i*3)]) <> 0) then begin
                bindata := 'REPLACE INTO guild_members VALUES ('+inttostr(j)+','+sl.Strings[0+(i*3)]+','+sl.Strings[1+(i*3)]+','+sl.Strings[2+(i*3)]+')';
            end;
            ExecuteSqlCmd(bindata);
        end;

        Readln (txt, str);
        Readln (txt, str);
        Readln (txt, str);
    end;

    { Creation of Guild Positions Table }
    AssignFile(txt,'guild.txt');
    Reset(txt);
    Readln (txt, str);
    while not eof(txt) do begin
        sl.Clear;
        bindata := '';

        Readln (txt, str);
        sl.DelimitedText := str;
        j := strtoint(sl.Strings[0]);
        Readln (txt, str);
        Readln (txt, str);
        sl.DelimitedText := str;

        for i := 0 to 19 do begin
            bindata := 'REPLACE INTO guild_positions VALUES (' + '''' + inttostr(j) + '''' + ',';
            bindata := bindata + '''' + inttostr(i) + '''' + ',';
            sl.Strings[0+(i*4)] := StringReplace(sl.Strings[0+(i*4)], '''', '\''',[rfReplaceAll, rfIgnoreCase]);
            bindata := bindata + '''' + sl.Strings[0+(i*4)] + '''' + ',';
            bindata := bindata + '''' + sl.Strings[1+(i*4)] + '''' + ',';
            bindata := bindata + '''' + sl.Strings[2+(i*4)] + '''' + ',';
            bindata := bindata + '''' + sl.Strings[3+(i*4)] + '''' + ')';
            ExecuteSqlCmd(bindata);
        end;

        Readln (txt, str);
        Readln (txt, str);
    end;

    { Creation of Inventory Table }
    AssignFile(txt,'chara.txt');
    Reset(txt);
    Readln (txt, str);
    while not eof(txt) do begin
        sl.Clear;
        bindata := '';
        Readln(txt, str);
        sl.DelimitedText := str;
        j := strtoint(sl.Strings[0]);
        Readln(txt, str);
        Readln(txt, str);
        sl.DelimitedText := str;

        if (strtoint(sl.Strings[0]) <> 0) then begin
            for i := 0 to (strtoint(sl.Strings[0]) - 1) do begin
                if i > 0 then bindata := bindata + ',';
                bindata := bindata + sl.strings[1+(i*10)] + ',';
                bindata := bindata + sl.strings[2+(i*10)] + ',';
                bindata := bindata + sl.strings[3+(i*10)] + ',';
                bindata := bindata + sl.strings[4+(i*10)] + ',';
                bindata := bindata + sl.strings[5+(i*10)] + ',';
                bindata := bindata + sl.strings[6+(i*10)] + ',';
                bindata := bindata + sl.strings[7+(i*10)] + ',';
                bindata := bindata + sl.strings[8+(i*10)] + ',';
                bindata := bindata + sl.strings[9+(i*10)] + ',';
                bindata := bindata + sl.strings[10+(i*10)];
                //Writeln(sql, 'INSERT INTO inventory VALUES (''' + inttostr(j) + ''', ''' + (sl.Strings[1+(i*10)]) + ''', ''' + (sl.Strings[2+(i*10)]) + ''', ''' + (sl.Strings[3+(i*10)]) + ''', ''' + (sl.Strings[4+(i*10)]) + ''', ''' + (sl.Strings[5+(i*10)]) + ''', ''' + (sl.Strings[6+(i*10)]) + ''', ''' + (sl.Strings[7+(i*10)]) + ''', ''' + (sl.Strings[8+(i*10)]) + ''', ''' + (sl.Strings[9+(i*10)]) + ''', ''' + (sl.Strings[10+(i*10)]) + ''');');
            end;

            if not ExecuteSqlCmd('REPLACE INTO inventory VALUES ('''+inttostr(j)+''', '''+bindata+''')') then begin
                //DebugOut.Lines.Add('*** Save Character Item data error.');
                Exit;
            end;
            //Writeln(sql, 'INSERT INTO inventory VALUES (''' + inttostr(j) + ''', ''' + bindata + ''');');
        end;
        Readln(txt, str);
        Readln(txt, str);
    end;

    { Creation of Party Table }
    AssignFile(txt,'party.txt');
    Reset(txt);
    Readln (txt, str);
    while not eof(txt) do begin
        sl.Clear;
        bindata := '';
        Readln(txt, str);
        sl.DelimitedText := str;
        sl.Strings[0] := StringReplace(sl.Strings[0], '''', '\''',[rfReplaceAll, rfIgnoreCase]);
        bindata := 'REPLACE INTO party VALUES (' + '''' + '''' + ',' + '''' + sl.Strings[0] + '''' + ',' + '''' + '''' + ',' + '''' + '''' + ',';
        for i := 0 to 11 do begin
            bindata := bindata + '''' + sl.Strings[i+1] + '''';
            if i < 11 then bindata := bindata + ','
            else bindata := bindata + ')';
        end;
        ExecuteSqlCmd(bindata);
    end;

    { Creation of Pet Table }
    AssignFile(txt,'pet.txt');
    Reset(txt);
    Readln (txt, str);
    while not eof(txt) do begin
        sl.Clear;
        bindata := '';
        Readln(txt, str);
        sl.DelimitedText := str;
        sl.Strings[7] := StringReplace(sl.Strings[7], '''', '\''',[rfReplaceAll, rfIgnoreCase]);
        bindata := 'REPLACE INTO pet VALUES (' + '''' + sl.Strings[5] + '''' + ',';
        for i := 0 to 12 do begin
            if (i <> 5) then begin
                bindata := bindata + '''' + sl.Strings[i] + '''';
                if i < 12 then bindata := bindata + ','
                else bindata := bindata + ')';
            end;
        end;
        if strtoint(sl.Strings[5]) <> 0 then ExecuteSqlCmd(bindata);
    end;

    { Creation of Skills Table }
    AssignFile(txt,'chara.txt');
    Reset(txt);
    Readln (txt, str);
    while not eof(txt) do begin
        sl.Clear;
        bindata := '';
        Readln(txt, str);
        sl.DelimitedText := str;
        j := strtoint(sl.Strings[0]);
        Readln(txt, str);
        sl.DelimitedText := str;

        if (strtoint(sl.Strings[0]) <> 0) then begin
            for i := 0 to (strtoint(sl.Strings[0]) - 1) do begin
                if i > 0 then bindata := bindata + ','; 
                bindata := bindata + sl.strings[1+(i*2)] + ',';
                bindata := bindata + sl.strings[2+(i*2)];
            end;

            ExecuteSqlCmd('REPLACE INTO skills VALUES ('''+inttostr(j)+''', '''+bindata+''')');
        end;
        Readln(txt, str);
        Readln(txt, str);
        Readln(txt, str);
    end;

    { Creation of Storage Table }
    AssignFile(txt,'player.txt');
    Reset(txt);
    Readln (txt, str);
    while not eof(txt) do begin
        sl.Clear;
        bindata := '';

        Readln(txt, str);
        sl.DelimitedText := str;
        j := strtoint(sl.Strings[0]);
        Readln(txt, str);
        sl.DelimitedText := str;

        if (strtoint(sl.Strings[0]) <> 0) then begin
            for i := 0 to (strtoint(sl.Strings[0]) - 1) do begin
                if i > 0 then bindata := bindata + ',';
                bindata := bindata + sl.strings[1+(i*10)] + ',';
                bindata := bindata + sl.strings[2+(i*10)] + ',';
                bindata := bindata + sl.strings[3+(i*10)] + ',';
                bindata := bindata + sl.strings[4+(i*10)] + ',';
                bindata := bindata + sl.strings[5+(i*10)] + ',';
                bindata := bindata + sl.strings[6+(i*10)] + ',';
                bindata := bindata + sl.strings[7+(i*10)] + ',';
                bindata := bindata + sl.strings[8+(i*10)] + ',';
                bindata := bindata + sl.strings[9+(i*10)] + ',';
                bindata := bindata + sl.strings[10+(i*10)];
            end;

            if not ExecuteSqlCmd('REPLACE INTO storage VALUES ('''+inttostr(j)+''', '''+bindata+''', '''')') then begin
                //DebugOut.Lines.Add('*** Save Character Item data error.');
                Exit;
            end;
            //Writeln(sql, 'INSERT INTO storage VALUES (''' + inttostr(j) + ''', ''' + bindata + ''', '''');');
        end;
    end;

    { Creation of Warp Memo Table }
    AssignFile(txt,'chara.txt');
    Reset(txt);
    Readln (txt, str);
    while not eof(txt) do begin
        sl.Clear;
        bindata := '';
        
        Readln(txt, str);
        sl.DelimitedText := str;

        bindata := '''' + sl.Strings[0] + '''' + ',';
        if (sl.Strings[41] <> '') then begin
            for i := 0 to 2 do begin
                bindata := bindata + '''' + sl.Strings[41+i*3] + '''' + ',';
                bindata := bindata + '''' + sl.Strings[42+i*3] + '''' + ',';
                bindata := bindata + '''' + sl.Strings[43+i*3] + '''';
                if i < 2 then bindata := bindata + ',';
            end;
            
            ExecuteSqlCmd('REPLACE INTO warpmemo VALUES ('+bindata+')');
        end;

        Readln(txt, str);
        Readln(txt, str);
        Readln(txt, str);
        Readln(txt, str);
    end;

end;

function TForm1.ExecuteSqlCmd(sqlcmd: String) : Boolean;
begin
    Result := False;

	if not assigned(SQLConnection) then begin
        SQLConnection := TSQLConnection.Create(nil);
        SQLConnection.ConnectionName := 'MySQLConnection';
        SQLConnection.DriverName := 'MySQL';
        SQLConnection.GetDriverFunc := 'getSQLDriverMYSQL';
        SQLConnection.KeepConnection := True;
        SQLConnection.LibraryName := 'dbexpmysql.dll';
        SQLConnection.LoginPrompt := False;
        SQLConnection.VendorLib := 'libmysql.dll';
        SQLConnection.Params.Values['HostName'] := edit1.text;
        SQLConnection.Params.Values['Database'] := edit4.text;
        SQLConnection.Params.Values['User_Name'] := edit3.text;
        SQLConnection.Params.Values['Password'] := edit2.text;
	end;

	if not SQLConnection.Connected then begin
        try
            SQLConnection.Connected := True;
        except
            //DebugOut.Lines.Add('*** Error on MySQL Connect.');
            Exit;
        end;
    end;

    if not assigned(SQLDataSet) then begin
        SQLDataSet := TSQLDataSet.Create(nil);
        SQLDataSet.SQLConnection := SQLConnection;
    end;

    if SQLDataSet.Active then
        SQLConnection.Close;

    SQLDataSet.CommandText := sqlcmd;

    if UpperCase(copy(SQLDataSet.CommandText,1,6)) <> 'SELECT' then begin
        try
            SQLDataSet.ExecSQL;
        except
            //DebugOut.Lines.Add( Format( '*** Execute SQL Error: %s', [sqlcmd] ) );
            exit;
        end;
        Result := True;
		Exit;
    end;

	try
        SQLDataSet.Open;
    except
        //DebugOut.Lines.Add( Format( '*** Open SQL Data Error: %s', [sqlcmd] ) );
        exit;
    end;

    ExecuteSqlCmd('DROP TABLE IF EXISTS `temptable`');


	Result := True;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
    sl := TStringList.Create;
    sl.QuoteChar := '"';
    sl.Delimiter := ',';
end;

end.
