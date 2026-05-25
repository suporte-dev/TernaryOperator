program ProjectOperadorTernario;

uses
  Vcl.Forms,
  Uprincipal in 'src\Uprincipal.pas' {FormPrincipal},
  TernaryOperator in 'src\TernaryOperator.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormPrincipal, FormPrincipal);
  Application.Run;
end.
