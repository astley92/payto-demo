RSpec.describe "buying an item" do
  before do
    allow(Zepto::UIDGenerator).to receive(:call).and_return("my_test_agreement_123", "my_test_payment_456")
    create :item, title: "Mac n Cheese", image_filename: "test/macncheese.png", price_cents: 999
    create :item, title: "Broccoli", image_filename: "test/broccoli.png", price_cents: 123
    create :item, title: "Potato", image_filename: "test/potato.png", price_cents: 1
    create :settlement_account, id: "1"
  end

  scenario "item is bought successfully" do
    visit("/")

    within("#navbar") do
      click_on("Admin Settings")
    end

    fill_in("Account Name", with: "Blake Astley", fill_options: { clear: :backspace })
    fill_in("Branch Code", with: "654321", fill_options: { clear: :backspace })
    fill_in("Account Number", with: "834552", fill_options: { clear: :backspace })
    click_on("Confirm")

    expect(page).to have_text("Settlement account updated successfully")
    expect(page).to have_field("Account Name", with: "Blake Astley")
    expect(page).to have_field("Branch Code", with: "654321")
    expect(page).to have_field("Account Number", with: "834552")

    fill_in("Account Name", with: "Astley Blake")
    fill_in("Branch Code", with: "222222")
    fill_in("Account Number", with: "777777")
    click_on("Confirm")

    expect(page).to have_text("Settlement account updated successfully")
    expect(page).to have_field("Account Name", with: "Astley Blake")
    expect(page).to have_field("Branch Code", with: "222222")
    expect(page).to have_field("Account Number", with: "777777")

    within("#navbar") do
      click_on("Items")
    end

    expect(page).to have_text("Mac n Cheese")
    expect(page).to have_text("$9.99")
    expect(page).to have_text("Broccoli")
    expect(page).to have_text("$1.23")
    expect(page).to have_text("Potato")
    expect(page).to have_text("$0.01")

    within("#potato-item") do
      click_on("Buy")
    end

    fill_in("Account Name", with: "Erlich Bachman")
    fill_in("Branch Code", with: "123456")
    fill_in("Account Number", with: "9876543")
    click_on("Confirm Payment")

    expect(page).to have_text("We're creating an agreement to send to you")

    Command::Purchase::CreateAgreement.drain
    expect(page).to have_text("We've sent an agreement to the bank account")
    expect(Zepto.adapter).to have_created_agreement(
      uid: "my_test_agreement_123",
      debtor_branch_code: "123456",
      creditor_branch_code: "222222",
      amount: 1,
    )

    Zepto.adapter._debtor_accepts_agreement!("my_test_agreement_123")
    Command::Agreement::CheckForApproval.drain
    expect(page).to have_text("Thanks for confirming! We're processing the payment now.")

    Command::Purchase::CreatePayment.drain
    expect(Zepto.adapter).to have_created_payment(
      amount: 1,
      uid: "my_test_payment_456",
      agreement_uid: "my_test_agreement_123",
    )

    Zepto.adapter._settle_payment!("my_test_payment_456")
    Command::Payment::CheckForSettlement.drain
    expect(page).to have_text("Payment processed")
  end

  context "when zepto returns an error creating the agreement" do
    before do
      Zepto.adapter._add_custom_response(
        :create_agreement,
        Zepto::Responses::GenericFailure.new,
      )
    end

    scenario "it shows an appropriate message", :inline_jobs do
      visit("/items")

      within("#potato-item") do
        click_on("Buy")
      end

      fill_in("Account Name", with: "Erlich Bachman")
      fill_in("Branch Code", with: "123456")
      fill_in("Account Number", with: "9876543")
      click_on("Confirm Payment")

      expect(page).to have_text("Something went wrong creating the agreement!")
    end
  end

  context "when zepto returns an error creating the payment" do
    before do
      Zepto.adapter._add_custom_response(
        :create_payment,
        Zepto::Responses::GenericFailure.new,
      )
    end

    scenario "it shows an appropriate message" do
      visit("/items")

      within("#potato-item") do
        click_on("Buy")
      end

      fill_in("Account Name", with: "Erlich Bachman")
      fill_in("Branch Code", with: "123456")
      fill_in("Account Number", with: "9876543")
      click_on("Confirm Payment")
      sleep 0.1

      Command::Purchase::CreateAgreement.drain
      Zepto.adapter._debtor_accepts_agreement!("my_test_agreement_123")
      Sidekiq::Job.drain_all

      expect(page).to have_text("Something went wrong taking payment!")
    end
  end

  context "when zepto returns an error checking the payment" do
    before do
      Zepto.adapter._add_custom_response(
        :fetch_payment,
        Zepto::Responses::GenericFailure.new,
      )
    end

    scenario "it shows an appropriate message" do
      visit("/items")

      within("#potato-item") do
        click_on("Buy")
      end

      fill_in("Account Name", with: "Erlich Bachman")
      fill_in("Branch Code", with: "123456")
      fill_in("Account Number", with: "9876543")
      click_on("Confirm Payment")
      sleep 0.1

      Command::Purchase::CreateAgreement.drain
      Zepto.adapter._debtor_accepts_agreement!("my_test_agreement_123")
      Sidekiq::Job.drain_all

      expect(page).to have_text("Something went wrong taking payment!")
    end
  end

  context "when zepto returns an error checking the agreement" do
    before do
      Zepto.adapter._add_custom_response(
        :fetch_agreement,
        Zepto::Responses::GenericFailure.new,
      )
    end

    scenario "it shows an appropriate message", :inline_jobs do
      visit("/items")

      within("#potato-item") do
        click_on("Buy")
      end

      fill_in("Account Name", with: "Erlich Bachman")
      fill_in("Branch Code", with: "123456")
      fill_in("Account Number", with: "9876543")
      click_on("Confirm Payment")

      expect(page).to have_text("Something went wrong creating the agreement!")
    end
  end
end
