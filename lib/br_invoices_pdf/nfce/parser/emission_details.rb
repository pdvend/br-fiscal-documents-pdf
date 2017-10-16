# frozen_string_literal: true

module BrInvoicesPdf
  module Nfce
    module Parser
      module EmissionDetails
        extend Util::XmlLocate

        module_function

        EMISSION_ROOT_PATH = Util::XmlLocate::ROOT_PATH.freeze

        EMISSION_TYPES = {
          '1': 'Emissão normal',
          '2': 'Contingência FS-IA',
          '3': 'Contingência SCAN',
          '4': 'Contingência DPEC',
          '5': 'Contingência FS-DA, com impressão do DANFE em formulário de segurança',
          '6': 'Contingência SVC-AN',
          '7': 'Contingência SVC-RS',
          '9': 'Contingência off-line da NFC-e'
        }.freeze

        def execute(xml)
          {
            type: EMISSION_TYPES[locate_element(xml, "#{EMISSION_ROOT_PATH}/tpEmis").to_sym],
            number: locate_element(xml, "#{EMISSION_ROOT_PATH}/nNF"),
            serie: locate_element(xml, "#{EMISSION_ROOT_PATH}/serie"),
            emission_timestamp: locate_element_to_date(xml, "#{EMISSION_ROOT_PATH}/dhEmi"),
            receival_timestamp: locate_element_to_date(xml, 'protNFe/infProt/dhRecbto'),
            # TODO: Identificar como pegar esse valor
            check_url: nil,
            access_key: locate_element(xml, 'protNFe/infProt/chNFe'),
            qrcode_url: xml.locate('NFe/infNFeSupl/qrCode').first.nodes.first.value,
            authorization_protocol: locate_element(xml, 'protNFe/infProt/nProt')
          }
        end

        def locate_element_to_date(xml, path)
          Time.new(locate_element(xml, path)).utc
        end
      end
    end
  end
end