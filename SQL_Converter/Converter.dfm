object Form1: TForm1
  Left = 517
  Top = 62
  Width = 261
  Height = 134
  Caption = 'Fusion MySQL Importer 1.00'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 113
    Height = 65
    Caption = 
      'Place your .txt files in the same folder as this EXE. Fill in th' +
      'e info, and click Import'
    WordWrap = True
  end
  object Button1: TButton
    Left = 8
    Top = 80
    Width = 75
    Height = 25
    Caption = 'Import'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Edit1: TEdit
    Left = 128
    Top = 8
    Width = 121
    Height = 21
    TabOrder = 1
    Text = 'IP Address'
  end
  object Edit2: TEdit
    Left = 128
    Top = 80
    Width = 121
    Height = 21
    TabOrder = 2
    Text = 'Password'
  end
  object Edit3: TEdit
    Left = 128
    Top = 56
    Width = 121
    Height = 21
    TabOrder = 3
    Text = 'Username'
  end
  object Edit4: TEdit
    Left = 128
    Top = 32
    Width = 121
    Height = 21
    TabOrder = 4
    Text = 'Database'
  end
end
