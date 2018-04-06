Rails.configuration.stripe = {
  :publishable_key => 'pk_test_vRg5hUDpsSlMRDKFJcjSYudI',
  :secret_key => 'sk_test_shz11oyCr17pt8E6LOYGJSEn'
}
Stripe.api_key = Rails.configuration.stripe[:secret_key]
