program makopatcher;

uses
  Forms,
  mako in 'mako.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Fusion Client Patcher';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
