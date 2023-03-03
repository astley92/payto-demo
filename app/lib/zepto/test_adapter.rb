class Zepto::TestAdapter
  def initialize
    @created_agreements = []
    @created_payments = []
    @configured_responses = []
  end

  def create_agreement(
      uid:,
      debtor_account_name:,
      debtor_branch_code:,
      debtor_account_number:,
      creditor_account_name:,
      creditor_branch_code:,
      creditor_account_number:,
      amount:,
      description:)

    configured_response = _pull_next_configured_response(:create_agreement)
    return configured_response unless configured_response.nil?

    @created_agreements << {
      uid: uid,
      debtor_account_name: debtor_account_name,
      debtor_branch_code: debtor_branch_code,
      debtor_account_number: debtor_account_number,
      creditor_account_name: creditor_account_name,
      creditor_branch_code: creditor_branch_code,
      creditor_account_number: creditor_account_name,
      amount: amount,
      description: description,
    }

    return Zepto::Responses::GenericSuccess.new
  end

  def create_payment(uid:, amount:, agreement_uid:, description:)
    configured_response = _pull_next_configured_response(:create_payment)
    return configured_response unless configured_response.nil?

    @created_payments << {
      uid: uid,
      amount: amount,
      agreement_uid: agreement_uid,
      description: description,
    }

    return Zepto::Responses::GenericSuccess.new
  end

  def fetch_agreement(agreement_id)
    configured_response = _pull_next_configured_response(:fetch_agreement)
    return configured_response unless configured_response.nil?

    agreement = @created_agreements.detect { _1[:uid] == agreement_id }
    raise ArgumentError, "Zepto has no record of agreement #{agreement_id}" if agreement.nil?

    return Zepto::Responses::Agreement.new(state: agreement.fetch(:state, :pending))
  end

  def fetch_payment(payment_id)
    configured_response = _pull_next_configured_response(:fetch_payment)
    return configured_response unless configured_response.nil?

    payment = @created_payments.detect { _1[:uid] == payment_id }
    raise ArgumentError, "Zepto has no record of payment #{payment_id}" if payment.nil?

    return Zepto::Responses::Payment.new(state: payment.fetch(:state, :pending))
  end

  ### TEST METHODS

  def has_created_agreement?(**agreement_attrs)
    @created_agreements.any? do |agreement|
      agreement_attrs.all? { |key, value| agreement[key] == value }
    end
  end

  def has_created_payment?(**payment_attrs)
    @created_payments.any? do |payment|
      payment_attrs.all? { |key, value| payment[key] == value }
    end
  end

  def _debtor_accepts_agreement!(agreement_id)
    agreement = @created_agreements.detect { _1[:uid] == agreement_id }
    raise ArgumentError, "#{agreement_id} has not been created with Zepto." if agreement.nil?

    agreement[:state] = :active
  end

  def _settle_payment!(payment_id)
    payment = @created_payments.detect { _1[:uid] == payment_id }
    raise ArgumentError, "#{payment_id} has not been created with Zepto." if payment.nil?

    payment[:state] = :settled
  end

  def _create_agreement!(agreement_params)
    @created_agreements << agreement_params
  end

  def _create_payment!(payment_params)
    @created_payments << payment_params
  end

  def _add_custom_response(method_name, response)
    @configured_responses << { method_name: method_name, response: response }
  end

  def _pull_next_configured_response(method_name)
    result = @configured_responses.detect { _1[:method_name] == method_name }
    return if result.nil?

    @configured_responses.delete(result)
    result[:response]
  end
end
