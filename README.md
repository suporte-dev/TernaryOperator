# TernaryOperator
A unit TernaryOperator implementa um operador ternário para Delphi, utilizando Custom Managed Records (Delphi 10.4+).

## Propósito

Fornecer uma sintaxe concisa e type-safe para expressões condicionais, permitindo:

- **Substituir `if-then-else` simples** por expressões ternárias
- **Encadear múltiplas condições** (if-else if-else)
- **Executar procedures** como efeitos colaterais
- **Manter type-safety** com genéricos

## Requisitos

- **Delphi 10.4+** (suporte a Custom Managed Records)
- Compilação em modo de 64 bits recomendado

## Componentes

### `TAction` - Delegate

```delphi
TAction = reference to procedure;
```

Define um delegate para procedures sem retorno. Usado para encapsular efeitos colaterais opcionais.

### `TTernary<T>` - Record Genérico

Custom Managed Record que implementa o operador ternário.

#### Campos Privados

- `FCondition: Boolean` - Armazena a condição avaliada
- `FTrue: T` - Armazena o valor para condição verdadeira
- `FAction: TAction` - Armazena a procedure opcional

#### Métodos

##### `class operator Initialize`

```delphi
class operator Initialize (out Dest: TTernary<T>);
```

Chamado automaticamente quando o record é criado. Inicializa os campos com valores padrão.

**Efeito**: Garante estado consistente ao criar um novo `TTernary<T>`.

##### `class operator Finalize`

```delphi
class operator Finalize (var Dest: TTernary<T>);
```

Chamado automaticamente quando o record sai de escopo. Responsável pela limpeza automática de tipos managed (strings, interfaces, arrays dinâmicos).

**Efeito**: Garante limpeza mesmo em caso de exceção (try-finally automático).

##### `class function New` 

```delphi
class function New(ACondition: Boolean; const ATrue: T; AAction: TAction = nil): TTernary<T>; static; inline;
```

Factory method que cria uma nova expressão ternária.

**Parâmetros:**
- `ACondition: Boolean` - A condição a ser avaliada
- `ATrue: T` - Valor retornado se condição é verdadeira
- `AAction: TAction = nil` - Procedure opcional a executar de acordo com a condição pretendida para uma ação que tando pode ser em True ou False, como demonstrado no exemplo.

**Retorno:** `TTernary<T>` com a condição e valores configurados

**Exemplo:**
```delphi
var resultado := TTernary<string>.New(idade > 18, 'Maior');
```

##### `function Pipe`

```delphi
function Pipe(const AFalse: T; AAction: TAction = nil): T; inline;
```

Executa a avaliação do ternário e retorna o valor apropriado.

**Parâmetros:**
- `AFalse: T` - Valor retornado se condição é falsa
- `AAction: TAction = nil` - Procedure opcional a executar se condição é falsa

**Retorno:** Valor de `FTrue` (de `New`) se condição é verdadeira, ou `AFalse` caso contrário

**Comportamento:**
1. Se `FCondition` é `true`: executa `FAction` (se definida) e retorna `FTrue`
2. Se `FCondition` é `false`: executa `AAction` (se definida) e retorna `AFalse`

**Exemplo:**
```delphi
var status := TTernary<string>.New(ativo, 'Ativo').Pipe('Inativo');
```

## Exemplos de Uso

### Exemplo 1: Básico - Sem Procedures

```delphi
var
  idade: Integer := 25;
  categoriaIdade: string;
begin
  categoriaIdade := TTernary<string>.New(idade >= 18, 'Maior').Pipe('Menor');
  ShowMessage(categoriaIdade);  // Mostra: "Maior"
end;
```

### Exemplo 2: Com Procedures - Efeitos Colaterais (demo)

```delphi
procedure TFormPrincipal.CheckBoxHabilitadoClick(Sender: TObject);
begin
  TTernary<string>.New(CheckBoxHabilitado.Checked,
    'Habilitado',
    procedure
    begin
      LabelStatus.Font.Color := clGreen;
      LabelStatus.Caption := 'Habilitado - Checked';
    end).Pipe('Desabilitado',
    procedure
    begin
      LabelStatus.Font.Color := clRed;
      LabelStatus.Caption := 'Desabilitado - Unchecked';
    end);
end;
```

### Exemplo 3: Encadeamento - Múltiplas Condições

```delphi
var
  valor: Integer := 50;
  classificacao: string;
begin
  classificacao := TTernary<string>.New(valor > 100, 'Grande').Pipe(
    TTernary<string>.New(valor = 100, 'Exato').Pipe('Pequeno')
  );
  ShowMessage(classificacao);  // Mostra: "Pequeno"
end;
```

### Exemplo 4: Encadeamento com Procedures

```delphi
procedure TFormPrincipal.AvaliarValor;
var
  valor: Integer := 75;
  resultado: string;
begin
  resultado := TTernary<string>.New(valor > 100,
    Format('Valor %d é grande', [valor]),
    procedure
    begin
      ProgressBar1.Position := 100;
    end).Pipe(TTernary<string>.New(valor = 100,
    Format('Valor %d é exato', [valor]),
    procedure
    begin
      ProgressBar1.Position := 100;
    end).Pipe(Format('Valor %d é pequeno', [valor]),
    procedure
    begin
      ProgressBar1.Position := valor;
    end));
  
  LabelResultado.Caption := resultado;
end;
```

### Exemplo 5: Com Tipos Diferentes

```delphi
var
  idade: Integer := 25;
  categoriaIdade: string;
  desconto: Double;
begin
  // String
  categoriaIdade := TTernary<string>.New(idade >= 18, 'Adulto').Pipe('Menor');
  
  // Integer
  var nivelAcesso := TTernary<Integer>.New(idade >= 21, 5).Pipe(3);
  
  // Double
  desconto := TTernary<Double>.New(idade >= 60, 0.20).Pipe(0.10);
end;
```

## Padrões de Uso

### Padrão 1: Valor Simples (Recomendado para Casos Simples)

```delphi
var status := TTernary<string>.New(ativo, 'Ativo').Pipe('Inativo');
Label1.Caption := status;
```

### Padrão 2: Apenas Efeitos Colaterais (Sem Retorno Usado)

```delphi
TTernary<string>.New(ativo, 'dummy',
  procedure
  begin
    // Faça algo
  end).Pipe('dummy',
  procedure
  begin
    // Faça algo diferente
  end);
```

### Padrão 3: Valor + Efeitos Colaterais

```delphi
var resultado := TTernary<string>.New(condicao, 'ValorA',
  procedure
  begin
    // Efeito A
  end).Pipe('ValorB',
  procedure
  begin
    // Efeito B
  end);

Label1.Caption := resultado;
```

### Padrão 4: Múltiplas Condições (if-else if-else)

```delphi
var resultado := TTernary<string>.New(condicao1, 'Valor1').Pipe(
  TTernary<string>.New(condicao2, 'Valor2').Pipe(
    TTernary<string>.New(condicao3, 'Valor3').Pipe('ValorPadrao')
  )
);
```

## Detalhes de Implementação

### Custom Managed Records

A unit utiliza **Custom Managed Records** do Delphi 10.4+:

- **Initialize**: Garante inicialização automática
- **Finalize**: Limpeza automática com suporte a exceções
- Sem alocação em heap (stack-based)
- Suporte completo a tipos managed (strings, interfaces)

### Type Safety

Utiliza genéricos `<T>` para garantir type-safety em tempo de compilação:

```delphi
// Correto
var s := TTernary<string>.New(true, 'Texto').Pipe('Outro');

// Erro: Type mismatch
var s := TTernary<string>.New(true, 'Texto').Pipe(123);
```

### Performance

- Métodos `inline` para zero overhead
- Stack allocation (sem GC)
- Sem boxing/unboxing para tipos value

## Limitações e Considerações

### Sintaxe Limitada

Delphi não permite sobrecarregar os operadores `?` e `:`, então:

- **C#**: `condicao ? Valor-para-True : Valor-para-False`
- **Delphi**: `TTernary<T>.New(condicao, valor1).Pipe(valor2)`

### Procedures Sempre Executam

Ao encadear `TTernary`, **todas as procedures no caminho são executadas**:

```delphi
// Ambas as procedures são executadas se condicao = false
TTernary<string>.New(condicao, 'A', procedure begin WriteLn('A'); end)
  .Pipe(TTernary<string>.New(condicao2, 'B', procedure begin WriteLn('B'); end)
    .Pipe('C', procedure begin WriteLn('C'); end));
```

**Solução**: Coloque `ShowMessage` ou operações críticas **fora** das procedures:

```delphi
var resultado := TTernary<string>.New(condicao, 'A',
  procedure begin
    Label1.Caption := 'A'; // OK: apenas UI
  end).Pipe('B');

ShowMessage(resultado);  // ShowMessage aqui, não dentro da procedure
```

## Comparação com Alternativas

| Abordagem | Sintaxe | Legibilidade | Segurança | Performance |
|-----------|---------|--------------|-----------|-------------|
| `if-then-else` | Longa | Boa | Excelente | Excelente |
| `IfThen` RTL | `IfThen(cond, A, B)` | Boa | Boa | Excelente |
| `TTernary` | `TTernary<T>.New(cond, A).Pipe(B)` | Excelente | Excelente | Excelente |

## Boas Práticas

1. **Use para decisões simples**: 2-3 opções no máximo
2. **Encadeie com cautela**: Mais de 3 níveis fica complexo
3. **Evite lógica pesada**: Use procedures para efeitos colaterais simples
4. **Sempre use tipos genéricos**: Deixe o compilador verificar tipos
5. **Teste procedures separadamente**: Elas executam mesmo em encadeamentos

## Troubleshooting

### Problema: "Type parameters not allowed on global procedure"

**Solução**: Usando Delphi 10.3 ou anterior? Atualize para 10.4+.

### Problema: Procedures executam múltiplas vezes

**Solução**: É o comportamento esperado em encadeamentos. No caso do exemplo, Movi `ShowMessage` para fora.

### Problema: Tipo não encontrado

**Solução**: Adicione `uses TernaryOperator;` no arquivo.

## Arquivos Relacionados

- `TernaryOperator.pas` - Unit principal
- `Uprincipal.pas` - Exemplos básicos, com sobreposição e procedures

## Versão

- **Versão**: 1.0
- **Compatibilidade**: Delphi 10.4+
- **Autor**: A. S. Santos (suporte-dev)

## Licença

MIT.
