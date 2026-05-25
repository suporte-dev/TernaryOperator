{$REGION 'Documentation'}
///  <summary>
///   TernaryOperator Unit - Operador Ternário para Delphi
///  </summary>
///  <remarks>
///   Esta unit implementa uma abordagem diferente para operador ternário
///   Custom Managed Records do Delphi 10.4+.
///
///   Propósito:
///   - Fornecer sintaxe concisa para expressões condicionais
///   - Suportar encadeamento para múltiplas condições (if-else if-else)
///   - Permitir execução de procedures como efeitos colaterais
///   - Manter type-safety com genéricos
///
///   Exemplo Básico:
///   var status := TTernary<string>.New(ativo, 'Sim').Pipe('Não');
///
///   Exemplo com Encadeamento:
///   var msg := TTernary<string>.New(x > 100, 'Grande').Pipe(
///     TTernary<string>.New(x = 100, 'Exato').Pipe('Pequeno')
///   );
///
///   Exemplo com Procedures:
///   TTernary<string>.New(ativo, 'Habilitado', procedure begin
///     Label1.Font.Color := clGreen;
///   end).Pipe('Desabilitado', procedure begin
///     Label1.Font.Color := clRed;
///   end);
///
///   Implementação:
///   - Usa Custom Managed Records (Delphi 10.4+)
///   - Implementa Initialize e Finalize para limpeza automática
///   - Suporta tipos genéricos <T> para type-safety
///   - Inline methods para zero overhead
///  </remarks>
{$ENDREGION}

unit TernaryOperator;

interface

type
  /// <summary>
  /// Delegate para ações que não retornam valor
  /// </summary>
  TAction = reference to procedure;

  /// <summary>
  /// Custom Managed Record genérico que representa uma expressão ternária condicional.
  /// Implementa Initialize e Finalize como class operators conforme custom managed records.
  /// Permite sintaxe semelhante ao ternário de C# (limitando-se ao permitido pelo compilador Delphi): TTernary<T>.New(condition, trueValue).Pipe(falseValue)
  /// Suporta encadeamento: TTernary<T>.New(cond1, val1).Pipe(TTernary<T>.New(cond2, val2).Pipe(val3))
  /// Suporta procedures opcionais: TTernary<T>.New(condition, trueValue, procedure).Pipe(falseValue, procedure)
  /// </summary>
  TTernary<T> = record
  private
    FCondition: Boolean;
    FTrue: T;
    FAction: TAction;
  public
    /// <summary>
    /// Class operator Initialize - chamado automaticamente quando o record é criado.
    /// </summary>
    class operator Initialize (out Dest: TTernary<T>);

    /// <summary>
    /// Class operator Finalize - chamado automaticamente quando o record sai de escopo.
    /// Garante limpeza automático de tipos managed mesmo em caso de exceção.
    /// </summary>
    class operator Finalize (var Dest: TTernary<T>);

    /// <summary>
    /// Cria uma nova expressão ternária com valor verdadeiro e procedure opcional.
    /// </summary>
    class function New(ACondition: Boolean; const ATrue: T; AAction: TAction = nil): TTernary<T>; static; inline;

    /// <summary>
    /// Retorna o valor falso (o valor do pipe) e executa procedure opcional.
    /// Pode receber um TTernary<T> para encadeamento (simulando else if).
    /// </summary>
    function Pipe(const AFalse: T; AAction: TAction = nil): T; inline;
  end;

implementation

class operator TTernary<T>.Initialize (out Dest: TTernary<T>);
begin
  Dest.FCondition := False;
  Dest.FAction := nil;
end;

class operator TTernary<T>.Finalize (var Dest: TTernary<T>);
begin
  // Limpeza automática de tipos managed (strings, interfaces, arrays dinâmicos, etc)
end;

class function TTernary<T>.New(ACondition: Boolean; const ATrue: T; AAction: TAction = nil): TTernary<T>;
begin
  Result.FCondition := ACondition;
  Result.FTrue := ATrue;
  Result.FAction := AAction;
end;

function TTernary<T>.Pipe(const AFalse: T; AAction: TAction = nil): T;
begin
  if FCondition then
  begin
    // Condição verdadeira: executa action do New e retorna FTrue
    if Assigned(FAction) then
      FAction();
    Result := FTrue;
  end
  else
  begin
    // Condição falsa: executa action do Pipe e retorna AFalse
    if Assigned(AAction) then
      AAction();
    Result := AFalse;
  end;
end;

end.
