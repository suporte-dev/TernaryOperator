object FormPrincipal: TFormPrincipal
  Left = 0
  Top = 0
  Caption = 'Demo Operador Tern'#225'rio'
  ClientHeight = 313
  ClientWidth = 367
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  TextHeight = 15
  object LabelStatus: TLabel
    Left = 40
    Top = 80
    Width = 105
    Height = 25
    Caption = 'Desabilitado'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
  end
  object Label1: TLabel
    Left = 120
    Top = 155
    Width = 137
    Height = 15
    Caption = 'Entre com um n'#250'mero'
  end
  object CheckBoxHabilitado: TCheckBox
    Left = 40
    Top = 32
    Width = 297
    Height = 17
    Caption = 'Desabilitado'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnClick = CheckBoxHabilitadoClick
  end
  object ButtonMaiorQue: TButton
    Left = 120
    Top = 216
    Width = 121
    Height = 25
    Caption = 'N'#186' '#233' maior que cem?'
    TabOrder = 1
    OnClick = ButtonMaiorQueClick
  end
  object NumberBoxValor: TNumberBox
    Left = 120
    Top = 176
    Width = 121
    Height = 23
    TabOrder = 2
  end
end
