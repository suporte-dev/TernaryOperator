unit Uprincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.NumberBox;

type
  TFormPrincipal = class(TForm)
    CheckBoxHabilitado: TCheckBox;
    LabelStatus: TLabel;
    ButtonMaiorQue: TButton;
    NumberBoxValor: TNumberBox;
    Label1: TLabel;
    procedure CheckBoxHabilitadoClick(Sender: TObject);
    procedure ButtonMaiorQueClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormPrincipal: TFormPrincipal;

implementation

{$R *.dfm}

uses
  TernaryOperator, StrUtils;

procedure TFormPrincipal.ButtonMaiorQueClick(Sender: TObject);
begin
  // Simples, sem procedures (TAction)
  // var
  // resultado := TTernary<string>.New(NumberBoxValor.ValueInt > 100,
  // Format('O número %d é maior que 100', [NumberBoxValor.ValueInt]))
  // .Pipe(Format('O número %d é menor que 100', [NumberBoxValor.ValueInt]));

  // Com procedures (TAction) - opcional
  var
  resultado := TTernary<string>.New(NumberBoxValor.ValueInt > 100,
    Format('O número %d é maior que 100', [NumberBoxValor.ValueInt]),
    procedure
    begin
      LabelStatus.Font.Color := clGreen;
    end).Pipe(TTernary<string>.New(NumberBoxValor.ValueInt = 100,
    Format('O número %d é exatamente 100', [NumberBoxValor.ValueInt]),
    procedure
    begin
      LabelStatus.Font.Color := clBlue;
    end).Pipe(Format('O número %d é menor que 100', [NumberBoxValor.ValueInt]),
    procedure
    begin
      LabelStatus.Font.Color := clRed;
    end));

  LabelStatus.Caption := resultado;

  ShowMessage(resultado);

end;

procedure TFormPrincipal.CheckBoxHabilitadoClick(Sender: TObject);
begin
  // Exemplo utilizando TAction
  LabelStatus.Caption := TTernary<String>.New(CheckBoxHabilitado.Checked,
    'Habilitado',
    procedure
    begin
      LabelStatus.Font.Color := clGreen;
    end).Pipe('Desabilitado',
    procedure
    begin
      LabelStatus.Font.Color := clRed;
    end);

  var
  resultado := TTernary<String>.New(CheckBoxHabilitado.Checked, 'Habilitado',
    procedure
    begin
      // faça qualquer coisa

    end).Pipe('Desabilitado',
    procedure
    begin
      // faça qualquer coisa
    end);

  CheckBoxHabilitado.Caption := resultado;

  // Exemplo de uso simples (sem TAction)

  // LabelStatus.Caption := TTernary<String>.New(CheckBoxHabilitado.Checked,
  // 'Habilitado').Pipe('Desabilitado');
  //
  // CheckBoxHabilitado.Caption := TTernary<String>.New(CheckBoxHabilitado.Checked,
  // 'Habilitado').Pipe('Desabilitado');
end;

end.
