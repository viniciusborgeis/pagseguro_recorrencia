# PagseguroRecorrencia
[![Coverage](badge.svg)](https://github.com/viniciusborgeis/pagseguro_recorrencia)


## <center> :warning: WIP :warning: </center>
### <center> Em desenvolvimento! </center>
</br>

Implementação criada para facilitar a integração com o modo de recorrência do **PagSeguro** utilizando Ruby puro ou Ruby on Rails.
Com a GEM se torna fácil fazer as requisições para a API do pagseguro, bastando apenas setar as configurações iniciais e os métodos passando um payload caso esse método exija um com os dados necessário e aguardar a resposta da API do **PagSeguro**.

</br>

## Instalação

Adicione essa linha ao seu Gemfile:

```ruby
gem 'pagseguro_recorrencia'
```

Então execute:

    $ bundle install

Ou instale diretamente com:

    $ gem install pagseguro_recorrencia


___

## Configuração

Dentro da sua aplicação Rails crie um initializer chamado `pagseguro_recorrencia.rb` com o seguinte código:

```ruby
# config/initializers/pagseguro_recorrencia.rb

PagseguroRecorrencia::PagCore.configure do |config|
  config.credential_email = 'EMAIL_DO_PAGSEGURO'
  config.credential_token = 'TOKEN_DO_PAGSEGURO'
  config.environment = :sandbox # :sandbox ou :production
  config.cancel_url = nil # url que redireciona para a página de cancelamento
end

```
*ou caso esteja utilizando ruby puro, basta apenas fazer essa configuração antes de fazer as chamadas dos métodos da GEM*

___

## Como usar

Após configurar basta apenas chamar o módulo `PagseguroRecorrencia` seguido do método da chamada, passando os dados necessários para que a chamada na API do PagSeguro seja feita. Observe o exemplo abaixo da chamada para criação de um novo plano, passando um **payload** como argumento.

```ruby
payload = {
      plan_name: 'TEST - 1',
      charge_type: :manual,
      period: :monthly,
      cancel_url: '',
      amount_per_payment: '200.00',
      membership_fee: '150.00',
      trial_period_duration: '28',
      expiration_value: '10',
      expiration_unit: :months,
      max_uses: '500',
      plan_identifier: 'TEST123'
    }
@return_data = PagseguroRecorrencia.new_plan payload

```

___

## Documentação

como mostrado na sessão acima, as chamadas a api do PagSeguro são feitas através de metodos público da nossa GEM, abaixo listarei as chamadas dos métodos e explicarei cada campo setados nos requests que precisam dos **payloads**.

- [Criando novo Plano](#criando-novo-plano)
  - [Explicando Payload](#explicando-payload-campos-com--são-obriatórios)
- [Criando nova Sessão](#criando-nova-sessão)
- [Buscando Bandeira do Cartão](#buscando-bandeira-do-cartão)
- [Gerando novo Token para o Cartão](#gerando-novo-token-para-o-cartão)

___
## **CRIANDO NOVO PLANO**

Para criar um novo plano, sete um payload com os dados necessários faça a chamada do método `PagseguroRecorrencia.new_plan(payload)`

```ruby
payload = {
      plan_name: 'TEST - 1',
      charge_type: :manual,
      period: :monthly,
      cancel_url: '',
      amount_per_payment: '200.00',
      membership_fee: '150.00',
      trial_period_duration: '28',
      expiration_value: '10',
      expiration_unit: :months,
      max_uses: '500',
      plan_identifier: 'TEST123'
    }
@return_data = PagseguroRecorrencia.new_plan payload

```
</br>

### **EXPLICANDO PAYLOAD** *campos com * são obriatórios*
</br>

`*plan_name:string` - Nome do plano a ser criado

`*charge_type:symbol` - Indica o modelo do pagamento recorrente **[:manual :auto]**

`*period:symbol` - Periodicidade da cobrança **[:weekly :monthly :bimonthly :trimonthly :semiannually :yearly]**

`cancel_url:string` - Determina a URL para a qual o comprador será redirecionado ao cancelar a recorrência diretamente em sua conta PagSeguro

`*amount_per_payment:string` - Valor exato de cada cobrança - Formato: Decimal, com duas casas decimais separadas por ponto (p.e, 1234.56). Deve ser um valor maior ou igual a 1.00 e menor ou igual a 2000.00

`membership_fee:string` - Valor da taxa de adesão/matricula. Sempre será cobrada juntamente com a primeira parcela do pagamento, independente se o plano é pré-pago ou pós-pago.

`trial_period_duration:string` - Período de teste, em dias. A recorrência mantém o status de iniciada durante o período de testes, de modo que a primeira cobrança só ocorrerá após esse período.

`expiration_value:string` - Número de cobranças até que a recorrência expire.

`expiration_unit:string` - Período em que a recorrência expira.

`max_uses:string` - Quantidade máxima de uso do plano

`plan_identifier:string` - Código de referência da assinatura no sistema

</br>

**Retorno com sucesso**

```ruby
{
  :code => "200", # Código HTTP da requisição
  :message => "OK", # Mensagem padrão da API do PagSeguro
  :body => { # Corpo da Resposta
    :code => "CDE935E5848427EEE4BFAF846AB2B9E1", # Identificador único(Código) do plano no PagSeguro
    :date => "2021-01-26T22:19:45-03:00" # Data em que foi criado esse plano
  }
}
```

</br>

**Retorno com Error**

```ruby
{
  :code => "400", # Código HTTP da requisição
  :message => "Bad Request", # Mensagem padrão da API do PagSeguro
  :body => { # Corpo da Resposta
    :error => { #  Nó contendo corpo do error
      :code => "11088", # Código do error na API do PagSeguro
      :message => "preApprovalName is required" # Mensagem explicando o error
    }
  }
}
```
</br>
</br>

## **CRIANDO NOVA SESSÃO**
:warning: **ATENÇÃO!**: Não é necessário fazer essa chamada para nenhuma requisição utilizando essa GEM, estou apenas documentando a chamada desse método para ficar claro a forma como o método é chamado. A GEM foi construída para fazer esse passo de forma **automática!** Portanto caso você não tenha iniciado uma sessão e não possua um **session_id** setado quando for fazer alguma chamada para algum método que necessite do **session_id** a GEM fará a verificação para saber se há um **session_id** válido, caso não haja, ela sozinha ira requisitar um novo **session_id** e adicionara o mesmo as chamadas dos métodos que forem necessários


Para criar uma nova sessão e retornar o SessionID do **PagSeguro**, basta fazer a chamada do método `PagseguroRecorrencia.new_session` *os dados da sessão vem do initializer que criamos*

**Exemplo:**

```ruby
@return_data = PagseguroRecorrencia.new_session
```
</br>

**Retorno com sucesso**

```ruby
{
  :code=>"200",
  :message=>"OK",
  :body=> {
    :session=> {
      :id=>"b193453ff3e44371a9780113825cedf7"
    }
  }
}
```
</br>

**Retorno com Dados Inválidos**

```ruby
{
  :code=>"401", 
  :message=>"Unauthorized",
  :body=>"Unauthorized"
}
```
</br>
</br>

## **Buscando Bandeira do Cartão**
Para buscar a bandeira do cartão é muito simples, basta pegar os **6 primeiros** numeros do cartão, que é chamado de **código bin** e chamar o método `PagseguroRecorrencia.get_card_brand(bin)` passando o **código bin** como parâmetro da função.

**Exemplo:**

```ruby
bin = 411111
@return_data = PagseguroRecorrencia.get_card_brand(bin)
```
</br>

**Retorno com sucesso**

```ruby
{
  :code=> "200",
  :message=> "OK",
  :body=> {
    :bin=> {
      :length=> nil,
      :country=> {
        :name=> "Brazil",
        :id=> 76,
        :iso_code=> "BR",
        :iso_code_three_digits=>"BRA"
      },
      :validation_algorithm=> "LUHN",
      :bank=> nil,
      :brand=> {
        :name=> "mastercard"
      },
      :bin=> 513210,
      :cvv_size=> 3,
      :expirable=> "y",
      :card_level=> nil,
      :status_message=> "Success",
      :reason_message=> nil
    }
  }
}
```
</br>

**Retorno com Bin menor que 6 digitos**

```ruby
{
  :code=> "400",
  :message=> "Bad Request",
  :body=> {
    :error_details=> {
      :http_status=> 400,
      :reason_message=> "CreditCard Number invalid for bin=513 description=String index out of range: 6"
    }
  }
}
```

**Retorno com Bin inválido**

```ruby
{
  :code=> "200",
  :message=> "OK",
  :body=> { 
    :status_message=> "Error",
    :reason_message=> "Bin not found"
  }
}
```

</br>
</br>

## **Gerando novo Token para o Cartão**
As requisições de pagamento exigem que seja enviado como parâmetro o token do cartão de crédito, que são os dados do pagamento compilados em um Hash. Para gerar um novo token do cartão basta fazer a chamada do método `PagseguroRecorrencia.new_card_token(payload)` passando um payload com os dados necessários!

**Exemplo:**

```ruby
payload = {
  amount: '100.00',
  card_number: '5132103426888543',
  card_brand: 'mastercard',
  card_cvv: '534',
  card_expiration_month: '05',
  card_expiration_year: '2022'
}

@return_data = PagseguroRecorrencia.new_card_token(payload)
```
</br>

### **EXPLICANDO PAYLOAD** *campos com * são obriatórios*
</br>

`*amount:string` - Valor com 2 casas decimais separado por ponto 10.00

`*card_number:string` - Número completo do cartão sem espaços ou pontos

`*card_brand:string` - bandeira do cartão

`*card_cvv:string` -Código de segurança do cartão

`*card_expiration_month:string` - mês de validade do cartão com **2 dígitos**

`*card_expiration_year:string` - ano de validade do cartão com **4 dígitos**

</br>

**Retorno com sucesso**

```ruby
{
  :code=> "200", 
  :message=> "OK",
  :body=> {
    :card=> {
      :token=> "b01bb5eee6904fce9cbef20d06f6dc8d"
    }
  }
}
```
</br>

**Retorno com dados inválidos**

```ruby
{
  :code=> "200",
  :message=> "OK",
  :body=> {
    :error=> {
      :code=> "30400",
      :message=> "invalid creditcard data"
    }
  }
}
```

</br>
</br>

___


## Contribuições

Quer contribuir com o projeto? Sinta-se a vontade para ser um contribuidor e enviar pull-requests, estou ansioso pela sua implementação https://github.com/viniciusborgeis/pagseguro_recorrencia.

