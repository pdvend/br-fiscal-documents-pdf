# frozen_string_literal: true

require 'stringio'

require 'ox'
require 'prawn'
require 'prawn/table'
require 'chunky_png'
require 'rqrcode'
require 'barby'
require 'barby/barcode/code_128'
require 'barby/outputter/png_outputter'
require 'barby/outputter/prawn_outputter'

require 'br_invoices_pdf/version'
require 'br_invoices_pdf/generator'
require 'br_invoices_pdf/errors/invalid_document_type'

module BrInvoicesPdf
  @generators = {}

  module_function

  Ox.default_options = Ox.default_options.merge(encoding: 'windows-1252')

  def generate(type, xml, options = {})
    generator = @generators[type]
    raise(Errors::InvalidDocumentType, type) unless generator
    generator.generate(xml, options)
  end

  def register(type, renderer, parser)
    raise(ArgumentError, "Expected Symbol or String to type. Received #{type.class}") unless valid_type?(type)
    @generators[type.to_sym] = Generator.new(renderer, parser)
  end

  def supported_document_types
    @generators.keys
  end

  def valid_type?(type)
    type.is_a?(String) || type.is_a?(Symbol)
  end
end

require 'br_invoices_pdf/util/xml_locate'
require 'br_invoices_pdf/util/enum'
require 'br_invoices_pdf/cfe'
require 'br_invoices_pdf/nfce'
