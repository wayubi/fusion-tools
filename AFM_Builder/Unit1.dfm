object Form1: TForm1
  Left = 520
  Top = 666
  BorderStyle = bsDialog
  Caption = 'Advanced Fusion Map Maker'
  ClientHeight = 179
  ClientWidth = 248
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 40
    Width = 216
    Height = 52
    Caption = 
      'Place your .GAT files inside the MAP subfolder and click on Star' +
      't to begin the conversion. Check the checkbox below if you want ' +
      'detailed debug output statistics.'
    WordWrap = True
  end
  object Label2: TLabel
    Left = 88
    Top = 8
    Width = 143
    Height = 26
    Caption = 'Advanced Fusion Map Maker. Version 1.40'
    WordWrap = True
  end
  object Label3: TLabel
    Left = 184
    Top = 144
    Width = 73
    Height = 26
    Caption = 'Created By:  Alex Kreuz'
    WordWrap = True
  end
  object Button1: TButton
    Left = 8
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Start'
    TabOrder = 0
    OnClick = Button1Click
  end
  object CheckBox1: TCheckBox
    Left = 8
    Top = 104
    Width = 217
    Height = 17
    Caption = 'Debug Output Stats'
    TabOrder = 1
  end
  object CheckBox2: TCheckBox
    Left = 8
    Top = 128
    Width = 97
    Height = 17
    Caption = 'AFM Format'
    TabOrder = 2
  end
  object CheckBox3: TCheckBox
    Left = 8
    Top = 152
    Width = 97
    Height = 17
    Caption = 'AF2 Format'
    TabOrder = 3
  end
end
