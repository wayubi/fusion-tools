program SQL;

uses
  madExcept,
  Forms,
  Converter in 'Converter.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Fusion MySQL Importer 1.00';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
