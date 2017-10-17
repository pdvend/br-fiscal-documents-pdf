# frozen_string_literal: true

require 'br_invoices_pdf/nfce/parser/company'
require 'br_invoices_pdf/nfce/parser/products'
require 'br_invoices_pdf/nfce/parser/payments'
require 'br_invoices_pdf/nfce/parser/customer'
require 'br_invoices_pdf/nfce/parser/totals'
require 'br_invoices_pdf/nfce/parser/additional_info'
require 'br_invoices_pdf/nfce/parser/emission_details'

module BrInvoicesPdf
  module Nfce
    module Parser
      module_function

      PARSERS = {
        company: Company,
        products: Products,
        payments: Payments,
        customer: Customer,
        totals: Totals,
        additional_info: AdditionalInfo,
        emission_details: EmissionDetails
      }.freeze

      def parse(xml)
        PARSERS.reduce({}) do |response, (param, parser)|
          { **response, param => parser.execute(xml) }
        end
      end
    end
  end
end
