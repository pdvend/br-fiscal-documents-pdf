module BrInvoicesPdf
  module Cfe
    module Renderer
      module BaseRenderer
        module_function

        ADDRESS_FORMAT = '%s, %s, %s, %s, %s/%s'.freeze
        def format_address(address)
          ADDRESS_FORMAT % %i[public_place number complement neighborhood city state].map(&address.method(:[]))
        end

        def box(pdf, position, width)
          pdf.bounding_box(position, width: width) do
            pdf.pad(2) do
              pdf.indent(2, 2) do
                yield
              end
            end

            pdf.stroke_bounds
          end
        end

        def pdf_setup(pdf)
          pdf.bounding_box([0, pdf.cursor], width: page_content_width(pdf)) do
            pdf.pad(10) do
              pdf.indent(10, 10) do
                yield
              end
            end
            pdf.stroke_bounds
          end
        end

        CNPJ_FORMAT = '%d.%d.%d/%d-%d'.freeze
        # :reek:FeatureEnvy
        def format_cnpj(cnpj)
          format(CNPJ_FORMAT, cnpj[0, 2], cnpj[2, 3], cnpj[5, 3], cnpj[8, 4], cnpj[12, 2])
        end

        # :reek:FeatureEnvy
        def format_currency(num)
          num.truncate.to_s.reverse.split(/.../).join('.').reverse + format(',%02d', (num.frac * 100).truncate)
        end

        # :reek:FeatureEnvy
        def format_number(num, prec: 4)
          num.truncate.to_s + (prec > 0 ? format(",%0#{prec}d", (num.frac * 10**prec).truncate) : '')
        end

        # :reek:FeatureEnvy
        def page_paper_width(name)
          (name.is_a?(Array) ? name : PDF::Core::PageGeometry::SIZES[name]).first
        end

        # :reek:FeatureEnvy
        def page_content_width(pdf)
          page = pdf.page
          margins = page.margins
          page_paper_width(page.size) - margins[:left] - margins[:right]
        end
      end
    end
  end
end
