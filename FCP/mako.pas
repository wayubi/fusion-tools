unit mako;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, jpeg, MMSystem;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    Button1: TButton;
    Label1: TLabel;
    Image1: TImage;
    procedure Button1Click(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;



var
  Form1: TForm1;

  procedure load_index();
  procedure load_txt(name : String; stamp : String);
  procedure load_sci(name : String; stamp : String);
  procedure load_cpy(name : String; ext : String);


implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
	load_index();
	label1.Caption := 'Patch Applied.';
end;

procedure load_index();
var
	datafile : TStringList;
    i : Integer;

    filename : String;
    filetype : String;
    filestamp : String;

    dir : String;
begin
	datafile := TStringList.Create;

	datafile.LoadFromFile(GetCurrentDir+'\MRF\INDEX.MRF');

    for i := 0 to (datafile.Count div 3) - 1 do begin
    	filename := datafile[0+(i*3)];
        filetype := datafile[1+(i*3)];
        filestamp := datafile[2+(i*3)];

        if (filetype = 'TXT') then load_txt(filename, filestamp)
        else if (filetype = 'SCI') then load_sci(filename, filestamp)
        else if (filetype = 'CPY') then load_cpy(filename, filestamp);
    end;

    datafile.Free;
end;

procedure load_txt(name : String; stamp : String);
var
	datafile_from : TStringList;
    i, j : Integer;
    datafile_to : TStringList;

    datafile_target_size : Integer;
    datafile_to_filename : String;

    patchexists : Boolean;

begin
	patchexists := False;

	datafile_from := TStringList.Create;
    datafile_to := TStringList.Create;

	if FileExists(GetCurrentDir+'\MRF\' + name) then begin
    	datafile_from.LoadFromFile(GetCurrentDir+'\MRF\' + name);
        for i := 0 to datafile_from.Count - 2 do begin

        	if (Copy(datafile_from[i], 0, 9) =  '////FILE:') then begin

                patchexists := False;

            	datafile_from[i] := StringReplace(datafile_from[i], '////FILE:', '', [rfReplaceAll, rfIgnoreCase]);
                datafile_from[i] := StringReplace(datafile_from[i], '////', '', [rfReplaceAll, rfIgnoreCase]);

                datafile_to_filename := datafile_from[i];

                if FileExists(form1.Edit1.Text + datafile_from[i]) then begin
                	datafile_to.LoadFromFile(form1.Edit1.Text + datafile_from[i]);
                    datafile_target_size := datafile_to.Count;
                end;


                for j := 0 to datafile_to.Count - 1 do begin
                	if datafile_to[j] = '//'+stamp then begin
                    	patchexists := True;
                        Break;
                    end;
                end;


                if not patchexists then datafile_to.add('//'+stamp);

            end;

            if patchexists then Continue;

            if datafile_target_size = 0 then begin
            	if Copy(datafile_from[i], 0, 5) = 'data\' then Continue;
	            datafile_to.Add(datafile_from[i]);
            	if Copy(datafile_from[i+1], 0, 4) = '////' then begin
        	    	datafile_to.Add('//'+stamp);
    	        	datafile_to.SaveToFile(form1.Edit1.Text + datafile_to_filename);
                    datafile_to.Clear;
                    patchexists := False;
	            end;
            end else if datafile_to[datafile_target_size-1] <> ('//'+stamp) then begin
            	if Copy(datafile_from[i], 0, 5) = 'data\' then Continue;
            	datafile_to.Add(datafile_from[i]);
            	if Copy(datafile_from[i+1], 0, 4) = '////' then begin
        	    	datafile_to.Add('//'+stamp);
    	        	datafile_to.SaveToFile(form1.Edit1.Text + datafile_to_filename);
                    datafile_to.Clear;
	            end;
            end;

        end;

    end else begin
    	form1.Label1.Caption := name + ' does not exist.';
    end;

    datafile_from.Free;
    datafile_to.Free;
end;

procedure load_sci(name : String; stamp : String);
var
	datafile_from : TStringList;
    datafile_to : TStringList;
    i, j : Integer;
    newentry : Boolean;
begin
	datafile_from := TStringList.Create;
    datafile_to := TStringList.Create;

    newentry := True;

	if FileExists(GetCurrentDir+'\MRF\' + name) then begin
    	datafile_from.LoadFromFile(GetCurrentDir+'\MRF\' + name);

        if datafile_from[0] = #9 + '<connection>' then begin
        	if not FileExists(form1.Edit1.Text + 'data\sclientinfo.xml') then begin
            	datafile_to.Clear;
                datafile_to.Add('<?xml version="1.0" encoding="euc-kr" ?>');
                datafile_to.Add('<clientinfo>');
                datafile_to.Add(#9 + '<desc>Ragnarok Client Information</desc>');
                datafile_to.Add(#9 + '<servicetype>america</servicetype>');
                datafile_to.Add(#9 + '<servertype>primary</servertype>');
                datafile_to.Add('</clientinfo>');
                datafile_to.SaveToFile(form1.Edit1.Text + 'data\sclientinfo.xml');
                datafile_to.Clear;
            end;
            datafile_to.LoadFromFile(form1.Edit1.Text + 'data\sclientinfo.xml');

            for i := 0 to datafile_to.Count - 1 do begin
            	if datafile_to[i] = datafile_from[1] then begin
	            	newentry := False;
                    Continue;
                end;
            end;

            if not newentry then begin

            	for i := 0 to datafile_to.Count - 1 do begin
                	if datafile_from[1] = datafile_to[i+1] then begin

                    	while (datafile_to[i] <> #9+'</connection>') do begin
                        	datafile_to.Delete(i);
                        end;
                        datafile_to.Delete(i);
                        Break;

                    end;
                end;

            end;

            for i := 0 to datafile_from.Count - 1 do begin
                datafile_to.Insert(5+i, datafile_from[i]);
            end;

            datafile_to.SaveToFile(form1.Edit1.Text + 'data\sclientinfo.xml');

        end else begin
        	form1.Label1.Caption := 'Incorrect format.';
            Exit;
        end;

    end else begin
    	form1.Label1.Caption := name + ' does not exist.';
    end;
    
    datafile_from.Free;
    datafile_to.Free;
end;

procedure load_cpy(name : String; ext : String);
var
	datafile_from : TStringList;
    i, j : Integer;
    datafile_to : TStringList;
    datafile_to_filename : String;
begin
	datafile_from := TStringList.Create;

	if FileExists(GetCurrentDir+'\MRF\' + name) then begin
    	datafile_from.LoadFromFile(GetCurrentDir+'\MRF\' + name);
        for i := 0 to datafile_from.Count - 2 do begin

        	if (Copy(datafile_from[i], 0, 9) =  '////FILE:') then begin
                datafile_to_filename := StringReplace(datafile_from[i], '////FILE:', '', [rfReplaceAll, rfIgnoreCase]);
                datafile_to_filename := StringReplace(datafile_to_filename, '////', '', [rfReplaceAll, rfIgnoreCase]);
            end;

            if Copy(datafile_from[i], 0, 9) = '////FILE:' then Continue;

            CopyFile(PChar('MRF\'+datafile_from[i]), PChar(form1.Edit1.Text + datafile_to_filename),True);
        end;

    end else begin
    	form1.Label1.Caption := name + ' does not exist.';
    end;

    datafile_from.Free;
end;

end.

