unit untMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  System.IniFiles, IdStackWindows, IdStack, IdGlobal, Vcl.AppEvnts;

type
  TfrmMain = class(TForm)
    lblComputerName: TLabel;
    lblIPAddress: TLabel;
    lblTime: TLabel;
    tmrUI: TTimer;
    ApplicationEvents1: TApplicationEvents;
    procedure tmrUITimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    x,y,fontSize,fontColor,fontBold:Integer;
    fontName:string;
  public
    procedure ReadConfig();
    procedure fixUI;
  end;

var
  frmMain: TfrmMain;
  sExePath:string;
  hLastDesktop:THandle;
implementation

{$R *.dfm}
function wGetComputerName():string;
var
  buf:array[0..MAX_COMPUTERNAME_LENGTH]of Char;
  l:Cardinal;
begin
  l:=SizeOf(buf);
  FillChar(buf,l,0);
  GetComputerName(buf,l);
  Result:=StrPas(buf);
end;

function findDesktopWnd:THandle;
begin
  Result:=FindWindowEx(FindWindow('Progman', nil), 0,
      'shelldll_defview', nil);
end;


procedure TfrmMain.fixUI;
var
  hDesktop:THandle;
begin
  hDesktop:=findDesktopWnd;
  if (hDesktop>0) then
  begin
    if (hLastDesktop<>hDesktop) then
    begin
      Winapi.Windows.SetParent(Handle,hDesktop);
      SetWindowPos(Handle,0,x,y,0,0,SWP_NOSIZE);
      hLastDesktop:=hDesktop;
      ShowWindow(frmMain.Handle,SW_SHOW);
    end;
  end;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
//  SetWindowLong(Handle, GWL_EXSTYLE, GetWindowLong(Handle, GWL_EXSTYLE) or
//    not WS_EX_APPWINDOW or WS_EX_TOOLWINDOW);
//  SetWindowPos(Handle,HWND_TOPMOST,0,0,0,0,SWP_NOMOVE or SWP_NOSIZE);
  sExePath:=ExtractFilePath(Application.ExeName);
  ReadConfig;
  if x=0 then
    x:=Screen.Width - Width - 50;
  if y=0 then
    y:=Screen.Height - Height - 70;
  Left:=x;
  Top:=y;
  Font.Height:=fontsize;
  Font.Name:=fontName;
  Font.Color:=fontColor;
  if fontBold=1 then
    Font.Style := Font.Style + [fsbold];
  lblComputerName.Caption := wGetComputerName;
  lblTime.Caption := 'Wait...';
  lblIPAddress.Caption := 'Wait...';
end;

procedure TfrmMain.ReadConfig;
var
  inif:TIniFile;
begin
  inif:=TIniFile.Create(sExePath+'set.ini');
  try
    x:=inif.ReadInteger('set','top',0);
    y:=inif.ReadInteger('set','left',0);
    fontName:=inif.ReadString('set','fontname','Î¢ÈíÑÅºÚ');
    fontSize:=inif.ReadInteger('set','fontsize',20);
    fontColor:=inif.ReadInteger('set','fontcolor',clHighlight);
    fontBold:=inif.ReadInteger('set','fontbold',1);
  finally
    inif.Free;
  end;
end;

procedure TfrmMain.tmrUITimer(Sender: TObject);
var
  fStack:TIdStackWindows;
begin
  fixUI;
  lblTime.Caption := TimeToStr(Now);
  fStack := TIdStackWindows.Create;
  try
    lblIPAddress.Caption := fStack.LocalAddress;
  finally
    FreeAndNil(fStack);
  end;
end;

end.
