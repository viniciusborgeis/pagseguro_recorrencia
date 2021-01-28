# PagseguroRecorrencia
[![Coverage](badge.svg)](https://github.com/viniciusborgeis/pagseguro_recorrencia)


## <center> :warning: WIP :warning: </center>
### <center> Em desenvolvimento! </center>
</br>

Implementação criada para facilitar a integração com o modo de recorrência do PagSeguro utilizando Ruby on Rails.
Com a GEM se torna fácil fazer as requisições para a API do pagseguro, bastando apenas chamar um método passando um payload com os dados necessário e aguardar a resposta da API do PagSeguro

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
  :code => "200",
  :message => "OK",
  :body => {
    :code => "CDE935E5848427EEE4BFAF846AB2B9E1",
    :date => "2021-01-26T22:19:45-03:00"
  }
}
```

`{:code}`: Código HTTP da requisição

`{:message}`: Mensagem padrão da API do PagSeguro

`{:body}`: Corpo da Resposta

`{:body => {:code}}`: Identificador único(Código) do plano no PagSeguro

`{:body => {:date}}`: Data em que foi criado esse plano

</br>

**Retorno com Error**

```ruby
{
  :code => "400",
  :message => "Bad Request",
  :body => {
    :error => {
      :code => "11088",
      :message => "preApprovalName is required"
    }
  }
}
```

`{:code}`: Código HTTP da requisição

`{:message}`: Mensagem padrão da API do PagSeguro

`{:body}`: Corpo da Resposta

`{:body {:error}}`: Nó contendo corpo do error

`{:body {:error => {:code}}}`: Código do error na API do PagSeguro

`{:body {:error => {:message}}}`: Mensagem com o error
</br>
</br>

## **CRIANDO NOVA SESSÃO**
Para criar ua nova sessão e retornar o SessionID do PagSeguro, basta fazer a chamada do método `PagseguroRecorrencia.new_session` *os dados da sessão vem do initializer que criamos*

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

___


## Contribuições

Quer contribuir com o projeto? Sinta-se a vontade para ser um contribuidor e enviar pull-requests, estou ansioso pela sua implementação https://github.com/viniciusborgeis/pagseguro_recorrencia.

