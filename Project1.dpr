program Project1;

uses
  Forms,
  Unit1 in 'Unit1.pas' {frmmain};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(Tfrmmain, frmmain);
  Application.Run;
end.

