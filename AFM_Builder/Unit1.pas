unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, StdCtrls, Controls, Forms,
  Dialogs, Graphics, MMSystem, ScktComp, List32;

type TBlock = class
	NPC         :TIntList32;
	Mob         :TIntList32;
	CList       :TIntList32;
	MobProcTick :cardinal;

	//constructor Create;
	//destructor Destroy; override;
end;

type TMap = class
	Name      :string;
	Size      :TPoint;
	gat       :array of array of byte;
	BlockSize :TPoint;
	Block     :array[-3..67] of array[-3..67] of TBlock;
	NPC       :TIntList32;
	NPCLabel  :TStringList;
	CList     :TIntList32;
	Mob       :TIntList32;
	Mode      :byte;
	TimerAct  :TIntList32;
	TimerDef  :TIntList32;
        //constructor Create;
	//destructor Destroy; override;
end;

type TMapList = class
	Name      :string;
        Ext       :string;
	Size      :TPoint;
	Mode      :byte;
end;

type TForm1 = class(TForm)
    Button1: TButton;
    CheckBox1: TCheckBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    procedure Button1Click(Sender: TObject);
end;

var

	MapList :TStringList;
        Form1 :TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
	str     :string;
        dat     :TFileStream;
        dat2     :TMemoryStream;
	tm      :TMap;
	h  :array[0..3] of single;
	maptype :integer;

        sr	:TSearchRec;
        w       :word;
        xy      :TPoint;
	ta	:TMapList;

        i,j     :integer;

        mapcoord :array[0..600] of array[0..600] of byte;

        FWM :TextFile;
        OUT :TextFile;

begin

        tm := nil;
        MapList := nil;

        if FindFirst('map\*.gat', $27, sr) = 0 then begin
		repeat
			dat := TFileStream.Create('map\' + sr.Name, fmOpenRead, fmShareDenyWrite);

			SetLength(str, 4);
                        dat.Read(str[1], 4);
                        if str <> 'GRAT' then begin
                                MessageBox(Handle, PChar('Map Format Error : ' + sr.Name), 'eWeiss', MB_OK or MB_ICONSTOP);
                                Application.Terminate;
                                exit;
			end;

			dat.Read(w, 2);
			dat.Read(xy.X, 4);
			dat.Read(xy.Y, 4);

			ta := TMapList.Create;
			ta.Name := LowerCase(ChangeFileExt(sr.Name, ''));
                        ta.Ext := 'gat';
			ta.Size := xy;
			ta.Mode := 0;
			//MapList.AddObject(ta.Name, ta);

                        str  := StringReplace(sr.Name, '.gat', '',[rfReplaceAll, rfIgnoreCase]);

                        AssignFile(FWM, 'afm/'+str+'.afm');
                        ReWrite(FWM);

                        WriteLn(FWM, 'ADVANCED FUSION MAP');
                        WriteLn(FWM, str);
                        WriteLn(FWM, inttostr(xy.X)+' '+inttostr(xy.Y));
                        WriteLn(FWM);

                        if checkbox1.Checked then AssignFile(OUT, 'afm/debug-'+str+'.txt');
                        if checkbox1.Checked then ReWrite(OUT);

                        if checkbox1.Checked then WriteLn(OUT, str+' '+inttostr(xy.X)+' '+inttostr(xy.Y));

                       	for j := 0 to xy.Y - 1 do begin
                		for i := 0 to xy.X - 1 do begin
                                        if ta.Ext = 'gat' then begin
                                                dat.Read(h[0], 4);
                		        	dat.Read(h[1], 4);
		                	        dat.Read(h[2], 4);
        			                dat.Read(h[3], 4);
                	        		dat.Read(maptype, 4);

                                                if (maptype = 0) then begin
                                                        if (h[0] > 3) or (h[1] > 3) or (h[2] > 3) or (h[3] > 3) then begin
                        					mapcoord[i][j] := 3;
                                                        end else begin
                		        			mapcoord[i][j] := 1;
                                                        end;
                                                end else if (maptype = 5) then begin
                                                        mapcoord[i][j] := 0;
                                                end;

                                        end;

                                        // WRITE OUT

                                        Write(FWM, mapcoord[i][j]);
                                        if checkbox1.Checked then WriteLn(OUT, '('+inttostr(i)+','+inttostr(j)+') ['+inttostr(mapcoord[i][j])+']');

                                        // WRITE OUT


                                end;
                                WriteLn(FWM);
                        end;

                        CloseFile(FWM);
                        if checkbox1.Checked then CloseFile(OUT);
                        label1.Caption := 'Conversion Complete';
                        dat.Free;
		until FindNext(sr) <> 0;
		FindClose(sr);

	end;
end;

end.
