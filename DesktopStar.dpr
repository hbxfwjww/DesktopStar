program DesktopStar;

uses
  Vcl.Forms, Winapi.Windows, System.Win.Registry, System.SysUtils,
  untMain in 'untMain.pas' {frmMain};

{$R *.res}
const
  gAutoRunName='DesktopStar';

function MsgBox(sText,sCaption:string;msgType:Cardinal):integer;
begin
  Result := MessageBoxW(0,PWideChar(WideString(sText)),PWideChar(WideString(sCaption)),msgType);
end;

function IsAutoRun:Boolean;
var
  reg:TRegistry;
begin
  Result:=False;
  reg:=TRegistry.Create;
  try
    reg.RootKey:=HKEY_LOCAL_MACHINE;
    if reg.OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion\Run',False) then
    begin
      Result := reg.ValueExists(gAutoRunName);
      if Result then
        if Pos(UpperCase(Application.ExeName),UpperCase(reg.ReadString(gAutoRunName)))<>1 then
        begin
          if MsgBox('��⵽�����Զ������ļ��뵱ǰ·���������Ƿ�������','����',MB_ICONERROR or MB_YESNO)=IDYES then
            reg.WriteString(gAutoRunName,Application.ExeName);
        end;
      reg.CloseKey;
    end;
  finally
    reg.Free;
  end;
end;

function SetAutoRun(bAutoRun:Boolean=True):Boolean;
var
  reg:TRegistry;
begin
  Result:=False;
  reg:=TRegistry.Create;
  try
    reg.RootKey:=HKEY_LOCAL_MACHINE;
    if reg.OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion\Run',True) then
      if bAutoRun then
        try
          reg.WriteString(gAutoRunName,Application.ExeName);
          Result := True;
        except
        end
      else
        try
          if reg.ValueExists(gAutoRunName) then
            Result := reg.DeleteValue(gAutoRunName);
        except
        end;
    reg.CloseKey;
  finally
    reg.Free;
  end;
end;

begin
  if SameText('uninstall',ParamStr(1)) then
  begin
    if not IsAutoRun then
      MsgBox(gAutoRunName+'δ��װ��','��ʾ',MB_ICONINFORMATION)
    else
    begin
      if SetAutoRun(False) then
        MsgBox(gAutoRunName+'ж�سɹ���','��ʾ',MB_ICONINFORMATION)
      else
        MsgBox(gAutoRunName+'ж��ʧ�ܣ����룺'+IntToStr(GetLastError),'����',MB_ICONERROR)
    end;
    Exit;
  end;
  gAppMutex:=CreateMutex(nil,false,gAutoRunName);
  if GetLastError=ERROR_ALREADY_EXISTS then Exit;
  SetAutoRun(True);
  Application.Initialize;
  Application.ShowMainForm:=False;
  Application.MainFormOnTaskbar := False;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
