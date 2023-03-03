class Zepto::RealAdapter
  def create_agreement(
      uid:,
      debtor_account_name:,
      debtor_branch_code:,
      debtor_account_number:,
      creditor_account_name:,
      creditor_branch_code:,
      creditor_account_number:,
      amount:,
      description:
    )

    params = {
      uid: uid,
      purpose: "retail",
      debtor: {
        party_name: debtor_account_name,
        account_identifier: {
          type: "bban",
          value: "#{debtor_branch_code}-#{debtor_account_number}"
        }
      },
      creditor: {
        party_name: creditor_account_name,
        account_identifier: {
          type: "bban",
          value: "#{creditor_branch_code}-#{creditor_account_number}"
        }
      },
      description: "Zepto demo application's agreement to take payment for #{description}",
      validity_end_date: (Time.now + 2.days).strftime("%Y-%m-%d"),
      payment_terms: {
        type: "fixed",
        frequency: "adhoc",
        amount: amount,
        count: 1
      },
    }

    response = client.post("payto/agreements") do |req|
      req.body = params.to_json
    end

    if response.status == 201
      return Zepto::Responses::GenericSuccess.new
    else
      return Zepto::Responses::GenericFailure.new
    end
  end

  def create_payment(uid:, amount:, agreement_uid:, description:)
    params = {
      uid: uid,
      agreement_uid: agreement_uid,
      amount: amount,
      priority: "unattended",
      description: "Payment for #{description}",
    }

    response = client.post("payto/payments") do |req|
      req.body = params.to_json
    end

    if response.status == 201
      return Zepto::Responses::GenericSuccess.new
    else
      return Zepto::Responses::GenericFailure.new
    end
  end

  def fetch_agreement(agreement_id)
    response = client.get("payto/agreements/#{agreement_id}")
    if response.status == 200
      return Zepto::Responses::Agreement.new(
        state: JSON.parse(response.body, symbolize_names: true).dig(:data, :state).to_sym,
      )
    else
      return Zepto::Responses::GenericFailure.new
    end
  end

  def fetch_payment(payment_id)
    response = client.get("payto/payments/#{payment_id}")
    if response.status == 200
      return Zepto::Responses::Payment.new(
        state: JSON.parse(response.body, symbolize_names: true).dig(:data, :state).to_sym,
      )
    else
      return Zepto::Responses::GenericFailure.new
    end
  end

  private

  def client
    @client ||= Faraday.new(
      url: zepto_base_url,
      headers: {
        "Authorization" => "Bearer #{Figaro.env.ZEPTO_API_KEY}",
        "Content-type" => "application/json",
        "Accept" => "application/json",
      }
    )
  end

  def zepto_base_url
    if Figaro.env.ZEPTO_ENVIRONMENT == "sandbox"
      "https://api.sandbox.split.cash/"
    else
      "https://api.split.cash/"
    end
  end
end
