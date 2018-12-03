object frmMain: TfrmMain
  Left = 0
  Top = 0
  AlphaBlend = True
  BorderStyle = bsNone
  ClientHeight = 94
  ClientWidth = 188
  Color = clWhite
  TransparentColor = True
  TransparentColorValue = clWhite
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clFuchsia
  Font.Height = 20
  Font.Name = #24494#36719#38597#40657
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 20
  object lblComputerName: TLabel
    Left = 0
    Top = 0
    Width = 180
    Height = 18
    Alignment = taCenter
    AutoSize = False
    Caption = 'ComputerName'
  end
  object lblIPAddress: TLabel
    Left = 0
    Top = 32
    Width = 180
    Height = 18
    Alignment = taCenter
    AutoSize = False
    Caption = 'IP'
  end
  object lblTime: TLabel
    Left = 0
    Top = 64
    Width = 180
    Height = 18
    Alignment = taCenter
    AutoSize = False
    Caption = 'Time'
  end
  object tmrUI: TTimer
    OnTimer = tmrUITimer
    Left = 24
    Top = 8
  end
  object ApplicationEvents1: TApplicationEvents
    Left = 136
    Top = 8
  end
end
