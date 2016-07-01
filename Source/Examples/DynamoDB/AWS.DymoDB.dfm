object frmDymoDB: TfrmDymoDB
  Left = 0
  Top = 0
  Caption = 'AWS DymoDB'
  ClientHeight = 487
  ClientWidth = 636
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object meResponse: TMemo
    Left = 16
    Top = 47
    Width = 601
    Height = 418
    ScrollBars = ssBoth
    TabOrder = 0
  end
  object btnTest: TButton
    Left = 16
    Top = 16
    Width = 75
    Height = 25
    Caption = 'Test'
    TabOrder = 1
    OnClick = btnTestClick
  end
end
