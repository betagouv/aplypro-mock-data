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

WRITE_FOLDER = File.join(File.dirname(__FILE__), "../asp/retour/")

FactoryBot.define do
  factory :csv_factory, class: "CSV" do
    transient do
      payment_request { nil }
      destination { WRITE_FOLDER }
    end

    initialize_with do
      CSV.generate(col_sep: ";", headers: attributes.keys, write_headers: true) do |csv|
        csv << attributes.values
      end
    end

    to_create do |obj, ctx|
      raise ArgumentError, "cannot write the final CSV file without a payment_request param" if ctx.payment_request.nil?

      request = ctx.payment_request.asp_request
      identifier = File.basename(request.file.blob.filename.to_s, ".*")
      filename = FactoryBot.build(:asp_filename, ctx.type, identifier: identifier)

      File.write(File.join(ctx.destination, filename), obj)
    end
  end
end

FactoryBot.define do
  factory :asp_reject, parent: :csv_factory do
    transient do
      reason { "mauvais code postal" }
      type { :rejects }
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
      type { :integrations }
    end

    add_attribute("Numero enregistrement") { payment_request.id }
    add_attribute("idIndDoss") { Faker::Number.unique.number(digits: 5).to_s }
    add_attribute("idIndTiers") { Faker::Number.number(digits: 5).to_s }
    add_attribute("idDoss") { Faker::Number.unique.number(digits: 5).to_s }
    add_attribute("numAdmDoss") { "DOSS" }
    add_attribute("idPretaDoss") { Faker::Number.unique.number(digits: 5).to_s }
    add_attribute("numAdmPrestaDoss") { Faker::Number.number(digits: 5).to_s }
    add_attribute("idIndPrestaDoss") { Faker::Number.number(digits: 5).to_s }
  end
end

# rubocop:disable Metrics/BlockLength
FactoryBot.define do
  factory :asp_payment_file, class: "String" do
    transient do
      builder_class { Nokogiri::XML::Builder }
      payment_request { nil }
      destination { WRITE_FOLDER }
    end

    trait :success do
      payment_state { "PAYE" }
    end

    trait :failed do
      payment_state { "INVALIDE" }

      transient do
        reason { Faker::Lorem.sentence(word_count: 20) }
      end
    end

    initialize_with do
      raise ArgumentError, "the payment request is not integrated" if !payment_request.in_state?(:integrated)

      builder_class.new({ encoding: "UTF-8" }) do |xml|
        xml.listepaiement(xmlns: "http://www.cnasea.fr/fichier") do
          xml.paiement do
            xml.etatpaiement(payment_state)
            xml.listeprestadoss do
              xml.prestadoss do
                xml.idprestadoss(payment_request.pfmp.reload.asp_prestation_dossier_id)
              end
            end

            if payment_state == "INVALIDE"
              xml.codemotifinval("IAL")
              xml.libellemotifinval(reason)
            end
          end
        end
      end.to_xml
    end

    to_create do |obj, ctx|
      filename = FactoryBot.build(:asp_filename, :payments)

      File.write(File.join(ctx.destination, "#{filename}.xml"), obj)
    end
  end
end

FactoryBot.define do
  factory :asp_rectifications_file, class: "String" do
    transient do
      builder_class { Nokogiri::XML::Builder }
      payment_request { nil }
      destination { WRITE_FOLDER }
    end

    trait :success do
      payment_state { "EMIS" }
    end

    trait :failed do
      payment_state { "INVALIDE" }

      transient do
        reason { Faker::Lorem.sentence(word_count: 20) }
      end
    end

    initialize_with do
      raise ArgumentError, "the payment request is not integrated" if !payment_request.in_state?(:integrated)

      builder_class.new({ encoding: "UTF-8" }) do |xml|
        xml.listeor(xmlns: "http://www.cnasea.fr/fichier") do
          xml.ordrereversement do
            xml.etatpaiement(payment_state)
            xml.listeprestadoss do
              xml.prestadoss do
                xml.idprestadoss(payment_request.pfmp.reload.asp_prestation_dossier_id)
              end
            end

            if payment_state == "INVALIDE"
              xml.codemotifor("C1") # Décès (cf RefMotifOR)
              xml.libellemotifor(reason)
            end
          end
        end
      end.to_xml
    end

    to_create do |obj, ctx|
      filename = FactoryBot.build(:asp_filename, :rectifications)

      File.write(File.join(ctx.destination, "#{filename}.xml"), obj)
    end
  end
end


FactoryBot.define do
  factory :asp_filename, class: "String" do
    transient do
      identifier { "foobar" }
    end

    trait :rejects do
      prefix { "rejets_integ_idp_" }
      extension { "csv" }
    end

    trait :integrations do
      prefix { "identifiants_generes_" }
      extension { "csv" }
    end

    trait :payments do
      prefix { "renvoi_paiement_APLYPROMOCK_#{Time.zone.today.to_fs(:number)}" }
      extension { "xml" }
      identifier { "" }

      after(:build) do |_, ctx|
        raise "the attribute `identifier` does not make sense for an ASP payments filename" if ctx.identifier.present?
      end
    end

    trait :rectifications do
      prefix { "renvoi_ordrereversement_APLYPROMOCK_#{Time.zone.today.to_fs(:number)}" }
      extension { "xml" }
      identifier { "" }

      after(:build) do |_, ctx|
        raise "the attribute `identifier` does not make sense for an ASP rectifications filename" if ctx.identifier.present?
      end
    end

    initialize_with do
      "#{prefix}#{identifier}.#{extension}"
    end
  end
end

# rubocop:enable Metrics/BlockLength
