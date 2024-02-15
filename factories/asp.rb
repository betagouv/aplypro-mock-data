# frozen_string_literal: true

require "csv"
require "faker"
require "factory_bot"

# This can be used to generate some fake CSV files:

# In the main app's console:
#
# irb> load 'mock/factories/asp.rb'
#
# irb> FactoryBot.create(:asp_integration, payment_request: ASP::PaymentRequest.find(4))
#
# This will use the request object to generate the corresponding CSV
# return file in the `mock/asp/retour` folder.
FactoryBot.define do
  factory :csv_factory, class: "CSV" do
    transient do
      payment_request { nil }
      destination { File.join(File.dirname(__FILE__), "../asp/retour/") }
    end

    initialize_with do
      CSV.generate(col_sep: ";", headers: attributes.keys, write_headers: true) do |csv|
        csv << attributes.values
      end
    end

    to_create do |obj, ctx|
      raise ArgumentError, "cannot write the final CSV file without a payment_request param" if ctx.payment_request.nil?

      request = ctx.payment_request.asp_request

      filename = File.basename(request.file.blob.filename.to_s, ".*")

      File.write(File.join(ctx.destination, "#{ctx.prefix}#{filename}.csv"), obj)
    end
  end
end

FactoryBot.define do
  factory :asp_reject, parent: :csv_factory do
    transient do
      reason { "mauvais code postal" }
      prefix { "rejets_integ_idp_" }
    end

    add_attribute("Numéro d'enregistrement") { payment_request.id }
    add_attribute("Type d'entité") { "foo" }
    add_attribute("Numadm") { "foo" }
    add_attribute("Motif rejet") { reason }
    add_attribute("idIndDoublon") { "foo" }
  end
end

FactoryBot.define do
  factory :asp_integration, parent: :csv_factory do
    transient do
      prefix { "identifiants_generes_" }
    end

    add_attribute("Numero enregistrement") { payment_request.id }
    add_attribute("idIndDoss") { Faker::Number.number(digits: 5).to_s }
    add_attribute("idIndTiers") { Faker::Number.number(digits: 5).to_s }
    add_attribute("idDoss") { Faker::Number.number(digits: 5).to_s }
    add_attribute("numAdmDoss") { "DOSS" }
    add_attribute("idPretaDoss") { Faker::Number.number(digits: 5).to_s }
    add_attribute("numAdmPrestaDoss") { Faker::Number.number(digits: 5).to_s }
    add_attribute("idIndPrestaDoss") { Faker::Number.number(digits: 5).to_s }
  end
end
