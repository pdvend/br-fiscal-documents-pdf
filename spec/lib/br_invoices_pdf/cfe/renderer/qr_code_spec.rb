# frozen_string_literal: true

describe BrInvoicesPdf::Cfe::Renderer::QrCode do
  describe '.execute' do
    subject { described_class.execute(pdf, data) }
    let(:pdf) do
      double('pdf', cursor: cursor, page_size: page_size, page: page,
                    bounding_box: '', box: double)
    end
    let(:cursor) { 10 }
    let(:page_size) { 640 }
    let(:page_width) { 100.999 }
    let(:qr_code_size) { (page_width * 0.65).to_i }
    let(:page) { double(margins: { left: 1, right: 1 }, size_with: 1, size: 'A4') }
    let(:data) do
      { access_key: access_key, sat_params: sat_params, payment: payment,
        company_attributes: company_attributes }
    end
    let(:sat_params) do
      {
        emission_date: '2017-07-01',
        emission_hour: '20',
        document_qr_code_signature: '123'
      }
    end
    let(:payment) do
      {
        total: '200.00'
      }
    end
    let(:company_attributes) do
      {
        cnpj: '33730453000122'
      }
    end

    let(:access_key) { '123412341212341234121234123412123412341212341234121234123412' }

    context '.execute' do
      let(:base_renderer) { BrInvoicesPdf::Cfe::Renderer::BaseRenderer }
      let(:qr_code_response) do
        '123412123412341212341234121234123412123412341|2017-07-01|20|20000|33730453000122|123'
      end
      let(:qr_code) { double(as_png: double(to_blob: 'blop')) }

      before do
        allow_any_instance_of(base_renderer).to receive(:page_paper_width).and_return(page_width)
        allow_any_instance_of(base_renderer).to receive(:box).and_yield
        expect(pdf).to receive(:text).with("Códigos de barra e QR Code\n\n", style: :italic)
        expect(pdf).to receive(:image).exactly(3).times
        expect(pdf).to receive(:move_down).exactly(4).times
        expect(RQRCode::QRCode).to receive(:new).with(qr_code_response).and_return(qr_code)
        expect(qr_code).to receive(:as_png).with(size: qr_code_size, border_modules: 0)
      end

      it 'generate qrcode and bars' do
        subject
      end
    end
  end
end
