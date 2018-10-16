# README

## CONFIGS

All this example keys are fake, use your real keys
```
aws:
  access_key_id: JYUETRVGDHGYWDGHJFHGVZXSF
  secret_access_key: LLHKJGFJHGVD2837492387492374sdfGHG

# Used as the base secret for all MessageVerifiers in Rails, including the one protecting cookies.
secret_key_base: lsdhfaafue87978987aaf1a555015ad71268fe753db5228adcd797de390c8cde7015cd4fbf05da17ef213d1f8b9e389ca7d025e5263ae4786ffd6add

encryptor_key: "this_is-encryptor-key_to-encrypt_messages"
len: 32
# Make sure this is 32 bytes
encryptor_salt: "94742886492138477408233266252531"

# app key
paybear_secret: secaalsdkfj98749827394872394872938

twilio_account_sid: 'ASDF2342343948839274928374932'
twilio_auth_token: '3804850759872089748937489892374'
twilio_phone_number: '+1234567890'
```

## SETUP

`rake payout:check => daily`
`rake rate:run => hourly`
`rake rate_crypto:run => 10 minutes`
`rake investment:status_check => hourly or daily`
