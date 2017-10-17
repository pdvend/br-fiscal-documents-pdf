# frozen_string_literal: true

describe BrInvoicesPdf::Nfce::Parser::AdditionalInfo do
  describe '.execute' do
    subject { described_class.execute(xml) }

    let(:xml) { Ox.dump(foo: 'bar') }

    def locate_element_mock(path, value)
      base_parser_module = BrInvoicesPdf::Util::XmlLocate
      allow_any_instance_of(base_parser_module).to receive(:locate_element)
        .with(xml, path).and_return(value)
    end

    before do
      locate_element_mock('NFe/infAdic/infCpl', text)
    end

    let(:text) { 'Some string' }

    context 'parser correct text' do
      it { expect(subject).to eq(text) }
    end
  end
end
