def stub_new_plan 
  {
    all_fields: {
      url: 'https://ws.sandbox.pagseguro.uol.com.br/pre-approvals/request?email=test@test.com&token=5A9045945CD85239E8F8BDF34532DBA460',
      send_body: '<?xml version="1.0" encoding="ISO-8859-1" standalone="yes"?> <preApprovalRequest> <preApproval> <name>TEST - 1</name> <charge>MANUAL</charge> <period>MONTHLY</period> <cancelURL></cancelURL> <amountPerPayment>200.00</amountPerPayment> <membershipFee>150.00</membershipFee> <trialPeriodDuration>28</trialPeriodDuration> <reference>TEST123</reference> <expiration><value>10</value><unit>MONTHS</unit></expiration> </preApproval> <maxUses>500</maxUses> </preApprovalRequest>',
      headers: {
        'Accept' => 'application/vnd.pagseguro.com.br.v3+xml;charset=ISO-8859-1',
        'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'Content-Type' => 'application/xml;charset=ISO-8859-1',
        'Host' => 'ws.sandbox.pagseguro.uol.com.br',
        'User-Agent' => 'Ruby'
      },
      response_body: '<?xml version="1.0" encoding="ISO-8859-1" standalone="yes"?><preApprovalRequest><code>EBDAC78BB2B2784444A95F81DEFEEA67</code><date>2021-01-26T17:34:48-03:00</date></preApprovalRequest>'
    },
    empty_plan_name: {
      url: 'https://ws.sandbox.pagseguro.uol.com.br/pre-approvals/request?email=test@test.com&token=5A9045945CD85239E8F8BDF34532DBA460',
      send_body: '<?xml version="1.0" encoding="ISO-8859-1" standalone="yes"?> <preApprovalRequest> <preApproval> <name></name> <charge>MANUAL</charge> <period>MONTHLY</period> <cancelURL></cancelURL> <amountPerPayment>200.00</amountPerPayment> <membershipFee>150.00</membershipFee> <trialPeriodDuration>28</trialPeriodDuration> <reference>TEST123</reference> <expiration><value>10</value><unit>MONTHS</unit></expiration> </preApproval> <maxUses>500</maxUses> </preApprovalRequest>',
      headers: {
        'Accept' => 'application/vnd.pagseguro.com.br.v3+xml;charset=ISO-8859-1',
        'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'Content-Type' => 'application/xml;charset=ISO-8859-1',
        'Host' => 'ws.sandbox.pagseguro.uol.com.br',
        'User-Agent' => 'Ruby'
      },
      response_body: '<?xml version="1.0" encoding="ISO-8859-1" standalone="yes"?><errors><error><code>11088</code><message>preApprovalName is required</message></error></errors>'
    }
  }
end