program DesktopStar;

uses
  Vcl.Forms, Winapi.Windows,
  untMain in 'untMain.pas' {frmMain};

{$R *.res}

begin
  Application.Initialize;
  Application.ShowMainForm:=False;
  Application.MainFormOnTaskbar := False;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
