require File.join(File.expand_path(File.dirname(__FILE__)), "spec_helper")
require 'prawn'
require_relative '../lib/prawn/html'

describe 'Prawn::html' do 

  let(:pdf) { Prawn::Document.new }

	before(:each) do
    @table_html = %{
      <table>
        <tr>
          <td>Header 1</td>
          <td>Header 2</td>
        </tr>
        <tr>
          <td>a</td>
          <td>b</td>
        </tr>
      </table>
    }

    @table_complex_html = %{
      <table align="center" border="1" cellpadding="5" cellspacing="0" style="background-color:#E6E6FA; border-style:hidden; height:169px; width:949px">
        <tbody>
          <tr>
            <td colspan="3" style="background-color:rgb(204, 255, 204); text-align:center"><strong>Title</strong></td>
          </tr>
          <tr>
            <td style="background-color:rgb(255, 255, 0)"><strong>1.1.0.00.00-6</strong></td>
            <td style="background-color:rgb(255, 255, 0)">Availability</td>
            <td><strong>100.000,05</strong></td>
          </tr>
          <tr>
            <td>1.1.1.00.00-9</td>
            <td>Cashier</td>
            <td style="text-align:center"><input name="c3" type="text" value="111.000,09" /></td>
          </tr>
        </tbody>
      </table>
    }

    @table_complex_html_array = [['Title'], ['1.1.0.00.00-6', 'Availability', '100.000,05'], ['1.1.1.00.00-9', 'Cashier', '']]

    @simple_html = '<p>Hello world</p>'

    # @pdf = Prawn::Document.new
  end

  it 'should return a Prawn::HTML' do
    html = pdf.html(@simple_html)
    expect(html).to  be_a_kind_of Prawn::HTML
  end

  it 'should generate line in pdf' do
    expect(pdf).to receive(:text).with('Hello world', anything)
  	pdf.html '<p>Hello world</p>'
  end

  it 'should generate table in pdf' do
    expect(pdf).to receive(:table).with([['Header 1', 'Header 2'], ['a', 'b']], anything)
    pdf.html @table_html
  end

  it 'should generate table with align' do 
    expect(pdf).to receive(:table).with(kind_of(Array), hash_including({align: :center}))    
    pdf.html @table_complex_html
  end

  it 'should generate table with background-color' do 
    expect(pdf).to receive(:table).with(kind_of(Array), hash_including({align: :center, cell_style: {background_color: 'E6E6FA'}}))
    pdf.html @table_complex_html
  end

  it 'should generate text to input' do 
    expect(pdf).to receive(:text).with('U$ 1.800,00')
    pdf.html '<input name="a1" type="text" value="U$ 1.800,00"/>'
  end

  it 'should generate text to input inside a <p>' do 
    expect(pdf).to receive(:text).with('U$ 1.800,00')
    pdf.html '<p><input name="a1" type="text" value="U$ 1.800,00"/></p>'
  end

  

  describe 'Convert elem to string needs' do
    it 'convert text input to string' do 
      expect_any_instance_of(Prawn::HTML).to receive(:input_to_text).with(kind_of(Nokogiri::XML::Element)).and_return('Its work fine')
      pdf.html '<input name="a1" type="text" value="Its work fine"/>'
    end

    it 'convert checkbox input to string' do 
      expect_any_instance_of(Prawn::HTML).to receive(:input_to_text).with(kind_of(Nokogiri::XML::Element)).and_return('(x)')
      pdf.html '<input name="a1" type="checkbox" checked/>'
    end

    it 'convert checkbox input to string' do 
      expect_any_instance_of(Prawn::HTML).to receive(:input_to_text).with(kind_of(Nokogiri::XML::Element)).and_return('( )')
      pdf.html '<input name="a1" type="checkbox"/>'
    end
  end

end