unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, StdCtrls, Controls, Forms,
  Dialogs, Graphics, MMSystem, ScktComp, List32, Zip;

type TBlock = class
	NPC         :TIntList32;
	Mob         :TIntList32;
	CList       :TIntList32;
	MobProcTick :cardinal;
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
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    procedure Button1Click(Sender: TObject);
end;

var

	MapList :TStringList;
        Form1 :TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
	    str         :string;
        dat         :TMemoryStream;
	    tm          :TMap;
	    h           :array[0..3] of single;
	    maptype     :integer;

        sr	        :TSearchRec;
        w           :word;
        xy          :TPoint;
	    ta	        :TMapList;

        i,j         :integer;

        mapcoord    :array[0..600] of array[0..600] of byte;

        FWM         :TextFile;
        OUT         :TextFile;
        AF2         :TextFile;

        zipfile     :TZip;
        path        :string;
        animals     :TStringList;
        dir         :string;

        AppPath     :string;
begin

    MapList := nil;
    AppPath := GetCurrentDir;

    if FindFirst('map\*.gat', $27, sr) = 0 then begin
		repeat
            dat := TMemoryStream.Create;
            dat.LoadFromFile(AppPath + '\map\' + sr.Name);
            SetLength(str, 4);
            dat.Read(str[1], 4);

			dat.Read(w, 2);
			dat.Read(xy.X, 4);
			dat.Read(xy.Y, 4);

            str  := StringReplace(sr.Name, '.gat', '',[rfReplaceAll, rfIgnoreCase]);

            for j := 0 to xy.Y - 1 do begin
                for i := 0 to xy.X - 1 do begin

                    dat.Read(h[0], 4);
                    dat.Read(h[1], 4);
                    dat.Read(h[2], 4);
                    dat.Read(h[3], 4);
                    dat.Read(maptype, 4);

                    {if (maptype = 0) then begin
                        if (h[0] > 3) or (h[1] > 3) or (h[2] > 3) or (h[3] > 3) then begin
                            mapcoord[i][j] := 3;
                        end else begin
                            mapcoord[i][j] := 1;
                        end;
                    end else if (maptype = 5) then begin
                        mapcoord[i][j] := 0;
                    end
                    else begin
                        mapcoord[i][j] := 0;
                    end;}

                    mapcoord[i][j] := maptype; 

                end;
            end;

            dat.Free;

            if checkbox2.checked then begin
                AssignFile(FWM, 'afm/'+str+'.afm');
                ReWrite(FWM);
                WriteLn(FWM, 'ADVANCED FUSION MAP');
                WriteLn(FWM, str);
                WriteLn(FWM, inttostr(xy.X)+' '+inttostr(xy.Y));
                WriteLn(FWM);
            end;

            if checkbox3.checked then begin
                AssignFile(AF2, 'afm/'+str+'.out');
                ReWrite(AF2);
                WriteLn(AF2, 'ADVANCED FUSION MAP');
                WriteLn(AF2, str);
                WriteLn(AF2, inttostr(xy.X)+' '+inttostr(xy.Y));
                WriteLn(AF2);
            end;

            if checkbox1.Checked then begin
                AssignFile(OUT, 'afm/debug-'+str+'.txt');
                ReWrite(OUT);
                WriteLn(OUT, str+' '+inttostr(xy.X)+' '+inttostr(xy.Y));
            end;

            for j := 0 to xy.Y - 1 do begin
                for i := 0 to xy.X - 1 do begin

                    if checkbox2.checked then begin
                        Write(FWM, mapcoord[i][j]);
                    end;

                    if checkbox3.checked then begin
                        Write(AF2, mapcoord[i][j]);
                    end;

                    if checkbox1.Checked then begin
                        WriteLn(OUT, '('+inttostr(i)+','+inttostr(j)+') ['+inttostr(mapcoord[i][j])+']');
                    end;

                end;
                if checkbox2.checked then begin
                    WriteLn(FWM);
                end;
                if checkbox3.checked then begin
                    WriteLn(AF2);
                end;
            end;

            if checkbox2.checked then begin
                CloseFile(FWM);
            end;

            if checkbox3.checked then begin
                CloseFile(AF2);
            end;

            if checkbox1.Checked then begin
                CloseFile(OUT);
            end;

            if checkbox3.checked then begin
                deletefile(AppPath+'\afm\'+str+'.af2');

                zipfile := tzip.create(self);
                zipfile.Filename := AppPath+'\afm\'+str+'.af2';

                animals := TStringList.Create;
                animals.Add(AppPath+'\afm\'+str+'.out');

                zipfile.FileSpecList := animals;
                zipfile.Add;
                zipfile.Free;

                deletefile(AppPath+'\afm\'+str+'.out');

                animals.Free;
            end;

        until FindNext(sr) <> 0;
		FindClose(sr);
    end;

    label1.Caption := 'Conversion Complete';

end;

end.


{

                        dir := GetCurrentDir;

                        deletefile(dir+'\afm\'+str+'.afm');

                        zipfile := tzip.create(self);

                        zipfile.Filename := dir+'\afm\'+str+'.afm';

                        animals := TStringList.Create;
                        animals.Add(dir+'\afm\'+str+'.out');

                        zipfile.FileSpecList := animals;
                        zipfile.Add;
                        zipfile.Free;

                        deletefile(dir+'\afm\'+str+'.out');

                        animals.Free;



	end;
end;

}
