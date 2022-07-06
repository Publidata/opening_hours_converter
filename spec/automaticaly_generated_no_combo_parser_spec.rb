require 'opening_hours_converter'

RSpec.describe OpeningHoursConverter::OpeningHoursParser, '#parse' do
  it '10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('10:00-20:00'))).to eql('10:00-20:00')
  end
  it '10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('10:00-20:00 "commentaire"'))).to eql('10:00-20:00 "commentaire"')
  end
  it '10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('10:00-20:00 "commentaire avec des espaces"'))).to eql('10:00-20:00 "commentaire avec des espaces"')
  end
  it 'off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('off'))).to eql('off')
  end
  it 'off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('off "commentaire"'))).to eql('off "commentaire"')
  end
  it 'off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('off "commentaire avec des espaces"'))).to eql('off "commentaire avec des espaces"')
  end
  it '09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('09:00-12:30,14:00-18:30'))).to eql('09:00-12:30,14:00-18:30')
  end
  it '09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('09:00-12:30,14:00-18:30 "commentaire"'))).to eql('09:00-12:30,14:00-18:30 "commentaire"')
  end
  it '09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it 'Mo 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Mo 10:00-20:00'))).to eql('Mo 10:00-20:00')
  end
  it 'Mo 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Mo 10:00-20:00 "commentaire"'))).to eql('Mo 10:00-20:00 "commentaire"')
  end
  it 'Mo 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Mo 10:00-20:00 "commentaire avec des espaces"'))).to eql('Mo 10:00-20:00 "commentaire avec des espaces"')
  end
  it 'Mo off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Mo off'))).to eql('Mo off')
  end
  it 'Mo off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Mo off "commentaire"'))).to eql('Mo off "commentaire"')
  end
  it 'Mo off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Mo off "commentaire avec des espaces"'))).to eql('Mo off "commentaire avec des espaces"')
  end
  it 'Mo 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Mo 09:00-12:30,14:00-18:30'))).to eql('Mo 09:00-12:30,14:00-18:30')
  end
  it 'Mo 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Mo 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('Mo 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it 'Mo 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Mo 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('Mo 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it 'Mo,We-Fr,Su 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Mo,We-Fr,Su 10:00-20:00'))).to eql('Mo,We-Fr,Su 10:00-20:00')
  end
  it 'Mo,We-Fr,Su 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Mo,We-Fr,Su 10:00-20:00 "commentaire"'))).to eql('Mo,We-Fr,Su 10:00-20:00 "commentaire"')
  end
  it 'Mo,We-Fr,Su 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Mo,We-Fr,Su 10:00-20:00 "commentaire avec des espaces"'))).to eql('Mo,We-Fr,Su 10:00-20:00 "commentaire avec des espaces"')
  end
  it 'Mo,We-Fr,Su off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Mo,We-Fr,Su off'))).to eql('Mo,We-Fr,Su off')
  end
  it 'Mo,We-Fr,Su off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Mo,We-Fr,Su off "commentaire"'))).to eql('Mo,We-Fr,Su off "commentaire"')
  end
  it 'Mo,We-Fr,Su off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Mo,We-Fr,Su off "commentaire avec des espaces"'))).to eql('Mo,We-Fr,Su off "commentaire avec des espaces"')
  end
  it 'Mo,We-Fr,Su 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Mo,We-Fr,Su 09:00-12:30,14:00-18:30'))).to eql('Mo,We-Fr,Su 09:00-12:30,14:00-18:30')
  end
  it 'Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it 'Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it 'Mo-We,Fr,Sa 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Mo-We,Fr,Sa 10:00-20:00'))).to eql('Mo-We,Fr,Sa 10:00-20:00')
  end
  it 'Mo-We,Fr,Sa 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Mo-We,Fr,Sa 10:00-20:00 "commentaire"'))).to eql('Mo-We,Fr,Sa 10:00-20:00 "commentaire"')
  end
  it 'Mo-We,Fr,Sa 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Mo-We,Fr,Sa 10:00-20:00 "commentaire avec des espaces"'))).to eql('Mo-We,Fr,Sa 10:00-20:00 "commentaire avec des espaces"')
  end
  it 'Mo-We,Fr,Sa off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Mo-We,Fr,Sa off'))).to eql('Mo-We,Fr,Sa off')
  end
  it 'Mo-We,Fr,Sa off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Mo-We,Fr,Sa off "commentaire"'))).to eql('Mo-We,Fr,Sa off "commentaire"')
  end
  it 'Mo-We,Fr,Sa off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Mo-We,Fr,Sa off "commentaire avec des espaces"'))).to eql('Mo-We,Fr,Sa off "commentaire avec des espaces"')
  end
  it 'Mo-We,Fr,Sa 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Mo-We,Fr,Sa 09:00-12:30,14:00-18:30'))).to eql('Mo-We,Fr,Sa 09:00-12:30,14:00-18:30')
  end
  it 'Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it 'Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it 'PH 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('PH 10:00-20:00'))).to eql('PH 10:00-20:00')
  end
  it 'PH 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('PH 10:00-20:00 "commentaire"'))).to eql('PH 10:00-20:00 "commentaire"')
  end
  it 'PH 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('PH 10:00-20:00 "commentaire avec des espaces"'))).to eql('PH 10:00-20:00 "commentaire avec des espaces"')
  end
  it 'PH off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('PH off'))).to eql('PH off')
  end
  it 'PH off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('PH off "commentaire"'))).to eql('PH off "commentaire"')
  end
  it 'PH off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('PH off "commentaire avec des espaces"'))).to eql('PH off "commentaire avec des espaces"')
  end
  it 'PH 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('PH 09:00-12:30,14:00-18:30'))).to eql('PH 09:00-12:30,14:00-18:30')
  end
  it 'PH 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('PH 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('PH 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it 'PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it 'PH,Mo,We-Fr 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('PH,Mo,We-Fr 10:00-20:00'))).to eql('PH,Mo,We-Fr 10:00-20:00')
  end
  it 'PH,Mo,We-Fr 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('PH,Mo,We-Fr 10:00-20:00 "commentaire"'))).to eql('PH,Mo,We-Fr 10:00-20:00 "commentaire"')
  end
  it 'PH,Mo,We-Fr 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('PH,Mo,We-Fr 10:00-20:00 "commentaire avec des espaces"'))).to eql('PH,Mo,We-Fr 10:00-20:00 "commentaire avec des espaces"')
  end
  it 'PH,Mo,We-Fr off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('PH,Mo,We-Fr off'))).to eql('PH,Mo,We-Fr off')
  end
  it 'PH,Mo,We-Fr off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('PH,Mo,We-Fr off "commentaire"'))).to eql('PH,Mo,We-Fr off "commentaire"')
  end
  it 'PH,Mo,We-Fr off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('PH,Mo,We-Fr off "commentaire avec des espaces"'))).to eql('PH,Mo,We-Fr off "commentaire avec des espaces"')
  end
  it 'PH,Mo,We-Fr 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('PH,Mo,We-Fr 09:00-12:30,14:00-18:30'))).to eql('PH,Mo,We-Fr 09:00-12:30,14:00-18:30')
  end
  it 'PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it 'PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it '2030 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 10:00-20:00'))).to eql('2030 10:00-20:00')
  end
  it '2030 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 10:00-20:00 "commentaire"'))).to eql('2030 10:00-20:00 "commentaire"')
  end
  it '2030 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 10:00-20:00 "commentaire avec des espaces"'))).to eql('2030 10:00-20:00 "commentaire avec des espaces"')
  end
  it '2030 off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 off'))).to eql('2030 off')
  end
  it '2030 off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 off "commentaire"'))).to eql('2030 off "commentaire"')
  end
  it '2030 off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 off "commentaire avec des espaces"'))).to eql('2030 off "commentaire avec des espaces"')
  end
  it '2030 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 09:00-12:30,14:00-18:30'))).to eql('2030 09:00-12:30,14:00-18:30')
  end
  it '2030 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('2030 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it '2030 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('2030 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it '2030 Mo 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Mo 10:00-20:00'))).to eql('2030 Mo 10:00-20:00')
  end
  it '2030 Mo 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Mo 10:00-20:00 "commentaire"'))).to eql('2030 Mo 10:00-20:00 "commentaire"')
  end
  it '2030 Mo 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Mo 10:00-20:00 "commentaire avec des espaces"'))).to eql('2030 Mo 10:00-20:00 "commentaire avec des espaces"')
  end
  it '2030 Mo off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Mo off'))).to eql('2030 Mo off')
  end
  it '2030 Mo off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Mo off "commentaire"'))).to eql('2030 Mo off "commentaire"')
  end
  it '2030 Mo off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Mo off "commentaire avec des espaces"'))).to eql('2030 Mo off "commentaire avec des espaces"')
  end
  it '2030 Mo 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Mo 09:00-12:30,14:00-18:30'))).to eql('2030 Mo 09:00-12:30,14:00-18:30')
  end
  it '2030 Mo 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Mo 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('2030 Mo 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it '2030 Mo 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Mo 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('2030 Mo 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it '2030 Mo,We-Fr,Su 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Mo,We-Fr,Su 10:00-20:00'))).to eql('2030 Mo,We-Fr,Su 10:00-20:00')
  end
  it '2030 Mo,We-Fr,Su 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Mo,We-Fr,Su 10:00-20:00 "commentaire"'))).to eql('2030 Mo,We-Fr,Su 10:00-20:00 "commentaire"')
  end
  it '2030 Mo,We-Fr,Su 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Mo,We-Fr,Su 10:00-20:00 "commentaire avec des espaces"'))).to eql('2030 Mo,We-Fr,Su 10:00-20:00 "commentaire avec des espaces"')
  end
  it '2030 Mo,We-Fr,Su off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Mo,We-Fr,Su off'))).to eql('2030 Mo,We-Fr,Su off')
  end
  it '2030 Mo,We-Fr,Su off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Mo,We-Fr,Su off "commentaire"'))).to eql('2030 Mo,We-Fr,Su off "commentaire"')
  end
  it '2030 Mo,We-Fr,Su off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Mo,We-Fr,Su off "commentaire avec des espaces"'))).to eql('2030 Mo,We-Fr,Su off "commentaire avec des espaces"')
  end
  it '2030 Mo,We-Fr,Su 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Mo,We-Fr,Su 09:00-12:30,14:00-18:30'))).to eql('2030 Mo,We-Fr,Su 09:00-12:30,14:00-18:30')
  end
  it '2030 Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('2030 Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it '2030 Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('2030 Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it '2030 Mo-We,Fr,Sa 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Mo-We,Fr,Sa 10:00-20:00'))).to eql('2030 Mo-We,Fr,Sa 10:00-20:00')
  end
  it '2030 Mo-We,Fr,Sa 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Mo-We,Fr,Sa 10:00-20:00 "commentaire"'))).to eql('2030 Mo-We,Fr,Sa 10:00-20:00 "commentaire"')
  end
  it '2030 Mo-We,Fr,Sa 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Mo-We,Fr,Sa 10:00-20:00 "commentaire avec des espaces"'))).to eql('2030 Mo-We,Fr,Sa 10:00-20:00 "commentaire avec des espaces"')
  end
  it '2030 Mo-We,Fr,Sa off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Mo-We,Fr,Sa off'))).to eql('2030 Mo-We,Fr,Sa off')
  end
  it '2030 Mo-We,Fr,Sa off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Mo-We,Fr,Sa off "commentaire"'))).to eql('2030 Mo-We,Fr,Sa off "commentaire"')
  end
  it '2030 Mo-We,Fr,Sa off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Mo-We,Fr,Sa off "commentaire avec des espaces"'))).to eql('2030 Mo-We,Fr,Sa off "commentaire avec des espaces"')
  end
  it '2030 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30'))).to eql('2030 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30')
  end
  it '2030 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('2030 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it '2030 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('2030 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it '2030 PH 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 PH 10:00-20:00'))).to eql('2030 PH 10:00-20:00')
  end
  it '2030 PH 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 PH 10:00-20:00 "commentaire"'))).to eql('2030 PH 10:00-20:00 "commentaire"')
  end
  it '2030 PH 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 PH 10:00-20:00 "commentaire avec des espaces"'))).to eql('2030 PH 10:00-20:00 "commentaire avec des espaces"')
  end
  it '2030 PH off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 PH off'))).to eql('2030 PH off')
  end
  it '2030 PH off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 PH off "commentaire"'))).to eql('2030 PH off "commentaire"')
  end
  it '2030 PH off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 PH off "commentaire avec des espaces"'))).to eql('2030 PH off "commentaire avec des espaces"')
  end
  it '2030 PH 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 PH 09:00-12:30,14:00-18:30'))).to eql('2030 PH 09:00-12:30,14:00-18:30')
  end
  it '2030 PH 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 PH 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('2030 PH 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it '2030 PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('2030 PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it '2030 PH,Mo,We-Fr 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 PH,Mo,We-Fr 10:00-20:00'))).to eql('2030 PH,Mo,We-Fr 10:00-20:00')
  end
  it '2030 PH,Mo,We-Fr 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 PH,Mo,We-Fr 10:00-20:00 "commentaire"'))).to eql('2030 PH,Mo,We-Fr 10:00-20:00 "commentaire"')
  end
  it '2030 PH,Mo,We-Fr 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 PH,Mo,We-Fr 10:00-20:00 "commentaire avec des espaces"'))).to eql('2030 PH,Mo,We-Fr 10:00-20:00 "commentaire avec des espaces"')
  end
  it '2030 PH,Mo,We-Fr off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 PH,Mo,We-Fr off'))).to eql('2030 PH,Mo,We-Fr off')
  end
  it '2030 PH,Mo,We-Fr off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 PH,Mo,We-Fr off "commentaire"'))).to eql('2030 PH,Mo,We-Fr off "commentaire"')
  end
  it '2030 PH,Mo,We-Fr off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 PH,Mo,We-Fr off "commentaire avec des espaces"'))).to eql('2030 PH,Mo,We-Fr off "commentaire avec des espaces"')
  end
  it '2030 PH,Mo,We-Fr 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 PH,Mo,We-Fr 09:00-12:30,14:00-18:30'))).to eql('2030 PH,Mo,We-Fr 09:00-12:30,14:00-18:30')
  end
  it '2030 PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('2030 PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it '2030 PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('2030 PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it '2030 week 1 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1 10:00-20:00'))).to eql('2030 week 1 10:00-20:00')
  end
  it '2030 week 1 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1 10:00-20:00 "commentaire"'))).to eql('2030 week 1 10:00-20:00 "commentaire"')
  end
  it '2030 week 1 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1 10:00-20:00 "commentaire avec des espaces"'))).to eql('2030 week 1 10:00-20:00 "commentaire avec des espaces"')
  end
  it '2030 week 1 off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1 off'))).to eql('2030 week 1 off')
  end
  it '2030 week 1 off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1 off "commentaire"'))).to eql('2030 week 1 off "commentaire"')
  end
  it '2030 week 1 off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1 off "commentaire avec des espaces"'))).to eql('2030 week 1 off "commentaire avec des espaces"')
  end
  it '2030 week 1 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1 09:00-12:30,14:00-18:30'))).to eql('2030 week 1 09:00-12:30,14:00-18:30')
  end
  it '2030 week 1 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('2030 week 1 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it '2030 week 1 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('2030 week 1 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it '2030 week 1 Mo 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1 Mo 10:00-20:00'))).to eql('2030 week 1 Mo 10:00-20:00')
  end
  it '2030 week 1 Mo 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1 Mo 10:00-20:00 "commentaire"'))).to eql('2030 week 1 Mo 10:00-20:00 "commentaire"')
  end
  it '2030 week 1 Mo 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1 Mo 10:00-20:00 "commentaire avec des espaces"'))).to eql('2030 week 1 Mo 10:00-20:00 "commentaire avec des espaces"')
  end
  it '2030 week 1 Mo off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1 Mo off'))).to eql('2030 week 1 Mo off')
  end
  it '2030 week 1 Mo off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1 Mo off "commentaire"'))).to eql('2030 week 1 Mo off "commentaire"')
  end
  it '2030 week 1 Mo off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1 Mo off "commentaire avec des espaces"'))).to eql('2030 week 1 Mo off "commentaire avec des espaces"')
  end
  it '2030 week 1 Mo 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1 Mo 09:00-12:30,14:00-18:30'))).to eql('2030 week 1 Mo 09:00-12:30,14:00-18:30')
  end
  it '2030 week 1 Mo 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1 Mo 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('2030 week 1 Mo 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it '2030 week 1 Mo 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1 Mo 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('2030 week 1 Mo 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it '2030 week 1 Mo,We-Fr,Su 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1 Mo,We-Fr,Su 10:00-20:00'))).to eql('2030 week 1 Mo,We-Fr,Su 10:00-20:00')
  end
  it '2030 week 1 Mo,We-Fr,Su 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1 Mo,We-Fr,Su 10:00-20:00 "commentaire"'))).to eql('2030 week 1 Mo,We-Fr,Su 10:00-20:00 "commentaire"')
  end
  it '2030 week 1 Mo,We-Fr,Su 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1 Mo,We-Fr,Su 10:00-20:00 "commentaire avec des espaces"'))).to eql('2030 week 1 Mo,We-Fr,Su 10:00-20:00 "commentaire avec des espaces"')
  end
  it '2030 week 1 Mo,We-Fr,Su off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1 Mo,We-Fr,Su off'))).to eql('2030 week 1 Mo,We-Fr,Su off')
  end
  it '2030 week 1 Mo,We-Fr,Su off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1 Mo,We-Fr,Su off "commentaire"'))).to eql('2030 week 1 Mo,We-Fr,Su off "commentaire"')
  end
  it '2030 week 1 Mo,We-Fr,Su off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1 Mo,We-Fr,Su off "commentaire avec des espaces"'))).to eql('2030 week 1 Mo,We-Fr,Su off "commentaire avec des espaces"')
  end
  it '2030 week 1 Mo,We-Fr,Su 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1 Mo,We-Fr,Su 09:00-12:30,14:00-18:30'))).to eql('2030 week 1 Mo,We-Fr,Su 09:00-12:30,14:00-18:30')
  end
  it '2030 week 1 Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1 Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('2030 week 1 Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it '2030 week 1 Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1 Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('2030 week 1 Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it '2030 week 1 Mo-We,Fr,Sa 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1 Mo-We,Fr,Sa 10:00-20:00'))).to eql('2030 week 1 Mo-We,Fr,Sa 10:00-20:00')
  end
  it '2030 week 1 Mo-We,Fr,Sa 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1 Mo-We,Fr,Sa 10:00-20:00 "commentaire"'))).to eql('2030 week 1 Mo-We,Fr,Sa 10:00-20:00 "commentaire"')
  end
  it '2030 week 1 Mo-We,Fr,Sa 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1 Mo-We,Fr,Sa 10:00-20:00 "commentaire avec des espaces"'))).to eql('2030 week 1 Mo-We,Fr,Sa 10:00-20:00 "commentaire avec des espaces"')
  end
  it '2030 week 1 Mo-We,Fr,Sa off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1 Mo-We,Fr,Sa off'))).to eql('2030 week 1 Mo-We,Fr,Sa off')
  end
  it '2030 week 1 Mo-We,Fr,Sa off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1 Mo-We,Fr,Sa off "commentaire"'))).to eql('2030 week 1 Mo-We,Fr,Sa off "commentaire"')
  end
  it '2030 week 1 Mo-We,Fr,Sa off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1 Mo-We,Fr,Sa off "commentaire avec des espaces"'))).to eql('2030 week 1 Mo-We,Fr,Sa off "commentaire avec des espaces"')
  end
  it '2030 week 1 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30'))).to eql('2030 week 1 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30')
  end
  it '2030 week 1 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('2030 week 1 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it '2030 week 1 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('2030 week 1 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it '2030 week 1 PH 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1 PH 10:00-20:00'))).to eql('2030 week 1 PH 10:00-20:00')
  end
  it '2030 week 1 PH 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1 PH 10:00-20:00 "commentaire"'))).to eql('2030 week 1 PH 10:00-20:00 "commentaire"')
  end
  it '2030 week 1 PH 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1 PH 10:00-20:00 "commentaire avec des espaces"'))).to eql('2030 week 1 PH 10:00-20:00 "commentaire avec des espaces"')
  end
  it '2030 week 1 PH off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1 PH off'))).to eql('2030 week 1 PH off')
  end
  it '2030 week 1 PH off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1 PH off "commentaire"'))).to eql('2030 week 1 PH off "commentaire"')
  end
  it '2030 week 1 PH off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1 PH off "commentaire avec des espaces"'))).to eql('2030 week 1 PH off "commentaire avec des espaces"')
  end
  it '2030 week 1 PH 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1 PH 09:00-12:30,14:00-18:30'))).to eql('2030 week 1 PH 09:00-12:30,14:00-18:30')
  end
  it '2030 week 1 PH 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1 PH 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('2030 week 1 PH 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it '2030 week 1 PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1 PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('2030 week 1 PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it '2030 week 1 PH,Mo,We-Fr 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1 PH,Mo,We-Fr 10:00-20:00'))).to eql('2030 week 1 PH,Mo,We-Fr 10:00-20:00')
  end
  it '2030 week 1 PH,Mo,We-Fr 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1 PH,Mo,We-Fr 10:00-20:00 "commentaire"'))).to eql('2030 week 1 PH,Mo,We-Fr 10:00-20:00 "commentaire"')
  end
  it '2030 week 1 PH,Mo,We-Fr 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1 PH,Mo,We-Fr 10:00-20:00 "commentaire avec des espaces"'))).to eql('2030 week 1 PH,Mo,We-Fr 10:00-20:00 "commentaire avec des espaces"')
  end
  it '2030 week 1 PH,Mo,We-Fr off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1 PH,Mo,We-Fr off'))).to eql('2030 week 1 PH,Mo,We-Fr off')
  end
  it '2030 week 1 PH,Mo,We-Fr off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1 PH,Mo,We-Fr off "commentaire"'))).to eql('2030 week 1 PH,Mo,We-Fr off "commentaire"')
  end
  it '2030 week 1 PH,Mo,We-Fr off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1 PH,Mo,We-Fr off "commentaire avec des espaces"'))).to eql('2030 week 1 PH,Mo,We-Fr off "commentaire avec des espaces"')
  end
  it '2030 week 1 PH,Mo,We-Fr 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1 PH,Mo,We-Fr 09:00-12:30,14:00-18:30'))).to eql('2030 week 1 PH,Mo,We-Fr 09:00-12:30,14:00-18:30')
  end
  it '2030 week 1 PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1 PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('2030 week 1 PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it '2030 week 1 PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1 PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('2030 week 1 PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it '2030 week 1,3 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3 10:00-20:00'))).to eql('2030 week 1,3 10:00-20:00')
  end
  it '2030 week 1,3 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3 10:00-20:00 "commentaire"'))).to eql('2030 week 1,3 10:00-20:00 "commentaire"')
  end
  it '2030 week 1,3 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3 10:00-20:00 "commentaire avec des espaces"'))).to eql('2030 week 1,3 10:00-20:00 "commentaire avec des espaces"')
  end
  it '2030 week 1,3 off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3 off'))).to eql('2030 week 1,3 off')
  end
  it '2030 week 1,3 off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3 off "commentaire"'))).to eql('2030 week 1,3 off "commentaire"')
  end
  it '2030 week 1,3 off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3 off "commentaire avec des espaces"'))).to eql('2030 week 1,3 off "commentaire avec des espaces"')
  end
  it '2030 week 1,3 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3 09:00-12:30,14:00-18:30'))).to eql('2030 week 1,3 09:00-12:30,14:00-18:30')
  end
  it '2030 week 1,3 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('2030 week 1,3 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it '2030 week 1,3 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('2030 week 1,3 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it '2030 week 1,3 Mo 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3 Mo 10:00-20:00'))).to eql('2030 week 1,3 Mo 10:00-20:00')
  end
  it '2030 week 1,3 Mo 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3 Mo 10:00-20:00 "commentaire"'))).to eql('2030 week 1,3 Mo 10:00-20:00 "commentaire"')
  end
  it '2030 week 1,3 Mo 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3 Mo 10:00-20:00 "commentaire avec des espaces"'))).to eql('2030 week 1,3 Mo 10:00-20:00 "commentaire avec des espaces"')
  end
  it '2030 week 1,3 Mo off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3 Mo off'))).to eql('2030 week 1,3 Mo off')
  end
  it '2030 week 1,3 Mo off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3 Mo off "commentaire"'))).to eql('2030 week 1,3 Mo off "commentaire"')
  end
  it '2030 week 1,3 Mo off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3 Mo off "commentaire avec des espaces"'))).to eql('2030 week 1,3 Mo off "commentaire avec des espaces"')
  end
  it '2030 week 1,3 Mo 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3 Mo 09:00-12:30,14:00-18:30'))).to eql('2030 week 1,3 Mo 09:00-12:30,14:00-18:30')
  end
  it '2030 week 1,3 Mo 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3 Mo 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('2030 week 1,3 Mo 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it '2030 week 1,3 Mo 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3 Mo 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('2030 week 1,3 Mo 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it '2030 week 1,3 Mo,We-Fr,Su 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3 Mo,We-Fr,Su 10:00-20:00'))).to eql('2030 week 1,3 Mo,We-Fr,Su 10:00-20:00')
  end
  it '2030 week 1,3 Mo,We-Fr,Su 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3 Mo,We-Fr,Su 10:00-20:00 "commentaire"'))).to eql('2030 week 1,3 Mo,We-Fr,Su 10:00-20:00 "commentaire"')
  end
  it '2030 week 1,3 Mo,We-Fr,Su 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3 Mo,We-Fr,Su 10:00-20:00 "commentaire avec des espaces"'))).to eql('2030 week 1,3 Mo,We-Fr,Su 10:00-20:00 "commentaire avec des espaces"')
  end
  it '2030 week 1,3 Mo,We-Fr,Su off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3 Mo,We-Fr,Su off'))).to eql('2030 week 1,3 Mo,We-Fr,Su off')
  end
  it '2030 week 1,3 Mo,We-Fr,Su off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3 Mo,We-Fr,Su off "commentaire"'))).to eql('2030 week 1,3 Mo,We-Fr,Su off "commentaire"')
  end
  it '2030 week 1,3 Mo,We-Fr,Su off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3 Mo,We-Fr,Su off "commentaire avec des espaces"'))).to eql('2030 week 1,3 Mo,We-Fr,Su off "commentaire avec des espaces"')
  end
  it '2030 week 1,3 Mo,We-Fr,Su 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3 Mo,We-Fr,Su 09:00-12:30,14:00-18:30'))).to eql('2030 week 1,3 Mo,We-Fr,Su 09:00-12:30,14:00-18:30')
  end
  it '2030 week 1,3 Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3 Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('2030 week 1,3 Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it '2030 week 1,3 Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3 Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('2030 week 1,3 Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it '2030 week 1,3 Mo-We,Fr,Sa 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3 Mo-We,Fr,Sa 10:00-20:00'))).to eql('2030 week 1,3 Mo-We,Fr,Sa 10:00-20:00')
  end
  it '2030 week 1,3 Mo-We,Fr,Sa 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3 Mo-We,Fr,Sa 10:00-20:00 "commentaire"'))).to eql('2030 week 1,3 Mo-We,Fr,Sa 10:00-20:00 "commentaire"')
  end
  it '2030 week 1,3 Mo-We,Fr,Sa 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3 Mo-We,Fr,Sa 10:00-20:00 "commentaire avec des espaces"'))).to eql('2030 week 1,3 Mo-We,Fr,Sa 10:00-20:00 "commentaire avec des espaces"')
  end
  it '2030 week 1,3 Mo-We,Fr,Sa off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3 Mo-We,Fr,Sa off'))).to eql('2030 week 1,3 Mo-We,Fr,Sa off')
  end
  it '2030 week 1,3 Mo-We,Fr,Sa off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3 Mo-We,Fr,Sa off "commentaire"'))).to eql('2030 week 1,3 Mo-We,Fr,Sa off "commentaire"')
  end
  it '2030 week 1,3 Mo-We,Fr,Sa off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3 Mo-We,Fr,Sa off "commentaire avec des espaces"'))).to eql('2030 week 1,3 Mo-We,Fr,Sa off "commentaire avec des espaces"')
  end
  it '2030 week 1,3 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30'))).to eql('2030 week 1,3 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30')
  end
  it '2030 week 1,3 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('2030 week 1,3 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it '2030 week 1,3 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('2030 week 1,3 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it '2030 week 1,3 PH 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3 PH 10:00-20:00'))).to eql('2030 week 1,3 PH 10:00-20:00')
  end
  it '2030 week 1,3 PH 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3 PH 10:00-20:00 "commentaire"'))).to eql('2030 week 1,3 PH 10:00-20:00 "commentaire"')
  end
  it '2030 week 1,3 PH 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3 PH 10:00-20:00 "commentaire avec des espaces"'))).to eql('2030 week 1,3 PH 10:00-20:00 "commentaire avec des espaces"')
  end
  it '2030 week 1,3 PH off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3 PH off'))).to eql('2030 week 1,3 PH off')
  end
  it '2030 week 1,3 PH off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3 PH off "commentaire"'))).to eql('2030 week 1,3 PH off "commentaire"')
  end
  it '2030 week 1,3 PH off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3 PH off "commentaire avec des espaces"'))).to eql('2030 week 1,3 PH off "commentaire avec des espaces"')
  end
  it '2030 week 1,3 PH 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3 PH 09:00-12:30,14:00-18:30'))).to eql('2030 week 1,3 PH 09:00-12:30,14:00-18:30')
  end
  it '2030 week 1,3 PH 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3 PH 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('2030 week 1,3 PH 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it '2030 week 1,3 PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3 PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('2030 week 1,3 PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it '2030 week 1,3 PH,Mo,We-Fr 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3 PH,Mo,We-Fr 10:00-20:00'))).to eql('2030 week 1,3 PH,Mo,We-Fr 10:00-20:00')
  end
  it '2030 week 1,3 PH,Mo,We-Fr 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3 PH,Mo,We-Fr 10:00-20:00 "commentaire"'))).to eql('2030 week 1,3 PH,Mo,We-Fr 10:00-20:00 "commentaire"')
  end
  it '2030 week 1,3 PH,Mo,We-Fr 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3 PH,Mo,We-Fr 10:00-20:00 "commentaire avec des espaces"'))).to eql('2030 week 1,3 PH,Mo,We-Fr 10:00-20:00 "commentaire avec des espaces"')
  end
  it '2030 week 1,3 PH,Mo,We-Fr off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3 PH,Mo,We-Fr off'))).to eql('2030 week 1,3 PH,Mo,We-Fr off')
  end
  it '2030 week 1,3 PH,Mo,We-Fr off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3 PH,Mo,We-Fr off "commentaire"'))).to eql('2030 week 1,3 PH,Mo,We-Fr off "commentaire"')
  end
  it '2030 week 1,3 PH,Mo,We-Fr off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3 PH,Mo,We-Fr off "commentaire avec des espaces"'))).to eql('2030 week 1,3 PH,Mo,We-Fr off "commentaire avec des espaces"')
  end
  it '2030 week 1,3 PH,Mo,We-Fr 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3 PH,Mo,We-Fr 09:00-12:30,14:00-18:30'))).to eql('2030 week 1,3 PH,Mo,We-Fr 09:00-12:30,14:00-18:30')
  end
  it '2030 week 1,3 PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3 PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('2030 week 1,3 PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it '2030 week 1,3 PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3 PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('2030 week 1,3 PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it '2030 week 1,3,10-30 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30 10:00-20:00'))).to eql('2030 week 1,3,10-30 10:00-20:00')
  end
  it '2030 week 1,3,10-30 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30 10:00-20:00 "commentaire"'))).to eql('2030 week 1,3,10-30 10:00-20:00 "commentaire"')
  end
  it '2030 week 1,3,10-30 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30 10:00-20:00 "commentaire avec des espaces"'))).to eql('2030 week 1,3,10-30 10:00-20:00 "commentaire avec des espaces"')
  end
  it '2030 week 1,3,10-30 off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30 off'))).to eql('2030 week 1,3,10-30 off')
  end
  it '2030 week 1,3,10-30 off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30 off "commentaire"'))).to eql('2030 week 1,3,10-30 off "commentaire"')
  end
  it '2030 week 1,3,10-30 off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30 off "commentaire avec des espaces"'))).to eql('2030 week 1,3,10-30 off "commentaire avec des espaces"')
  end
  it '2030 week 1,3,10-30 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30 09:00-12:30,14:00-18:30'))).to eql('2030 week 1,3,10-30 09:00-12:30,14:00-18:30')
  end
  it '2030 week 1,3,10-30 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('2030 week 1,3,10-30 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it '2030 week 1,3,10-30 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('2030 week 1,3,10-30 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it '2030 week 1,3,10-30 Mo 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30 Mo 10:00-20:00'))).to eql('2030 week 1,3,10-30 Mo 10:00-20:00')
  end
  it '2030 week 1,3,10-30 Mo 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30 Mo 10:00-20:00 "commentaire"'))).to eql('2030 week 1,3,10-30 Mo 10:00-20:00 "commentaire"')
  end
  it '2030 week 1,3,10-30 Mo 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30 Mo 10:00-20:00 "commentaire avec des espaces"'))).to eql('2030 week 1,3,10-30 Mo 10:00-20:00 "commentaire avec des espaces"')
  end
  it '2030 week 1,3,10-30 Mo off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30 Mo off'))).to eql('2030 week 1,3,10-30 Mo off')
  end
  it '2030 week 1,3,10-30 Mo off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30 Mo off "commentaire"'))).to eql('2030 week 1,3,10-30 Mo off "commentaire"')
  end
  it '2030 week 1,3,10-30 Mo off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30 Mo off "commentaire avec des espaces"'))).to eql('2030 week 1,3,10-30 Mo off "commentaire avec des espaces"')
  end
  it '2030 week 1,3,10-30 Mo 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30 Mo 09:00-12:30,14:00-18:30'))).to eql('2030 week 1,3,10-30 Mo 09:00-12:30,14:00-18:30')
  end
  it '2030 week 1,3,10-30 Mo 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30 Mo 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('2030 week 1,3,10-30 Mo 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it '2030 week 1,3,10-30 Mo 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30 Mo 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('2030 week 1,3,10-30 Mo 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it '2030 week 1,3,10-30 Mo,We-Fr,Su 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30 Mo,We-Fr,Su 10:00-20:00'))).to eql('2030 week 1,3,10-30 Mo,We-Fr,Su 10:00-20:00')
  end
  it '2030 week 1,3,10-30 Mo,We-Fr,Su 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30 Mo,We-Fr,Su 10:00-20:00 "commentaire"'))).to eql('2030 week 1,3,10-30 Mo,We-Fr,Su 10:00-20:00 "commentaire"')
  end
  it '2030 week 1,3,10-30 Mo,We-Fr,Su 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30 Mo,We-Fr,Su 10:00-20:00 "commentaire avec des espaces"'))).to eql('2030 week 1,3,10-30 Mo,We-Fr,Su 10:00-20:00 "commentaire avec des espaces"')
  end
  it '2030 week 1,3,10-30 Mo,We-Fr,Su off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30 Mo,We-Fr,Su off'))).to eql('2030 week 1,3,10-30 Mo,We-Fr,Su off')
  end
  it '2030 week 1,3,10-30 Mo,We-Fr,Su off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30 Mo,We-Fr,Su off "commentaire"'))).to eql('2030 week 1,3,10-30 Mo,We-Fr,Su off "commentaire"')
  end
  it '2030 week 1,3,10-30 Mo,We-Fr,Su off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30 Mo,We-Fr,Su off "commentaire avec des espaces"'))).to eql('2030 week 1,3,10-30 Mo,We-Fr,Su off "commentaire avec des espaces"')
  end
  it '2030 week 1,3,10-30 Mo,We-Fr,Su 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30 Mo,We-Fr,Su 09:00-12:30,14:00-18:30'))).to eql('2030 week 1,3,10-30 Mo,We-Fr,Su 09:00-12:30,14:00-18:30')
  end
  it '2030 week 1,3,10-30 Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30 Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('2030 week 1,3,10-30 Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it '2030 week 1,3,10-30 Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30 Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('2030 week 1,3,10-30 Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it '2030 week 1,3,10-30 Mo-We,Fr,Sa 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30 Mo-We,Fr,Sa 10:00-20:00'))).to eql('2030 week 1,3,10-30 Mo-We,Fr,Sa 10:00-20:00')
  end
  it '2030 week 1,3,10-30 Mo-We,Fr,Sa 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30 Mo-We,Fr,Sa 10:00-20:00 "commentaire"'))).to eql('2030 week 1,3,10-30 Mo-We,Fr,Sa 10:00-20:00 "commentaire"')
  end
  it '2030 week 1,3,10-30 Mo-We,Fr,Sa 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30 Mo-We,Fr,Sa 10:00-20:00 "commentaire avec des espaces"'))).to eql('2030 week 1,3,10-30 Mo-We,Fr,Sa 10:00-20:00 "commentaire avec des espaces"')
  end
  it '2030 week 1,3,10-30 Mo-We,Fr,Sa off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30 Mo-We,Fr,Sa off'))).to eql('2030 week 1,3,10-30 Mo-We,Fr,Sa off')
  end
  it '2030 week 1,3,10-30 Mo-We,Fr,Sa off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30 Mo-We,Fr,Sa off "commentaire"'))).to eql('2030 week 1,3,10-30 Mo-We,Fr,Sa off "commentaire"')
  end
  it '2030 week 1,3,10-30 Mo-We,Fr,Sa off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30 Mo-We,Fr,Sa off "commentaire avec des espaces"'))).to eql('2030 week 1,3,10-30 Mo-We,Fr,Sa off "commentaire avec des espaces"')
  end
  it '2030 week 1,3,10-30 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30'))).to eql('2030 week 1,3,10-30 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30')
  end
  it '2030 week 1,3,10-30 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('2030 week 1,3,10-30 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it '2030 week 1,3,10-30 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('2030 week 1,3,10-30 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it '2030 week 1,3,10-30 PH 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30 PH 10:00-20:00'))).to eql('2030 week 1,3,10-30 PH 10:00-20:00')
  end
  it '2030 week 1,3,10-30 PH 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30 PH 10:00-20:00 "commentaire"'))).to eql('2030 week 1,3,10-30 PH 10:00-20:00 "commentaire"')
  end
  it '2030 week 1,3,10-30 PH 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30 PH 10:00-20:00 "commentaire avec des espaces"'))).to eql('2030 week 1,3,10-30 PH 10:00-20:00 "commentaire avec des espaces"')
  end
  it '2030 week 1,3,10-30 PH off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30 PH off'))).to eql('2030 week 1,3,10-30 PH off')
  end
  it '2030 week 1,3,10-30 PH off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30 PH off "commentaire"'))).to eql('2030 week 1,3,10-30 PH off "commentaire"')
  end
  it '2030 week 1,3,10-30 PH off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30 PH off "commentaire avec des espaces"'))).to eql('2030 week 1,3,10-30 PH off "commentaire avec des espaces"')
  end
  it '2030 week 1,3,10-30 PH 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30 PH 09:00-12:30,14:00-18:30'))).to eql('2030 week 1,3,10-30 PH 09:00-12:30,14:00-18:30')
  end
  it '2030 week 1,3,10-30 PH 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30 PH 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('2030 week 1,3,10-30 PH 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it '2030 week 1,3,10-30 PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30 PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('2030 week 1,3,10-30 PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it '2030 week 1,3,10-30 PH,Mo,We-Fr 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30 PH,Mo,We-Fr 10:00-20:00'))).to eql('2030 week 1,3,10-30 PH,Mo,We-Fr 10:00-20:00')
  end
  it '2030 week 1,3,10-30 PH,Mo,We-Fr 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30 PH,Mo,We-Fr 10:00-20:00 "commentaire"'))).to eql('2030 week 1,3,10-30 PH,Mo,We-Fr 10:00-20:00 "commentaire"')
  end
  it '2030 week 1,3,10-30 PH,Mo,We-Fr 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30 PH,Mo,We-Fr 10:00-20:00 "commentaire avec des espaces"'))).to eql('2030 week 1,3,10-30 PH,Mo,We-Fr 10:00-20:00 "commentaire avec des espaces"')
  end
  it '2030 week 1,3,10-30 PH,Mo,We-Fr off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30 PH,Mo,We-Fr off'))).to eql('2030 week 1,3,10-30 PH,Mo,We-Fr off')
  end
  it '2030 week 1,3,10-30 PH,Mo,We-Fr off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30 PH,Mo,We-Fr off "commentaire"'))).to eql('2030 week 1,3,10-30 PH,Mo,We-Fr off "commentaire"')
  end
  it '2030 week 1,3,10-30 PH,Mo,We-Fr off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30 PH,Mo,We-Fr off "commentaire avec des espaces"'))).to eql('2030 week 1,3,10-30 PH,Mo,We-Fr off "commentaire avec des espaces"')
  end
  it '2030 week 1,3,10-30 PH,Mo,We-Fr 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30 PH,Mo,We-Fr 09:00-12:30,14:00-18:30'))).to eql('2030 week 1,3,10-30 PH,Mo,We-Fr 09:00-12:30,14:00-18:30')
  end
  it '2030 week 1,3,10-30 PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30 PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('2030 week 1,3,10-30 PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it '2030 week 1,3,10-30 PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30 PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('2030 week 1,3,10-30 PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it '2030 week 1,3,10-30/2 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2 10:00-20:00'))).to eql('2030 week 1,3,10-30/2 10:00-20:00')
  end
  it '2030 week 1,3,10-30/2 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2 10:00-20:00 "commentaire"'))).to eql('2030 week 1,3,10-30/2 10:00-20:00 "commentaire"')
  end
  it '2030 week 1,3,10-30/2 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2 10:00-20:00 "commentaire avec des espaces"'))).to eql('2030 week 1,3,10-30/2 10:00-20:00 "commentaire avec des espaces"')
  end
  it '2030 week 1,3,10-30/2 off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2 off'))).to eql('2030 week 1,3,10-30/2 off')
  end
  it '2030 week 1,3,10-30/2 off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2 off "commentaire"'))).to eql('2030 week 1,3,10-30/2 off "commentaire"')
  end
  it '2030 week 1,3,10-30/2 off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2 off "commentaire avec des espaces"'))).to eql('2030 week 1,3,10-30/2 off "commentaire avec des espaces"')
  end
  it '2030 week 1,3,10-30/2 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2 09:00-12:30,14:00-18:30'))).to eql('2030 week 1,3,10-30/2 09:00-12:30,14:00-18:30')
  end
  it '2030 week 1,3,10-30/2 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('2030 week 1,3,10-30/2 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it '2030 week 1,3,10-30/2 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('2030 week 1,3,10-30/2 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it '2030 week 1,3,10-30/2 Mo 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2 Mo 10:00-20:00'))).to eql('2030 week 1,3,10-30/2 Mo 10:00-20:00')
  end
  it '2030 week 1,3,10-30/2 Mo 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2 Mo 10:00-20:00 "commentaire"'))).to eql('2030 week 1,3,10-30/2 Mo 10:00-20:00 "commentaire"')
  end
  it '2030 week 1,3,10-30/2 Mo 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2 Mo 10:00-20:00 "commentaire avec des espaces"'))).to eql('2030 week 1,3,10-30/2 Mo 10:00-20:00 "commentaire avec des espaces"')
  end
  it '2030 week 1,3,10-30/2 Mo off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2 Mo off'))).to eql('2030 week 1,3,10-30/2 Mo off')
  end
  it '2030 week 1,3,10-30/2 Mo off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2 Mo off "commentaire"'))).to eql('2030 week 1,3,10-30/2 Mo off "commentaire"')
  end
  it '2030 week 1,3,10-30/2 Mo off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2 Mo off "commentaire avec des espaces"'))).to eql('2030 week 1,3,10-30/2 Mo off "commentaire avec des espaces"')
  end
  it '2030 week 1,3,10-30/2 Mo 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2 Mo 09:00-12:30,14:00-18:30'))).to eql('2030 week 1,3,10-30/2 Mo 09:00-12:30,14:00-18:30')
  end
  it '2030 week 1,3,10-30/2 Mo 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2 Mo 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('2030 week 1,3,10-30/2 Mo 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it '2030 week 1,3,10-30/2 Mo 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2 Mo 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('2030 week 1,3,10-30/2 Mo 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it '2030 week 1,3,10-30/2 Mo,We-Fr,Su 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2 Mo,We-Fr,Su 10:00-20:00'))).to eql('2030 week 1,3,10-30/2 Mo,We-Fr,Su 10:00-20:00')
  end
  it '2030 week 1,3,10-30/2 Mo,We-Fr,Su 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2 Mo,We-Fr,Su 10:00-20:00 "commentaire"'))).to eql('2030 week 1,3,10-30/2 Mo,We-Fr,Su 10:00-20:00 "commentaire"')
  end
  it '2030 week 1,3,10-30/2 Mo,We-Fr,Su 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2 Mo,We-Fr,Su 10:00-20:00 "commentaire avec des espaces"'))).to eql('2030 week 1,3,10-30/2 Mo,We-Fr,Su 10:00-20:00 "commentaire avec des espaces"')
  end
  it '2030 week 1,3,10-30/2 Mo,We-Fr,Su off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2 Mo,We-Fr,Su off'))).to eql('2030 week 1,3,10-30/2 Mo,We-Fr,Su off')
  end
  it '2030 week 1,3,10-30/2 Mo,We-Fr,Su off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2 Mo,We-Fr,Su off "commentaire"'))).to eql('2030 week 1,3,10-30/2 Mo,We-Fr,Su off "commentaire"')
  end
  it '2030 week 1,3,10-30/2 Mo,We-Fr,Su off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2 Mo,We-Fr,Su off "commentaire avec des espaces"'))).to eql('2030 week 1,3,10-30/2 Mo,We-Fr,Su off "commentaire avec des espaces"')
  end
  it '2030 week 1,3,10-30/2 Mo,We-Fr,Su 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2 Mo,We-Fr,Su 09:00-12:30,14:00-18:30'))).to eql('2030 week 1,3,10-30/2 Mo,We-Fr,Su 09:00-12:30,14:00-18:30')
  end
  it '2030 week 1,3,10-30/2 Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2 Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('2030 week 1,3,10-30/2 Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it '2030 week 1,3,10-30/2 Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2 Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('2030 week 1,3,10-30/2 Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it '2030 week 1,3,10-30/2 Mo-We,Fr,Sa 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2 Mo-We,Fr,Sa 10:00-20:00'))).to eql('2030 week 1,3,10-30/2 Mo-We,Fr,Sa 10:00-20:00')
  end
  it '2030 week 1,3,10-30/2 Mo-We,Fr,Sa 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2 Mo-We,Fr,Sa 10:00-20:00 "commentaire"'))).to eql('2030 week 1,3,10-30/2 Mo-We,Fr,Sa 10:00-20:00 "commentaire"')
  end
  it '2030 week 1,3,10-30/2 Mo-We,Fr,Sa 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2 Mo-We,Fr,Sa 10:00-20:00 "commentaire avec des espaces"'))).to eql('2030 week 1,3,10-30/2 Mo-We,Fr,Sa 10:00-20:00 "commentaire avec des espaces"')
  end
  it '2030 week 1,3,10-30/2 Mo-We,Fr,Sa off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2 Mo-We,Fr,Sa off'))).to eql('2030 week 1,3,10-30/2 Mo-We,Fr,Sa off')
  end
  it '2030 week 1,3,10-30/2 Mo-We,Fr,Sa off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2 Mo-We,Fr,Sa off "commentaire"'))).to eql('2030 week 1,3,10-30/2 Mo-We,Fr,Sa off "commentaire"')
  end
  it '2030 week 1,3,10-30/2 Mo-We,Fr,Sa off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2 Mo-We,Fr,Sa off "commentaire avec des espaces"'))).to eql('2030 week 1,3,10-30/2 Mo-We,Fr,Sa off "commentaire avec des espaces"')
  end
  it '2030 week 1,3,10-30/2 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30'))).to eql('2030 week 1,3,10-30/2 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30')
  end
  it '2030 week 1,3,10-30/2 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('2030 week 1,3,10-30/2 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it '2030 week 1,3,10-30/2 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('2030 week 1,3,10-30/2 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it '2030 week 1,3,10-30/2 PH 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2 PH 10:00-20:00'))).to eql('2030 week 1,3,10-30/2 PH 10:00-20:00')
  end
  it '2030 week 1,3,10-30/2 PH 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2 PH 10:00-20:00 "commentaire"'))).to eql('2030 week 1,3,10-30/2 PH 10:00-20:00 "commentaire"')
  end
  it '2030 week 1,3,10-30/2 PH 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2 PH 10:00-20:00 "commentaire avec des espaces"'))).to eql('2030 week 1,3,10-30/2 PH 10:00-20:00 "commentaire avec des espaces"')
  end
  it '2030 week 1,3,10-30/2 PH off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2 PH off'))).to eql('2030 week 1,3,10-30/2 PH off')
  end
  it '2030 week 1,3,10-30/2 PH off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2 PH off "commentaire"'))).to eql('2030 week 1,3,10-30/2 PH off "commentaire"')
  end
  it '2030 week 1,3,10-30/2 PH off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2 PH off "commentaire avec des espaces"'))).to eql('2030 week 1,3,10-30/2 PH off "commentaire avec des espaces"')
  end
  it '2030 week 1,3,10-30/2 PH 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2 PH 09:00-12:30,14:00-18:30'))).to eql('2030 week 1,3,10-30/2 PH 09:00-12:30,14:00-18:30')
  end
  it '2030 week 1,3,10-30/2 PH 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2 PH 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('2030 week 1,3,10-30/2 PH 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it '2030 week 1,3,10-30/2 PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2 PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('2030 week 1,3,10-30/2 PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it '2030 week 1,3,10-30/2 PH,Mo,We-Fr 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2 PH,Mo,We-Fr 10:00-20:00'))).to eql('2030 week 1,3,10-30/2 PH,Mo,We-Fr 10:00-20:00')
  end
  it '2030 week 1,3,10-30/2 PH,Mo,We-Fr 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2 PH,Mo,We-Fr 10:00-20:00 "commentaire"'))).to eql('2030 week 1,3,10-30/2 PH,Mo,We-Fr 10:00-20:00 "commentaire"')
  end
  it '2030 week 1,3,10-30/2 PH,Mo,We-Fr 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2 PH,Mo,We-Fr 10:00-20:00 "commentaire avec des espaces"'))).to eql('2030 week 1,3,10-30/2 PH,Mo,We-Fr 10:00-20:00 "commentaire avec des espaces"')
  end
  it '2030 week 1,3,10-30/2 PH,Mo,We-Fr off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2 PH,Mo,We-Fr off'))).to eql('2030 week 1,3,10-30/2 PH,Mo,We-Fr off')
  end
  it '2030 week 1,3,10-30/2 PH,Mo,We-Fr off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2 PH,Mo,We-Fr off "commentaire"'))).to eql('2030 week 1,3,10-30/2 PH,Mo,We-Fr off "commentaire"')
  end
  it '2030 week 1,3,10-30/2 PH,Mo,We-Fr off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2 PH,Mo,We-Fr off "commentaire avec des espaces"'))).to eql('2030 week 1,3,10-30/2 PH,Mo,We-Fr off "commentaire avec des espaces"')
  end
  it '2030 week 1,3,10-30/2 PH,Mo,We-Fr 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2 PH,Mo,We-Fr 09:00-12:30,14:00-18:30'))).to eql('2030 week 1,3,10-30/2 PH,Mo,We-Fr 09:00-12:30,14:00-18:30')
  end
  it '2030 week 1,3,10-30/2 PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2 PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('2030 week 1,3,10-30/2 PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it '2030 week 1,3,10-30/2 PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2 PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('2030 week 1,3,10-30/2 PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it '2030 week 1,3,10-30/2,50 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2,50 10:00-20:00'))).to eql('2030 week 1,3,10-30/2,50 10:00-20:00')
  end
  it '2030 week 1,3,10-30/2,50 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2,50 10:00-20:00 "commentaire"'))).to eql('2030 week 1,3,10-30/2,50 10:00-20:00 "commentaire"')
  end
  it '2030 week 1,3,10-30/2,50 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2,50 10:00-20:00 "commentaire avec des espaces"'))).to eql('2030 week 1,3,10-30/2,50 10:00-20:00 "commentaire avec des espaces"')
  end
  it '2030 week 1,3,10-30/2,50 off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2,50 off'))).to eql('2030 week 1,3,10-30/2,50 off')
  end
  it '2030 week 1,3,10-30/2,50 off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2,50 off "commentaire"'))).to eql('2030 week 1,3,10-30/2,50 off "commentaire"')
  end
  it '2030 week 1,3,10-30/2,50 off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2,50 off "commentaire avec des espaces"'))).to eql('2030 week 1,3,10-30/2,50 off "commentaire avec des espaces"')
  end
  it '2030 week 1,3,10-30/2,50 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2,50 09:00-12:30,14:00-18:30'))).to eql('2030 week 1,3,10-30/2,50 09:00-12:30,14:00-18:30')
  end
  it '2030 week 1,3,10-30/2,50 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2,50 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('2030 week 1,3,10-30/2,50 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it '2030 week 1,3,10-30/2,50 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2,50 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('2030 week 1,3,10-30/2,50 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it '2030 week 1,3,10-30/2,50 Mo 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2,50 Mo 10:00-20:00'))).to eql('2030 week 1,3,10-30/2,50 Mo 10:00-20:00')
  end
  it '2030 week 1,3,10-30/2,50 Mo 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2,50 Mo 10:00-20:00 "commentaire"'))).to eql('2030 week 1,3,10-30/2,50 Mo 10:00-20:00 "commentaire"')
  end
  it '2030 week 1,3,10-30/2,50 Mo 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2,50 Mo 10:00-20:00 "commentaire avec des espaces"'))).to eql('2030 week 1,3,10-30/2,50 Mo 10:00-20:00 "commentaire avec des espaces"')
  end
  it '2030 week 1,3,10-30/2,50 Mo off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2,50 Mo off'))).to eql('2030 week 1,3,10-30/2,50 Mo off')
  end
  it '2030 week 1,3,10-30/2,50 Mo off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2,50 Mo off "commentaire"'))).to eql('2030 week 1,3,10-30/2,50 Mo off "commentaire"')
  end
  it '2030 week 1,3,10-30/2,50 Mo off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2,50 Mo off "commentaire avec des espaces"'))).to eql('2030 week 1,3,10-30/2,50 Mo off "commentaire avec des espaces"')
  end
  it '2030 week 1,3,10-30/2,50 Mo 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2,50 Mo 09:00-12:30,14:00-18:30'))).to eql('2030 week 1,3,10-30/2,50 Mo 09:00-12:30,14:00-18:30')
  end
  it '2030 week 1,3,10-30/2,50 Mo 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2,50 Mo 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('2030 week 1,3,10-30/2,50 Mo 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it '2030 week 1,3,10-30/2,50 Mo 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2,50 Mo 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('2030 week 1,3,10-30/2,50 Mo 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it '2030 week 1,3,10-30/2,50 Mo,We-Fr,Su 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2,50 Mo,We-Fr,Su 10:00-20:00'))).to eql('2030 week 1,3,10-30/2,50 Mo,We-Fr,Su 10:00-20:00')
  end
  it '2030 week 1,3,10-30/2,50 Mo,We-Fr,Su 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2,50 Mo,We-Fr,Su 10:00-20:00 "commentaire"'))).to eql('2030 week 1,3,10-30/2,50 Mo,We-Fr,Su 10:00-20:00 "commentaire"')
  end
  it '2030 week 1,3,10-30/2,50 Mo,We-Fr,Su 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2,50 Mo,We-Fr,Su 10:00-20:00 "commentaire avec des espaces"'))).to eql('2030 week 1,3,10-30/2,50 Mo,We-Fr,Su 10:00-20:00 "commentaire avec des espaces"')
  end
  it '2030 week 1,3,10-30/2,50 Mo,We-Fr,Su off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2,50 Mo,We-Fr,Su off'))).to eql('2030 week 1,3,10-30/2,50 Mo,We-Fr,Su off')
  end
  it '2030 week 1,3,10-30/2,50 Mo,We-Fr,Su off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2,50 Mo,We-Fr,Su off "commentaire"'))).to eql('2030 week 1,3,10-30/2,50 Mo,We-Fr,Su off "commentaire"')
  end
  it '2030 week 1,3,10-30/2,50 Mo,We-Fr,Su off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2,50 Mo,We-Fr,Su off "commentaire avec des espaces"'))).to eql('2030 week 1,3,10-30/2,50 Mo,We-Fr,Su off "commentaire avec des espaces"')
  end
  it '2030 week 1,3,10-30/2,50 Mo,We-Fr,Su 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2,50 Mo,We-Fr,Su 09:00-12:30,14:00-18:30'))).to eql('2030 week 1,3,10-30/2,50 Mo,We-Fr,Su 09:00-12:30,14:00-18:30')
  end
  it '2030 week 1,3,10-30/2,50 Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2,50 Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('2030 week 1,3,10-30/2,50 Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it '2030 week 1,3,10-30/2,50 Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2,50 Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('2030 week 1,3,10-30/2,50 Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it '2030 week 1,3,10-30/2,50 Mo-We,Fr,Sa 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2,50 Mo-We,Fr,Sa 10:00-20:00'))).to eql('2030 week 1,3,10-30/2,50 Mo-We,Fr,Sa 10:00-20:00')
  end
  it '2030 week 1,3,10-30/2,50 Mo-We,Fr,Sa 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2,50 Mo-We,Fr,Sa 10:00-20:00 "commentaire"'))).to eql('2030 week 1,3,10-30/2,50 Mo-We,Fr,Sa 10:00-20:00 "commentaire"')
  end
  it '2030 week 1,3,10-30/2,50 Mo-We,Fr,Sa 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2,50 Mo-We,Fr,Sa 10:00-20:00 "commentaire avec des espaces"'))).to eql('2030 week 1,3,10-30/2,50 Mo-We,Fr,Sa 10:00-20:00 "commentaire avec des espaces"')
  end
  it '2030 week 1,3,10-30/2,50 Mo-We,Fr,Sa off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2,50 Mo-We,Fr,Sa off'))).to eql('2030 week 1,3,10-30/2,50 Mo-We,Fr,Sa off')
  end
  it '2030 week 1,3,10-30/2,50 Mo-We,Fr,Sa off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2,50 Mo-We,Fr,Sa off "commentaire"'))).to eql('2030 week 1,3,10-30/2,50 Mo-We,Fr,Sa off "commentaire"')
  end
  it '2030 week 1,3,10-30/2,50 Mo-We,Fr,Sa off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2,50 Mo-We,Fr,Sa off "commentaire avec des espaces"'))).to eql('2030 week 1,3,10-30/2,50 Mo-We,Fr,Sa off "commentaire avec des espaces"')
  end
  it '2030 week 1,3,10-30/2,50 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2,50 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30'))).to eql('2030 week 1,3,10-30/2,50 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30')
  end
  it '2030 week 1,3,10-30/2,50 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2,50 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('2030 week 1,3,10-30/2,50 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it '2030 week 1,3,10-30/2,50 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2,50 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('2030 week 1,3,10-30/2,50 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it '2030 week 1,3,10-30/2,50 PH 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2,50 PH 10:00-20:00'))).to eql('2030 week 1,3,10-30/2,50 PH 10:00-20:00')
  end
  it '2030 week 1,3,10-30/2,50 PH 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2,50 PH 10:00-20:00 "commentaire"'))).to eql('2030 week 1,3,10-30/2,50 PH 10:00-20:00 "commentaire"')
  end
  it '2030 week 1,3,10-30/2,50 PH 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2,50 PH 10:00-20:00 "commentaire avec des espaces"'))).to eql('2030 week 1,3,10-30/2,50 PH 10:00-20:00 "commentaire avec des espaces"')
  end
  it '2030 week 1,3,10-30/2,50 PH off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2,50 PH off'))).to eql('2030 week 1,3,10-30/2,50 PH off')
  end
  it '2030 week 1,3,10-30/2,50 PH off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2,50 PH off "commentaire"'))).to eql('2030 week 1,3,10-30/2,50 PH off "commentaire"')
  end
  it '2030 week 1,3,10-30/2,50 PH off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2,50 PH off "commentaire avec des espaces"'))).to eql('2030 week 1,3,10-30/2,50 PH off "commentaire avec des espaces"')
  end
  it '2030 week 1,3,10-30/2,50 PH 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2,50 PH 09:00-12:30,14:00-18:30'))).to eql('2030 week 1,3,10-30/2,50 PH 09:00-12:30,14:00-18:30')
  end
  it '2030 week 1,3,10-30/2,50 PH 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2,50 PH 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('2030 week 1,3,10-30/2,50 PH 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it '2030 week 1,3,10-30/2,50 PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2,50 PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('2030 week 1,3,10-30/2,50 PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it '2030 week 1,3,10-30/2,50 PH,Mo,We-Fr 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2,50 PH,Mo,We-Fr 10:00-20:00'))).to eql('2030 week 1,3,10-30/2,50 PH,Mo,We-Fr 10:00-20:00')
  end
  it '2030 week 1,3,10-30/2,50 PH,Mo,We-Fr 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2,50 PH,Mo,We-Fr 10:00-20:00 "commentaire"'))).to eql('2030 week 1,3,10-30/2,50 PH,Mo,We-Fr 10:00-20:00 "commentaire"')
  end
  it '2030 week 1,3,10-30/2,50 PH,Mo,We-Fr 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2,50 PH,Mo,We-Fr 10:00-20:00 "commentaire avec des espaces"'))).to eql('2030 week 1,3,10-30/2,50 PH,Mo,We-Fr 10:00-20:00 "commentaire avec des espaces"')
  end
  it '2030 week 1,3,10-30/2,50 PH,Mo,We-Fr off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2,50 PH,Mo,We-Fr off'))).to eql('2030 week 1,3,10-30/2,50 PH,Mo,We-Fr off')
  end
  it '2030 week 1,3,10-30/2,50 PH,Mo,We-Fr off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2,50 PH,Mo,We-Fr off "commentaire"'))).to eql('2030 week 1,3,10-30/2,50 PH,Mo,We-Fr off "commentaire"')
  end
  it '2030 week 1,3,10-30/2,50 PH,Mo,We-Fr off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2,50 PH,Mo,We-Fr off "commentaire avec des espaces"'))).to eql('2030 week 1,3,10-30/2,50 PH,Mo,We-Fr off "commentaire avec des espaces"')
  end
  it '2030 week 1,3,10-30/2,50 PH,Mo,We-Fr 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2,50 PH,Mo,We-Fr 09:00-12:30,14:00-18:30'))).to eql('2030 week 1,3,10-30/2,50 PH,Mo,We-Fr 09:00-12:30,14:00-18:30')
  end
  it '2030 week 1,3,10-30/2,50 PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2,50 PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('2030 week 1,3,10-30/2,50 PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it '2030 week 1,3,10-30/2,50 PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2,50 PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('2030 week 1,3,10-30/2,50 PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it 'week 1 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1 10:00-20:00'))).to eql('week 1 10:00-20:00')
  end
  it 'week 1 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1 10:00-20:00 "commentaire"'))).to eql('week 1 10:00-20:00 "commentaire"')
  end
  it 'week 1 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1 10:00-20:00 "commentaire avec des espaces"'))).to eql('week 1 10:00-20:00 "commentaire avec des espaces"')
  end
  it 'week 1 off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1 off'))).to eql('week 1 off')
  end
  it 'week 1 off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1 off "commentaire"'))).to eql('week 1 off "commentaire"')
  end
  it 'week 1 off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1 off "commentaire avec des espaces"'))).to eql('week 1 off "commentaire avec des espaces"')
  end
  it 'week 1 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1 09:00-12:30,14:00-18:30'))).to eql('week 1 09:00-12:30,14:00-18:30')
  end
  it 'week 1 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('week 1 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it 'week 1 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('week 1 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it 'week 1 Mo 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1 Mo 10:00-20:00'))).to eql('week 1 Mo 10:00-20:00')
  end
  it 'week 1 Mo 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1 Mo 10:00-20:00 "commentaire"'))).to eql('week 1 Mo 10:00-20:00 "commentaire"')
  end
  it 'week 1 Mo 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1 Mo 10:00-20:00 "commentaire avec des espaces"'))).to eql('week 1 Mo 10:00-20:00 "commentaire avec des espaces"')
  end
  it 'week 1 Mo off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1 Mo off'))).to eql('week 1 Mo off')
  end
  it 'week 1 Mo off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1 Mo off "commentaire"'))).to eql('week 1 Mo off "commentaire"')
  end
  it 'week 1 Mo off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1 Mo off "commentaire avec des espaces"'))).to eql('week 1 Mo off "commentaire avec des espaces"')
  end
  it 'week 1 Mo 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1 Mo 09:00-12:30,14:00-18:30'))).to eql('week 1 Mo 09:00-12:30,14:00-18:30')
  end
  it 'week 1 Mo 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1 Mo 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('week 1 Mo 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it 'week 1 Mo 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1 Mo 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('week 1 Mo 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it 'week 1 Mo,We-Fr,Su 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1 Mo,We-Fr,Su 10:00-20:00'))).to eql('week 1 Mo,We-Fr,Su 10:00-20:00')
  end
  it 'week 1 Mo,We-Fr,Su 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1 Mo,We-Fr,Su 10:00-20:00 "commentaire"'))).to eql('week 1 Mo,We-Fr,Su 10:00-20:00 "commentaire"')
  end
  it 'week 1 Mo,We-Fr,Su 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1 Mo,We-Fr,Su 10:00-20:00 "commentaire avec des espaces"'))).to eql('week 1 Mo,We-Fr,Su 10:00-20:00 "commentaire avec des espaces"')
  end
  it 'week 1 Mo,We-Fr,Su off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1 Mo,We-Fr,Su off'))).to eql('week 1 Mo,We-Fr,Su off')
  end
  it 'week 1 Mo,We-Fr,Su off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1 Mo,We-Fr,Su off "commentaire"'))).to eql('week 1 Mo,We-Fr,Su off "commentaire"')
  end
  it 'week 1 Mo,We-Fr,Su off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1 Mo,We-Fr,Su off "commentaire avec des espaces"'))).to eql('week 1 Mo,We-Fr,Su off "commentaire avec des espaces"')
  end
  it 'week 1 Mo,We-Fr,Su 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1 Mo,We-Fr,Su 09:00-12:30,14:00-18:30'))).to eql('week 1 Mo,We-Fr,Su 09:00-12:30,14:00-18:30')
  end
  it 'week 1 Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1 Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('week 1 Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it 'week 1 Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1 Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('week 1 Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it 'week 1 Mo-We,Fr,Sa 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1 Mo-We,Fr,Sa 10:00-20:00'))).to eql('week 1 Mo-We,Fr,Sa 10:00-20:00')
  end
  it 'week 1 Mo-We,Fr,Sa 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1 Mo-We,Fr,Sa 10:00-20:00 "commentaire"'))).to eql('week 1 Mo-We,Fr,Sa 10:00-20:00 "commentaire"')
  end
  it 'week 1 Mo-We,Fr,Sa 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1 Mo-We,Fr,Sa 10:00-20:00 "commentaire avec des espaces"'))).to eql('week 1 Mo-We,Fr,Sa 10:00-20:00 "commentaire avec des espaces"')
  end
  it 'week 1 Mo-We,Fr,Sa off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1 Mo-We,Fr,Sa off'))).to eql('week 1 Mo-We,Fr,Sa off')
  end
  it 'week 1 Mo-We,Fr,Sa off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1 Mo-We,Fr,Sa off "commentaire"'))).to eql('week 1 Mo-We,Fr,Sa off "commentaire"')
  end
  it 'week 1 Mo-We,Fr,Sa off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1 Mo-We,Fr,Sa off "commentaire avec des espaces"'))).to eql('week 1 Mo-We,Fr,Sa off "commentaire avec des espaces"')
  end
  it 'week 1 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30'))).to eql('week 1 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30')
  end
  it 'week 1 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('week 1 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it 'week 1 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('week 1 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it 'week 1 PH 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1 PH 10:00-20:00'))).to eql('week 1 PH 10:00-20:00')
  end
  it 'week 1 PH 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1 PH 10:00-20:00 "commentaire"'))).to eql('week 1 PH 10:00-20:00 "commentaire"')
  end
  it 'week 1 PH 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1 PH 10:00-20:00 "commentaire avec des espaces"'))).to eql('week 1 PH 10:00-20:00 "commentaire avec des espaces"')
  end
  it 'week 1 PH off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1 PH off'))).to eql('week 1 PH off')
  end
  it 'week 1 PH off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1 PH off "commentaire"'))).to eql('week 1 PH off "commentaire"')
  end
  it 'week 1 PH off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1 PH off "commentaire avec des espaces"'))).to eql('week 1 PH off "commentaire avec des espaces"')
  end
  it 'week 1 PH 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1 PH 09:00-12:30,14:00-18:30'))).to eql('week 1 PH 09:00-12:30,14:00-18:30')
  end
  it 'week 1 PH 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1 PH 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('week 1 PH 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it 'week 1 PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1 PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('week 1 PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it 'week 1 PH,Mo,We-Fr 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1 PH,Mo,We-Fr 10:00-20:00'))).to eql('week 1 PH,Mo,We-Fr 10:00-20:00')
  end
  it 'week 1 PH,Mo,We-Fr 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1 PH,Mo,We-Fr 10:00-20:00 "commentaire"'))).to eql('week 1 PH,Mo,We-Fr 10:00-20:00 "commentaire"')
  end
  it 'week 1 PH,Mo,We-Fr 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1 PH,Mo,We-Fr 10:00-20:00 "commentaire avec des espaces"'))).to eql('week 1 PH,Mo,We-Fr 10:00-20:00 "commentaire avec des espaces"')
  end
  it 'week 1 PH,Mo,We-Fr off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1 PH,Mo,We-Fr off'))).to eql('week 1 PH,Mo,We-Fr off')
  end
  it 'week 1 PH,Mo,We-Fr off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1 PH,Mo,We-Fr off "commentaire"'))).to eql('week 1 PH,Mo,We-Fr off "commentaire"')
  end
  it 'week 1 PH,Mo,We-Fr off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1 PH,Mo,We-Fr off "commentaire avec des espaces"'))).to eql('week 1 PH,Mo,We-Fr off "commentaire avec des espaces"')
  end
  it 'week 1 PH,Mo,We-Fr 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1 PH,Mo,We-Fr 09:00-12:30,14:00-18:30'))).to eql('week 1 PH,Mo,We-Fr 09:00-12:30,14:00-18:30')
  end
  it 'week 1 PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1 PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('week 1 PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it 'week 1 PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1 PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('week 1 PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it 'week 1,3 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3 10:00-20:00'))).to eql('week 1,3 10:00-20:00')
  end
  it 'week 1,3 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3 10:00-20:00 "commentaire"'))).to eql('week 1,3 10:00-20:00 "commentaire"')
  end
  it 'week 1,3 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3 10:00-20:00 "commentaire avec des espaces"'))).to eql('week 1,3 10:00-20:00 "commentaire avec des espaces"')
  end
  it 'week 1,3 off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3 off'))).to eql('week 1,3 off')
  end
  it 'week 1,3 off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3 off "commentaire"'))).to eql('week 1,3 off "commentaire"')
  end
  it 'week 1,3 off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3 off "commentaire avec des espaces"'))).to eql('week 1,3 off "commentaire avec des espaces"')
  end
  it 'week 1,3 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3 09:00-12:30,14:00-18:30'))).to eql('week 1,3 09:00-12:30,14:00-18:30')
  end
  it 'week 1,3 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('week 1,3 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it 'week 1,3 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('week 1,3 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it 'week 1,3 Mo 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3 Mo 10:00-20:00'))).to eql('week 1,3 Mo 10:00-20:00')
  end
  it 'week 1,3 Mo 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3 Mo 10:00-20:00 "commentaire"'))).to eql('week 1,3 Mo 10:00-20:00 "commentaire"')
  end
  it 'week 1,3 Mo 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3 Mo 10:00-20:00 "commentaire avec des espaces"'))).to eql('week 1,3 Mo 10:00-20:00 "commentaire avec des espaces"')
  end
  it 'week 1,3 Mo off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3 Mo off'))).to eql('week 1,3 Mo off')
  end
  it 'week 1,3 Mo off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3 Mo off "commentaire"'))).to eql('week 1,3 Mo off "commentaire"')
  end
  it 'week 1,3 Mo off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3 Mo off "commentaire avec des espaces"'))).to eql('week 1,3 Mo off "commentaire avec des espaces"')
  end
  it 'week 1,3 Mo 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3 Mo 09:00-12:30,14:00-18:30'))).to eql('week 1,3 Mo 09:00-12:30,14:00-18:30')
  end
  it 'week 1,3 Mo 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3 Mo 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('week 1,3 Mo 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it 'week 1,3 Mo 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3 Mo 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('week 1,3 Mo 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it 'week 1,3 Mo,We-Fr,Su 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3 Mo,We-Fr,Su 10:00-20:00'))).to eql('week 1,3 Mo,We-Fr,Su 10:00-20:00')
  end
  it 'week 1,3 Mo,We-Fr,Su 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3 Mo,We-Fr,Su 10:00-20:00 "commentaire"'))).to eql('week 1,3 Mo,We-Fr,Su 10:00-20:00 "commentaire"')
  end
  it 'week 1,3 Mo,We-Fr,Su 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3 Mo,We-Fr,Su 10:00-20:00 "commentaire avec des espaces"'))).to eql('week 1,3 Mo,We-Fr,Su 10:00-20:00 "commentaire avec des espaces"')
  end
  it 'week 1,3 Mo,We-Fr,Su off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3 Mo,We-Fr,Su off'))).to eql('week 1,3 Mo,We-Fr,Su off')
  end
  it 'week 1,3 Mo,We-Fr,Su off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3 Mo,We-Fr,Su off "commentaire"'))).to eql('week 1,3 Mo,We-Fr,Su off "commentaire"')
  end
  it 'week 1,3 Mo,We-Fr,Su off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3 Mo,We-Fr,Su off "commentaire avec des espaces"'))).to eql('week 1,3 Mo,We-Fr,Su off "commentaire avec des espaces"')
  end
  it 'week 1,3 Mo,We-Fr,Su 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3 Mo,We-Fr,Su 09:00-12:30,14:00-18:30'))).to eql('week 1,3 Mo,We-Fr,Su 09:00-12:30,14:00-18:30')
  end
  it 'week 1,3 Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3 Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('week 1,3 Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it 'week 1,3 Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3 Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('week 1,3 Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it 'week 1,3 Mo-We,Fr,Sa 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3 Mo-We,Fr,Sa 10:00-20:00'))).to eql('week 1,3 Mo-We,Fr,Sa 10:00-20:00')
  end
  it 'week 1,3 Mo-We,Fr,Sa 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3 Mo-We,Fr,Sa 10:00-20:00 "commentaire"'))).to eql('week 1,3 Mo-We,Fr,Sa 10:00-20:00 "commentaire"')
  end
  it 'week 1,3 Mo-We,Fr,Sa 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3 Mo-We,Fr,Sa 10:00-20:00 "commentaire avec des espaces"'))).to eql('week 1,3 Mo-We,Fr,Sa 10:00-20:00 "commentaire avec des espaces"')
  end
  it 'week 1,3 Mo-We,Fr,Sa off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3 Mo-We,Fr,Sa off'))).to eql('week 1,3 Mo-We,Fr,Sa off')
  end
  it 'week 1,3 Mo-We,Fr,Sa off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3 Mo-We,Fr,Sa off "commentaire"'))).to eql('week 1,3 Mo-We,Fr,Sa off "commentaire"')
  end
  it 'week 1,3 Mo-We,Fr,Sa off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3 Mo-We,Fr,Sa off "commentaire avec des espaces"'))).to eql('week 1,3 Mo-We,Fr,Sa off "commentaire avec des espaces"')
  end
  it 'week 1,3 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30'))).to eql('week 1,3 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30')
  end
  it 'week 1,3 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('week 1,3 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it 'week 1,3 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('week 1,3 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it 'week 1,3 PH 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3 PH 10:00-20:00'))).to eql('week 1,3 PH 10:00-20:00')
  end
  it 'week 1,3 PH 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3 PH 10:00-20:00 "commentaire"'))).to eql('week 1,3 PH 10:00-20:00 "commentaire"')
  end
  it 'week 1,3 PH 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3 PH 10:00-20:00 "commentaire avec des espaces"'))).to eql('week 1,3 PH 10:00-20:00 "commentaire avec des espaces"')
  end
  it 'week 1,3 PH off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3 PH off'))).to eql('week 1,3 PH off')
  end
  it 'week 1,3 PH off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3 PH off "commentaire"'))).to eql('week 1,3 PH off "commentaire"')
  end
  it 'week 1,3 PH off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3 PH off "commentaire avec des espaces"'))).to eql('week 1,3 PH off "commentaire avec des espaces"')
  end
  it 'week 1,3 PH 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3 PH 09:00-12:30,14:00-18:30'))).to eql('week 1,3 PH 09:00-12:30,14:00-18:30')
  end
  it 'week 1,3 PH 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3 PH 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('week 1,3 PH 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it 'week 1,3 PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3 PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('week 1,3 PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it 'week 1,3 PH,Mo,We-Fr 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3 PH,Mo,We-Fr 10:00-20:00'))).to eql('week 1,3 PH,Mo,We-Fr 10:00-20:00')
  end
  it 'week 1,3 PH,Mo,We-Fr 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3 PH,Mo,We-Fr 10:00-20:00 "commentaire"'))).to eql('week 1,3 PH,Mo,We-Fr 10:00-20:00 "commentaire"')
  end
  it 'week 1,3 PH,Mo,We-Fr 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3 PH,Mo,We-Fr 10:00-20:00 "commentaire avec des espaces"'))).to eql('week 1,3 PH,Mo,We-Fr 10:00-20:00 "commentaire avec des espaces"')
  end
  it 'week 1,3 PH,Mo,We-Fr off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3 PH,Mo,We-Fr off'))).to eql('week 1,3 PH,Mo,We-Fr off')
  end
  it 'week 1,3 PH,Mo,We-Fr off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3 PH,Mo,We-Fr off "commentaire"'))).to eql('week 1,3 PH,Mo,We-Fr off "commentaire"')
  end
  it 'week 1,3 PH,Mo,We-Fr off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3 PH,Mo,We-Fr off "commentaire avec des espaces"'))).to eql('week 1,3 PH,Mo,We-Fr off "commentaire avec des espaces"')
  end
  it 'week 1,3 PH,Mo,We-Fr 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3 PH,Mo,We-Fr 09:00-12:30,14:00-18:30'))).to eql('week 1,3 PH,Mo,We-Fr 09:00-12:30,14:00-18:30')
  end
  it 'week 1,3 PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3 PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('week 1,3 PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it 'week 1,3 PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3 PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('week 1,3 PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it 'week 1,3,10-30 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30 10:00-20:00'))).to eql('week 1,3,10-30 10:00-20:00')
  end
  it 'week 1,3,10-30 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30 10:00-20:00 "commentaire"'))).to eql('week 1,3,10-30 10:00-20:00 "commentaire"')
  end
  it 'week 1,3,10-30 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30 10:00-20:00 "commentaire avec des espaces"'))).to eql('week 1,3,10-30 10:00-20:00 "commentaire avec des espaces"')
  end
  it 'week 1,3,10-30 off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30 off'))).to eql('week 1,3,10-30 off')
  end
  it 'week 1,3,10-30 off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30 off "commentaire"'))).to eql('week 1,3,10-30 off "commentaire"')
  end
  it 'week 1,3,10-30 off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30 off "commentaire avec des espaces"'))).to eql('week 1,3,10-30 off "commentaire avec des espaces"')
  end
  it 'week 1,3,10-30 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30 09:00-12:30,14:00-18:30'))).to eql('week 1,3,10-30 09:00-12:30,14:00-18:30')
  end
  it 'week 1,3,10-30 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('week 1,3,10-30 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it 'week 1,3,10-30 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('week 1,3,10-30 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it 'week 1,3,10-30 Mo 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30 Mo 10:00-20:00'))).to eql('week 1,3,10-30 Mo 10:00-20:00')
  end
  it 'week 1,3,10-30 Mo 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30 Mo 10:00-20:00 "commentaire"'))).to eql('week 1,3,10-30 Mo 10:00-20:00 "commentaire"')
  end
  it 'week 1,3,10-30 Mo 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30 Mo 10:00-20:00 "commentaire avec des espaces"'))).to eql('week 1,3,10-30 Mo 10:00-20:00 "commentaire avec des espaces"')
  end
  it 'week 1,3,10-30 Mo off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30 Mo off'))).to eql('week 1,3,10-30 Mo off')
  end
  it 'week 1,3,10-30 Mo off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30 Mo off "commentaire"'))).to eql('week 1,3,10-30 Mo off "commentaire"')
  end
  it 'week 1,3,10-30 Mo off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30 Mo off "commentaire avec des espaces"'))).to eql('week 1,3,10-30 Mo off "commentaire avec des espaces"')
  end
  it 'week 1,3,10-30 Mo 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30 Mo 09:00-12:30,14:00-18:30'))).to eql('week 1,3,10-30 Mo 09:00-12:30,14:00-18:30')
  end
  it 'week 1,3,10-30 Mo 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30 Mo 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('week 1,3,10-30 Mo 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it 'week 1,3,10-30 Mo 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30 Mo 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('week 1,3,10-30 Mo 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it 'week 1,3,10-30 Mo,We-Fr,Su 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30 Mo,We-Fr,Su 10:00-20:00'))).to eql('week 1,3,10-30 Mo,We-Fr,Su 10:00-20:00')
  end
  it 'week 1,3,10-30 Mo,We-Fr,Su 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30 Mo,We-Fr,Su 10:00-20:00 "commentaire"'))).to eql('week 1,3,10-30 Mo,We-Fr,Su 10:00-20:00 "commentaire"')
  end
  it 'week 1,3,10-30 Mo,We-Fr,Su 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30 Mo,We-Fr,Su 10:00-20:00 "commentaire avec des espaces"'))).to eql('week 1,3,10-30 Mo,We-Fr,Su 10:00-20:00 "commentaire avec des espaces"')
  end
  it 'week 1,3,10-30 Mo,We-Fr,Su off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30 Mo,We-Fr,Su off'))).to eql('week 1,3,10-30 Mo,We-Fr,Su off')
  end
  it 'week 1,3,10-30 Mo,We-Fr,Su off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30 Mo,We-Fr,Su off "commentaire"'))).to eql('week 1,3,10-30 Mo,We-Fr,Su off "commentaire"')
  end
  it 'week 1,3,10-30 Mo,We-Fr,Su off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30 Mo,We-Fr,Su off "commentaire avec des espaces"'))).to eql('week 1,3,10-30 Mo,We-Fr,Su off "commentaire avec des espaces"')
  end
  it 'week 1,3,10-30 Mo,We-Fr,Su 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30 Mo,We-Fr,Su 09:00-12:30,14:00-18:30'))).to eql('week 1,3,10-30 Mo,We-Fr,Su 09:00-12:30,14:00-18:30')
  end
  it 'week 1,3,10-30 Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30 Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('week 1,3,10-30 Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it 'week 1,3,10-30 Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30 Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('week 1,3,10-30 Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it 'week 1,3,10-30 Mo-We,Fr,Sa 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30 Mo-We,Fr,Sa 10:00-20:00'))).to eql('week 1,3,10-30 Mo-We,Fr,Sa 10:00-20:00')
  end
  it 'week 1,3,10-30 Mo-We,Fr,Sa 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30 Mo-We,Fr,Sa 10:00-20:00 "commentaire"'))).to eql('week 1,3,10-30 Mo-We,Fr,Sa 10:00-20:00 "commentaire"')
  end
  it 'week 1,3,10-30 Mo-We,Fr,Sa 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30 Mo-We,Fr,Sa 10:00-20:00 "commentaire avec des espaces"'))).to eql('week 1,3,10-30 Mo-We,Fr,Sa 10:00-20:00 "commentaire avec des espaces"')
  end
  it 'week 1,3,10-30 Mo-We,Fr,Sa off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30 Mo-We,Fr,Sa off'))).to eql('week 1,3,10-30 Mo-We,Fr,Sa off')
  end
  it 'week 1,3,10-30 Mo-We,Fr,Sa off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30 Mo-We,Fr,Sa off "commentaire"'))).to eql('week 1,3,10-30 Mo-We,Fr,Sa off "commentaire"')
  end
  it 'week 1,3,10-30 Mo-We,Fr,Sa off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30 Mo-We,Fr,Sa off "commentaire avec des espaces"'))).to eql('week 1,3,10-30 Mo-We,Fr,Sa off "commentaire avec des espaces"')
  end
  it 'week 1,3,10-30 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30'))).to eql('week 1,3,10-30 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30')
  end
  it 'week 1,3,10-30 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('week 1,3,10-30 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it 'week 1,3,10-30 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('week 1,3,10-30 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it 'week 1,3,10-30 PH 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30 PH 10:00-20:00'))).to eql('week 1,3,10-30 PH 10:00-20:00')
  end
  it 'week 1,3,10-30 PH 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30 PH 10:00-20:00 "commentaire"'))).to eql('week 1,3,10-30 PH 10:00-20:00 "commentaire"')
  end
  it 'week 1,3,10-30 PH 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30 PH 10:00-20:00 "commentaire avec des espaces"'))).to eql('week 1,3,10-30 PH 10:00-20:00 "commentaire avec des espaces"')
  end
  it 'week 1,3,10-30 PH off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30 PH off'))).to eql('week 1,3,10-30 PH off')
  end
  it 'week 1,3,10-30 PH off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30 PH off "commentaire"'))).to eql('week 1,3,10-30 PH off "commentaire"')
  end
  it 'week 1,3,10-30 PH off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30 PH off "commentaire avec des espaces"'))).to eql('week 1,3,10-30 PH off "commentaire avec des espaces"')
  end
  it 'week 1,3,10-30 PH 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30 PH 09:00-12:30,14:00-18:30'))).to eql('week 1,3,10-30 PH 09:00-12:30,14:00-18:30')
  end
  it 'week 1,3,10-30 PH 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30 PH 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('week 1,3,10-30 PH 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it 'week 1,3,10-30 PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30 PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('week 1,3,10-30 PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it 'week 1,3,10-30 PH,Mo,We-Fr 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30 PH,Mo,We-Fr 10:00-20:00'))).to eql('week 1,3,10-30 PH,Mo,We-Fr 10:00-20:00')
  end
  it 'week 1,3,10-30 PH,Mo,We-Fr 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30 PH,Mo,We-Fr 10:00-20:00 "commentaire"'))).to eql('week 1,3,10-30 PH,Mo,We-Fr 10:00-20:00 "commentaire"')
  end
  it 'week 1,3,10-30 PH,Mo,We-Fr 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30 PH,Mo,We-Fr 10:00-20:00 "commentaire avec des espaces"'))).to eql('week 1,3,10-30 PH,Mo,We-Fr 10:00-20:00 "commentaire avec des espaces"')
  end
  it 'week 1,3,10-30 PH,Mo,We-Fr off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30 PH,Mo,We-Fr off'))).to eql('week 1,3,10-30 PH,Mo,We-Fr off')
  end
  it 'week 1,3,10-30 PH,Mo,We-Fr off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30 PH,Mo,We-Fr off "commentaire"'))).to eql('week 1,3,10-30 PH,Mo,We-Fr off "commentaire"')
  end
  it 'week 1,3,10-30 PH,Mo,We-Fr off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30 PH,Mo,We-Fr off "commentaire avec des espaces"'))).to eql('week 1,3,10-30 PH,Mo,We-Fr off "commentaire avec des espaces"')
  end
  it 'week 1,3,10-30 PH,Mo,We-Fr 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30 PH,Mo,We-Fr 09:00-12:30,14:00-18:30'))).to eql('week 1,3,10-30 PH,Mo,We-Fr 09:00-12:30,14:00-18:30')
  end
  it 'week 1,3,10-30 PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30 PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('week 1,3,10-30 PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it 'week 1,3,10-30 PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30 PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('week 1,3,10-30 PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it 'week 1,3,10-30/2 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2 10:00-20:00'))).to eql('week 1,3,10-30/2 10:00-20:00')
  end
  it 'week 1,3,10-30/2 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2 10:00-20:00 "commentaire"'))).to eql('week 1,3,10-30/2 10:00-20:00 "commentaire"')
  end
  it 'week 1,3,10-30/2 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2 10:00-20:00 "commentaire avec des espaces"'))).to eql('week 1,3,10-30/2 10:00-20:00 "commentaire avec des espaces"')
  end
  it 'week 1,3,10-30/2 off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2 off'))).to eql('week 1,3,10-30/2 off')
  end
  it 'week 1,3,10-30/2 off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2 off "commentaire"'))).to eql('week 1,3,10-30/2 off "commentaire"')
  end
  it 'week 1,3,10-30/2 off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2 off "commentaire avec des espaces"'))).to eql('week 1,3,10-30/2 off "commentaire avec des espaces"')
  end
  it 'week 1,3,10-30/2 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2 09:00-12:30,14:00-18:30'))).to eql('week 1,3,10-30/2 09:00-12:30,14:00-18:30')
  end
  it 'week 1,3,10-30/2 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('week 1,3,10-30/2 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it 'week 1,3,10-30/2 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('week 1,3,10-30/2 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it 'week 1,3,10-30/2 Mo 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2 Mo 10:00-20:00'))).to eql('week 1,3,10-30/2 Mo 10:00-20:00')
  end
  it 'week 1,3,10-30/2 Mo 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2 Mo 10:00-20:00 "commentaire"'))).to eql('week 1,3,10-30/2 Mo 10:00-20:00 "commentaire"')
  end
  it 'week 1,3,10-30/2 Mo 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2 Mo 10:00-20:00 "commentaire avec des espaces"'))).to eql('week 1,3,10-30/2 Mo 10:00-20:00 "commentaire avec des espaces"')
  end
  it 'week 1,3,10-30/2 Mo off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2 Mo off'))).to eql('week 1,3,10-30/2 Mo off')
  end
  it 'week 1,3,10-30/2 Mo off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2 Mo off "commentaire"'))).to eql('week 1,3,10-30/2 Mo off "commentaire"')
  end
  it 'week 1,3,10-30/2 Mo off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2 Mo off "commentaire avec des espaces"'))).to eql('week 1,3,10-30/2 Mo off "commentaire avec des espaces"')
  end
  it 'week 1,3,10-30/2 Mo 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2 Mo 09:00-12:30,14:00-18:30'))).to eql('week 1,3,10-30/2 Mo 09:00-12:30,14:00-18:30')
  end
  it 'week 1,3,10-30/2 Mo 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2 Mo 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('week 1,3,10-30/2 Mo 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it 'week 1,3,10-30/2 Mo 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2 Mo 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('week 1,3,10-30/2 Mo 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it 'week 1,3,10-30/2 Mo,We-Fr,Su 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2 Mo,We-Fr,Su 10:00-20:00'))).to eql('week 1,3,10-30/2 Mo,We-Fr,Su 10:00-20:00')
  end
  it 'week 1,3,10-30/2 Mo,We-Fr,Su 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2 Mo,We-Fr,Su 10:00-20:00 "commentaire"'))).to eql('week 1,3,10-30/2 Mo,We-Fr,Su 10:00-20:00 "commentaire"')
  end
  it 'week 1,3,10-30/2 Mo,We-Fr,Su 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2 Mo,We-Fr,Su 10:00-20:00 "commentaire avec des espaces"'))).to eql('week 1,3,10-30/2 Mo,We-Fr,Su 10:00-20:00 "commentaire avec des espaces"')
  end
  it 'week 1,3,10-30/2 Mo,We-Fr,Su off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2 Mo,We-Fr,Su off'))).to eql('week 1,3,10-30/2 Mo,We-Fr,Su off')
  end
  it 'week 1,3,10-30/2 Mo,We-Fr,Su off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2 Mo,We-Fr,Su off "commentaire"'))).to eql('week 1,3,10-30/2 Mo,We-Fr,Su off "commentaire"')
  end
  it 'week 1,3,10-30/2 Mo,We-Fr,Su off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2 Mo,We-Fr,Su off "commentaire avec des espaces"'))).to eql('week 1,3,10-30/2 Mo,We-Fr,Su off "commentaire avec des espaces"')
  end
  it 'week 1,3,10-30/2 Mo,We-Fr,Su 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2 Mo,We-Fr,Su 09:00-12:30,14:00-18:30'))).to eql('week 1,3,10-30/2 Mo,We-Fr,Su 09:00-12:30,14:00-18:30')
  end
  it 'week 1,3,10-30/2 Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2 Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('week 1,3,10-30/2 Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it 'week 1,3,10-30/2 Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2 Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('week 1,3,10-30/2 Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it 'week 1,3,10-30/2 Mo-We,Fr,Sa 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2 Mo-We,Fr,Sa 10:00-20:00'))).to eql('week 1,3,10-30/2 Mo-We,Fr,Sa 10:00-20:00')
  end
  it 'week 1,3,10-30/2 Mo-We,Fr,Sa 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2 Mo-We,Fr,Sa 10:00-20:00 "commentaire"'))).to eql('week 1,3,10-30/2 Mo-We,Fr,Sa 10:00-20:00 "commentaire"')
  end
  it 'week 1,3,10-30/2 Mo-We,Fr,Sa 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2 Mo-We,Fr,Sa 10:00-20:00 "commentaire avec des espaces"'))).to eql('week 1,3,10-30/2 Mo-We,Fr,Sa 10:00-20:00 "commentaire avec des espaces"')
  end
  it 'week 1,3,10-30/2 Mo-We,Fr,Sa off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2 Mo-We,Fr,Sa off'))).to eql('week 1,3,10-30/2 Mo-We,Fr,Sa off')
  end
  it 'week 1,3,10-30/2 Mo-We,Fr,Sa off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2 Mo-We,Fr,Sa off "commentaire"'))).to eql('week 1,3,10-30/2 Mo-We,Fr,Sa off "commentaire"')
  end
  it 'week 1,3,10-30/2 Mo-We,Fr,Sa off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2 Mo-We,Fr,Sa off "commentaire avec des espaces"'))).to eql('week 1,3,10-30/2 Mo-We,Fr,Sa off "commentaire avec des espaces"')
  end
  it 'week 1,3,10-30/2 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30'))).to eql('week 1,3,10-30/2 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30')
  end
  it 'week 1,3,10-30/2 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('week 1,3,10-30/2 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it 'week 1,3,10-30/2 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('week 1,3,10-30/2 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it 'week 1,3,10-30/2 PH 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2 PH 10:00-20:00'))).to eql('week 1,3,10-30/2 PH 10:00-20:00')
  end
  it 'week 1,3,10-30/2 PH 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2 PH 10:00-20:00 "commentaire"'))).to eql('week 1,3,10-30/2 PH 10:00-20:00 "commentaire"')
  end
  it 'week 1,3,10-30/2 PH 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2 PH 10:00-20:00 "commentaire avec des espaces"'))).to eql('week 1,3,10-30/2 PH 10:00-20:00 "commentaire avec des espaces"')
  end
  it 'week 1,3,10-30/2 PH off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2 PH off'))).to eql('week 1,3,10-30/2 PH off')
  end
  it 'week 1,3,10-30/2 PH off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2 PH off "commentaire"'))).to eql('week 1,3,10-30/2 PH off "commentaire"')
  end
  it 'week 1,3,10-30/2 PH off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2 PH off "commentaire avec des espaces"'))).to eql('week 1,3,10-30/2 PH off "commentaire avec des espaces"')
  end
  it 'week 1,3,10-30/2 PH 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2 PH 09:00-12:30,14:00-18:30'))).to eql('week 1,3,10-30/2 PH 09:00-12:30,14:00-18:30')
  end
  it 'week 1,3,10-30/2 PH 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2 PH 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('week 1,3,10-30/2 PH 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it 'week 1,3,10-30/2 PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2 PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('week 1,3,10-30/2 PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it 'week 1,3,10-30/2 PH,Mo,We-Fr 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2 PH,Mo,We-Fr 10:00-20:00'))).to eql('week 1,3,10-30/2 PH,Mo,We-Fr 10:00-20:00')
  end
  it 'week 1,3,10-30/2 PH,Mo,We-Fr 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2 PH,Mo,We-Fr 10:00-20:00 "commentaire"'))).to eql('week 1,3,10-30/2 PH,Mo,We-Fr 10:00-20:00 "commentaire"')
  end
  it 'week 1,3,10-30/2 PH,Mo,We-Fr 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2 PH,Mo,We-Fr 10:00-20:00 "commentaire avec des espaces"'))).to eql('week 1,3,10-30/2 PH,Mo,We-Fr 10:00-20:00 "commentaire avec des espaces"')
  end
  it 'week 1,3,10-30/2 PH,Mo,We-Fr off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2 PH,Mo,We-Fr off'))).to eql('week 1,3,10-30/2 PH,Mo,We-Fr off')
  end
  it 'week 1,3,10-30/2 PH,Mo,We-Fr off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2 PH,Mo,We-Fr off "commentaire"'))).to eql('week 1,3,10-30/2 PH,Mo,We-Fr off "commentaire"')
  end
  it 'week 1,3,10-30/2 PH,Mo,We-Fr off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2 PH,Mo,We-Fr off "commentaire avec des espaces"'))).to eql('week 1,3,10-30/2 PH,Mo,We-Fr off "commentaire avec des espaces"')
  end
  it 'week 1,3,10-30/2 PH,Mo,We-Fr 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2 PH,Mo,We-Fr 09:00-12:30,14:00-18:30'))).to eql('week 1,3,10-30/2 PH,Mo,We-Fr 09:00-12:30,14:00-18:30')
  end
  it 'week 1,3,10-30/2 PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2 PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('week 1,3,10-30/2 PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it 'week 1,3,10-30/2 PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2 PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('week 1,3,10-30/2 PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it 'week 1,3,10-30/2,50 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2,50 10:00-20:00'))).to eql('week 1,3,10-30/2,50 10:00-20:00')
  end
  it 'week 1,3,10-30/2,50 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2,50 10:00-20:00 "commentaire"'))).to eql('week 1,3,10-30/2,50 10:00-20:00 "commentaire"')
  end
  it 'week 1,3,10-30/2,50 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2,50 10:00-20:00 "commentaire avec des espaces"'))).to eql('week 1,3,10-30/2,50 10:00-20:00 "commentaire avec des espaces"')
  end
  it 'week 1,3,10-30/2,50 off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2,50 off'))).to eql('week 1,3,10-30/2,50 off')
  end
  it 'week 1,3,10-30/2,50 off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2,50 off "commentaire"'))).to eql('week 1,3,10-30/2,50 off "commentaire"')
  end
  it 'week 1,3,10-30/2,50 off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2,50 off "commentaire avec des espaces"'))).to eql('week 1,3,10-30/2,50 off "commentaire avec des espaces"')
  end
  it 'week 1,3,10-30/2,50 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2,50 09:00-12:30,14:00-18:30'))).to eql('week 1,3,10-30/2,50 09:00-12:30,14:00-18:30')
  end
  it 'week 1,3,10-30/2,50 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2,50 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('week 1,3,10-30/2,50 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it 'week 1,3,10-30/2,50 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2,50 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('week 1,3,10-30/2,50 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it 'week 1,3,10-30/2,50 Mo 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2,50 Mo 10:00-20:00'))).to eql('week 1,3,10-30/2,50 Mo 10:00-20:00')
  end
  it 'week 1,3,10-30/2,50 Mo 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2,50 Mo 10:00-20:00 "commentaire"'))).to eql('week 1,3,10-30/2,50 Mo 10:00-20:00 "commentaire"')
  end
  it 'week 1,3,10-30/2,50 Mo 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2,50 Mo 10:00-20:00 "commentaire avec des espaces"'))).to eql('week 1,3,10-30/2,50 Mo 10:00-20:00 "commentaire avec des espaces"')
  end
  it 'week 1,3,10-30/2,50 Mo off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2,50 Mo off'))).to eql('week 1,3,10-30/2,50 Mo off')
  end
  it 'week 1,3,10-30/2,50 Mo off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2,50 Mo off "commentaire"'))).to eql('week 1,3,10-30/2,50 Mo off "commentaire"')
  end
  it 'week 1,3,10-30/2,50 Mo off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2,50 Mo off "commentaire avec des espaces"'))).to eql('week 1,3,10-30/2,50 Mo off "commentaire avec des espaces"')
  end
  it 'week 1,3,10-30/2,50 Mo 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2,50 Mo 09:00-12:30,14:00-18:30'))).to eql('week 1,3,10-30/2,50 Mo 09:00-12:30,14:00-18:30')
  end
  it 'week 1,3,10-30/2,50 Mo 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2,50 Mo 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('week 1,3,10-30/2,50 Mo 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it 'week 1,3,10-30/2,50 Mo 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2,50 Mo 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('week 1,3,10-30/2,50 Mo 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it 'week 1,3,10-30/2,50 Mo,We-Fr,Su 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2,50 Mo,We-Fr,Su 10:00-20:00'))).to eql('week 1,3,10-30/2,50 Mo,We-Fr,Su 10:00-20:00')
  end
  it 'week 1,3,10-30/2,50 Mo,We-Fr,Su 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2,50 Mo,We-Fr,Su 10:00-20:00 "commentaire"'))).to eql('week 1,3,10-30/2,50 Mo,We-Fr,Su 10:00-20:00 "commentaire"')
  end
  it 'week 1,3,10-30/2,50 Mo,We-Fr,Su 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2,50 Mo,We-Fr,Su 10:00-20:00 "commentaire avec des espaces"'))).to eql('week 1,3,10-30/2,50 Mo,We-Fr,Su 10:00-20:00 "commentaire avec des espaces"')
  end
  it 'week 1,3,10-30/2,50 Mo,We-Fr,Su off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2,50 Mo,We-Fr,Su off'))).to eql('week 1,3,10-30/2,50 Mo,We-Fr,Su off')
  end
  it 'week 1,3,10-30/2,50 Mo,We-Fr,Su off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2,50 Mo,We-Fr,Su off "commentaire"'))).to eql('week 1,3,10-30/2,50 Mo,We-Fr,Su off "commentaire"')
  end
  it 'week 1,3,10-30/2,50 Mo,We-Fr,Su off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2,50 Mo,We-Fr,Su off "commentaire avec des espaces"'))).to eql('week 1,3,10-30/2,50 Mo,We-Fr,Su off "commentaire avec des espaces"')
  end
  it 'week 1,3,10-30/2,50 Mo,We-Fr,Su 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2,50 Mo,We-Fr,Su 09:00-12:30,14:00-18:30'))).to eql('week 1,3,10-30/2,50 Mo,We-Fr,Su 09:00-12:30,14:00-18:30')
  end
  it 'week 1,3,10-30/2,50 Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2,50 Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('week 1,3,10-30/2,50 Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it 'week 1,3,10-30/2,50 Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2,50 Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('week 1,3,10-30/2,50 Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it 'week 1,3,10-30/2,50 Mo-We,Fr,Sa 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2,50 Mo-We,Fr,Sa 10:00-20:00'))).to eql('week 1,3,10-30/2,50 Mo-We,Fr,Sa 10:00-20:00')
  end
  it 'week 1,3,10-30/2,50 Mo-We,Fr,Sa 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2,50 Mo-We,Fr,Sa 10:00-20:00 "commentaire"'))).to eql('week 1,3,10-30/2,50 Mo-We,Fr,Sa 10:00-20:00 "commentaire"')
  end
  it 'week 1,3,10-30/2,50 Mo-We,Fr,Sa 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2,50 Mo-We,Fr,Sa 10:00-20:00 "commentaire avec des espaces"'))).to eql('week 1,3,10-30/2,50 Mo-We,Fr,Sa 10:00-20:00 "commentaire avec des espaces"')
  end
  it 'week 1,3,10-30/2,50 Mo-We,Fr,Sa off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2,50 Mo-We,Fr,Sa off'))).to eql('week 1,3,10-30/2,50 Mo-We,Fr,Sa off')
  end
  it 'week 1,3,10-30/2,50 Mo-We,Fr,Sa off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2,50 Mo-We,Fr,Sa off "commentaire"'))).to eql('week 1,3,10-30/2,50 Mo-We,Fr,Sa off "commentaire"')
  end
  it 'week 1,3,10-30/2,50 Mo-We,Fr,Sa off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2,50 Mo-We,Fr,Sa off "commentaire avec des espaces"'))).to eql('week 1,3,10-30/2,50 Mo-We,Fr,Sa off "commentaire avec des espaces"')
  end
  it 'week 1,3,10-30/2,50 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2,50 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30'))).to eql('week 1,3,10-30/2,50 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30')
  end
  it 'week 1,3,10-30/2,50 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2,50 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('week 1,3,10-30/2,50 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it 'week 1,3,10-30/2,50 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2,50 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('week 1,3,10-30/2,50 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it 'week 1,3,10-30/2,50 PH 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2,50 PH 10:00-20:00'))).to eql('week 1,3,10-30/2,50 PH 10:00-20:00')
  end
  it 'week 1,3,10-30/2,50 PH 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2,50 PH 10:00-20:00 "commentaire"'))).to eql('week 1,3,10-30/2,50 PH 10:00-20:00 "commentaire"')
  end
  it 'week 1,3,10-30/2,50 PH 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2,50 PH 10:00-20:00 "commentaire avec des espaces"'))).to eql('week 1,3,10-30/2,50 PH 10:00-20:00 "commentaire avec des espaces"')
  end
  it 'week 1,3,10-30/2,50 PH off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2,50 PH off'))).to eql('week 1,3,10-30/2,50 PH off')
  end
  it 'week 1,3,10-30/2,50 PH off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2,50 PH off "commentaire"'))).to eql('week 1,3,10-30/2,50 PH off "commentaire"')
  end
  it 'week 1,3,10-30/2,50 PH off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2,50 PH off "commentaire avec des espaces"'))).to eql('week 1,3,10-30/2,50 PH off "commentaire avec des espaces"')
  end
  it 'week 1,3,10-30/2,50 PH 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2,50 PH 09:00-12:30,14:00-18:30'))).to eql('week 1,3,10-30/2,50 PH 09:00-12:30,14:00-18:30')
  end
  it 'week 1,3,10-30/2,50 PH 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2,50 PH 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('week 1,3,10-30/2,50 PH 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it 'week 1,3,10-30/2,50 PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2,50 PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('week 1,3,10-30/2,50 PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it 'week 1,3,10-30/2,50 PH,Mo,We-Fr 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2,50 PH,Mo,We-Fr 10:00-20:00'))).to eql('week 1,3,10-30/2,50 PH,Mo,We-Fr 10:00-20:00')
  end
  it 'week 1,3,10-30/2,50 PH,Mo,We-Fr 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2,50 PH,Mo,We-Fr 10:00-20:00 "commentaire"'))).to eql('week 1,3,10-30/2,50 PH,Mo,We-Fr 10:00-20:00 "commentaire"')
  end
  it 'week 1,3,10-30/2,50 PH,Mo,We-Fr 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2,50 PH,Mo,We-Fr 10:00-20:00 "commentaire avec des espaces"'))).to eql('week 1,3,10-30/2,50 PH,Mo,We-Fr 10:00-20:00 "commentaire avec des espaces"')
  end
  it 'week 1,3,10-30/2,50 PH,Mo,We-Fr off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2,50 PH,Mo,We-Fr off'))).to eql('week 1,3,10-30/2,50 PH,Mo,We-Fr off')
  end
  it 'week 1,3,10-30/2,50 PH,Mo,We-Fr off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2,50 PH,Mo,We-Fr off "commentaire"'))).to eql('week 1,3,10-30/2,50 PH,Mo,We-Fr off "commentaire"')
  end
  it 'week 1,3,10-30/2,50 PH,Mo,We-Fr off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2,50 PH,Mo,We-Fr off "commentaire avec des espaces"'))).to eql('week 1,3,10-30/2,50 PH,Mo,We-Fr off "commentaire avec des espaces"')
  end
  it 'week 1,3,10-30/2,50 PH,Mo,We-Fr 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2,50 PH,Mo,We-Fr 09:00-12:30,14:00-18:30'))).to eql('week 1,3,10-30/2,50 PH,Mo,We-Fr 09:00-12:30,14:00-18:30')
  end
  it 'week 1,3,10-30/2,50 PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2,50 PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('week 1,3,10-30/2,50 PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it 'week 1,3,10-30/2,50 PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2,50 PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('week 1,3,10-30/2,50 PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it '2030 Jan 01-31 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-31 10:00-20:00'))).to eql('2030 Jan 01-31 10:00-20:00')
  end
  it '2030 Jan 01-31 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-31 10:00-20:00 "commentaire"'))).to eql('2030 Jan 01-31 10:00-20:00 "commentaire"')
  end
  it '2030 Jan 01-31 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-31 10:00-20:00 "commentaire avec des espaces"'))).to eql('2030 Jan 01-31 10:00-20:00 "commentaire avec des espaces"')
  end
  it '2030 Jan 01-31 off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-31 off'))).to eql('2030 Jan 01-31 off')
  end
  it '2030 Jan 01-31 off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-31 off "commentaire"'))).to eql('2030 Jan 01-31 off "commentaire"')
  end
  it '2030 Jan 01-31 off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-31 off "commentaire avec des espaces"'))).to eql('2030 Jan 01-31 off "commentaire avec des espaces"')
  end
  it '2030 Jan 01-31 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-31 09:00-12:30,14:00-18:30'))).to eql('2030 Jan 01-31 09:00-12:30,14:00-18:30')
  end
  it '2030 Jan 01-31 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-31 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('2030 Jan 01-31 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it '2030 Jan 01-31 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-31 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('2030 Jan 01-31 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it '2030 Jan 01-31 Mo 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-31 Mo 10:00-20:00'))).to eql('2030 Jan 01-31 Mo 10:00-20:00')
  end
  it '2030 Jan 01-31 Mo 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-31 Mo 10:00-20:00 "commentaire"'))).to eql('2030 Jan 01-31 Mo 10:00-20:00 "commentaire"')
  end
  it '2030 Jan 01-31 Mo 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-31 Mo 10:00-20:00 "commentaire avec des espaces"'))).to eql('2030 Jan 01-31 Mo 10:00-20:00 "commentaire avec des espaces"')
  end
  it '2030 Jan 01-31 Mo off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-31 Mo off'))).to eql('2030 Jan 01-31 Mo off')
  end
  it '2030 Jan 01-31 Mo off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-31 Mo off "commentaire"'))).to eql('2030 Jan 01-31 Mo off "commentaire"')
  end
  it '2030 Jan 01-31 Mo off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-31 Mo off "commentaire avec des espaces"'))).to eql('2030 Jan 01-31 Mo off "commentaire avec des espaces"')
  end
  it '2030 Jan 01-31 Mo 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-31 Mo 09:00-12:30,14:00-18:30'))).to eql('2030 Jan 01-31 Mo 09:00-12:30,14:00-18:30')
  end
  it '2030 Jan 01-31 Mo 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-31 Mo 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('2030 Jan 01-31 Mo 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it '2030 Jan 01-31 Mo 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-31 Mo 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('2030 Jan 01-31 Mo 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it '2030 Jan 01-31 Mo,We-Fr,Su 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-31 Mo,We-Fr,Su 10:00-20:00'))).to eql('2030 Jan 01-31 Mo,We-Fr,Su 10:00-20:00')
  end
  it '2030 Jan 01-31 Mo,We-Fr,Su 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-31 Mo,We-Fr,Su 10:00-20:00 "commentaire"'))).to eql('2030 Jan 01-31 Mo,We-Fr,Su 10:00-20:00 "commentaire"')
  end
  it '2030 Jan 01-31 Mo,We-Fr,Su 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-31 Mo,We-Fr,Su 10:00-20:00 "commentaire avec des espaces"'))).to eql('2030 Jan 01-31 Mo,We-Fr,Su 10:00-20:00 "commentaire avec des espaces"')
  end
  it '2030 Jan 01-31 Mo,We-Fr,Su off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-31 Mo,We-Fr,Su off'))).to eql('2030 Jan 01-31 Mo,We-Fr,Su off')
  end
  it '2030 Jan 01-31 Mo,We-Fr,Su off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-31 Mo,We-Fr,Su off "commentaire"'))).to eql('2030 Jan 01-31 Mo,We-Fr,Su off "commentaire"')
  end
  it '2030 Jan 01-31 Mo,We-Fr,Su off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-31 Mo,We-Fr,Su off "commentaire avec des espaces"'))).to eql('2030 Jan 01-31 Mo,We-Fr,Su off "commentaire avec des espaces"')
  end
  it '2030 Jan 01-31 Mo,We-Fr,Su 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-31 Mo,We-Fr,Su 09:00-12:30,14:00-18:30'))).to eql('2030 Jan 01-31 Mo,We-Fr,Su 09:00-12:30,14:00-18:30')
  end
  it '2030 Jan 01-31 Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-31 Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('2030 Jan 01-31 Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it '2030 Jan 01-31 Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-31 Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('2030 Jan 01-31 Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it '2030 Jan 01-31 Mo-We,Fr,Sa 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-31 Mo-We,Fr,Sa 10:00-20:00'))).to eql('2030 Jan 01-31 Mo-We,Fr,Sa 10:00-20:00')
  end
  it '2030 Jan 01-31 Mo-We,Fr,Sa 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-31 Mo-We,Fr,Sa 10:00-20:00 "commentaire"'))).to eql('2030 Jan 01-31 Mo-We,Fr,Sa 10:00-20:00 "commentaire"')
  end
  it '2030 Jan 01-31 Mo-We,Fr,Sa 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-31 Mo-We,Fr,Sa 10:00-20:00 "commentaire avec des espaces"'))).to eql('2030 Jan 01-31 Mo-We,Fr,Sa 10:00-20:00 "commentaire avec des espaces"')
  end
  it '2030 Jan 01-31 Mo-We,Fr,Sa off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-31 Mo-We,Fr,Sa off'))).to eql('2030 Jan 01-31 Mo-We,Fr,Sa off')
  end
  it '2030 Jan 01-31 Mo-We,Fr,Sa off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-31 Mo-We,Fr,Sa off "commentaire"'))).to eql('2030 Jan 01-31 Mo-We,Fr,Sa off "commentaire"')
  end
  it '2030 Jan 01-31 Mo-We,Fr,Sa off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-31 Mo-We,Fr,Sa off "commentaire avec des espaces"'))).to eql('2030 Jan 01-31 Mo-We,Fr,Sa off "commentaire avec des espaces"')
  end
  it '2030 Jan 01-31 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-31 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30'))).to eql('2030 Jan 01-31 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30')
  end
  it '2030 Jan 01-31 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-31 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('2030 Jan 01-31 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it '2030 Jan 01-31 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-31 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('2030 Jan 01-31 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it '2030 Jan 01-31 PH 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-31 PH 10:00-20:00'))).to eql('2030 Jan 01-31 PH 10:00-20:00')
  end
  it '2030 Jan 01-31 PH 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-31 PH 10:00-20:00 "commentaire"'))).to eql('2030 Jan 01-31 PH 10:00-20:00 "commentaire"')
  end
  it '2030 Jan 01-31 PH 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-31 PH 10:00-20:00 "commentaire avec des espaces"'))).to eql('2030 Jan 01-31 PH 10:00-20:00 "commentaire avec des espaces"')
  end
  it '2030 Jan 01-31 PH off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-31 PH off'))).to eql('2030 Jan 01-31 PH off')
  end
  it '2030 Jan 01-31 PH off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-31 PH off "commentaire"'))).to eql('2030 Jan 01-31 PH off "commentaire"')
  end
  it '2030 Jan 01-31 PH off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-31 PH off "commentaire avec des espaces"'))).to eql('2030 Jan 01-31 PH off "commentaire avec des espaces"')
  end
  it '2030 Jan 01-31 PH 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-31 PH 09:00-12:30,14:00-18:30'))).to eql('2030 Jan 01-31 PH 09:00-12:30,14:00-18:30')
  end
  it '2030 Jan 01-31 PH 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-31 PH 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('2030 Jan 01-31 PH 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it '2030 Jan 01-31 PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-31 PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('2030 Jan 01-31 PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it '2030 Jan 01-31 PH,Mo,We-Fr 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-31 PH,Mo,We-Fr 10:00-20:00'))).to eql('2030 Jan 01-31 PH,Mo,We-Fr 10:00-20:00')
  end
  it '2030 Jan 01-31 PH,Mo,We-Fr 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-31 PH,Mo,We-Fr 10:00-20:00 "commentaire"'))).to eql('2030 Jan 01-31 PH,Mo,We-Fr 10:00-20:00 "commentaire"')
  end
  it '2030 Jan 01-31 PH,Mo,We-Fr 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-31 PH,Mo,We-Fr 10:00-20:00 "commentaire avec des espaces"'))).to eql('2030 Jan 01-31 PH,Mo,We-Fr 10:00-20:00 "commentaire avec des espaces"')
  end
  it '2030 Jan 01-31 PH,Mo,We-Fr off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-31 PH,Mo,We-Fr off'))).to eql('2030 Jan 01-31 PH,Mo,We-Fr off')
  end
  it '2030 Jan 01-31 PH,Mo,We-Fr off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-31 PH,Mo,We-Fr off "commentaire"'))).to eql('2030 Jan 01-31 PH,Mo,We-Fr off "commentaire"')
  end
  it '2030 Jan 01-31 PH,Mo,We-Fr off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-31 PH,Mo,We-Fr off "commentaire avec des espaces"'))).to eql('2030 Jan 01-31 PH,Mo,We-Fr off "commentaire avec des espaces"')
  end
  it '2030 Jan 01-31 PH,Mo,We-Fr 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-31 PH,Mo,We-Fr 09:00-12:30,14:00-18:30'))).to eql('2030 Jan 01-31 PH,Mo,We-Fr 09:00-12:30,14:00-18:30')
  end
  it '2030 Jan 01-31 PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-31 PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('2030 Jan 01-31 PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it '2030 Jan 01-31 PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-31 PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('2030 Jan 01-31 PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it '2030 Jan 01-2030 Jun 30 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-2030 Jun 30 10:00-20:00'))).to eql('2030 Jan 01-2030 Jun 30 10:00-20:00')
  end
  it '2030 Jan 01-2030 Jun 30 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-2030 Jun 30 10:00-20:00 "commentaire"'))).to eql('2030 Jan 01-2030 Jun 30 10:00-20:00 "commentaire"')
  end
  it '2030 Jan 01-2030 Jun 30 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-2030 Jun 30 10:00-20:00 "commentaire avec des espaces"'))).to eql('2030 Jan 01-2030 Jun 30 10:00-20:00 "commentaire avec des espaces"')
  end
  it '2030 Jan 01-2030 Jun 30 off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-2030 Jun 30 off'))).to eql('2030 Jan 01-2030 Jun 30 off')
  end
  it '2030 Jan 01-2030 Jun 30 off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-2030 Jun 30 off "commentaire"'))).to eql('2030 Jan 01-2030 Jun 30 off "commentaire"')
  end
  it '2030 Jan 01-2030 Jun 30 off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-2030 Jun 30 off "commentaire avec des espaces"'))).to eql('2030 Jan 01-2030 Jun 30 off "commentaire avec des espaces"')
  end
  it '2030 Jan 01-2030 Jun 30 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-2030 Jun 30 09:00-12:30,14:00-18:30'))).to eql('2030 Jan 01-2030 Jun 30 09:00-12:30,14:00-18:30')
  end
  it '2030 Jan 01-2030 Jun 30 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-2030 Jun 30 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('2030 Jan 01-2030 Jun 30 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it '2030 Jan 01-2030 Jun 30 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-2030 Jun 30 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('2030 Jan 01-2030 Jun 30 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it '2030 Jan 01-2030 Jun 30 Mo 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-2030 Jun 30 Mo 10:00-20:00'))).to eql('2030 Jan 01-2030 Jun 30 Mo 10:00-20:00')
  end
  it '2030 Jan 01-2030 Jun 30 Mo 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-2030 Jun 30 Mo 10:00-20:00 "commentaire"'))).to eql('2030 Jan 01-2030 Jun 30 Mo 10:00-20:00 "commentaire"')
  end
  it '2030 Jan 01-2030 Jun 30 Mo 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-2030 Jun 30 Mo 10:00-20:00 "commentaire avec des espaces"'))).to eql('2030 Jan 01-2030 Jun 30 Mo 10:00-20:00 "commentaire avec des espaces"')
  end
  it '2030 Jan 01-2030 Jun 30 Mo off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-2030 Jun 30 Mo off'))).to eql('2030 Jan 01-2030 Jun 30 Mo off')
  end
  it '2030 Jan 01-2030 Jun 30 Mo off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-2030 Jun 30 Mo off "commentaire"'))).to eql('2030 Jan 01-2030 Jun 30 Mo off "commentaire"')
  end
  it '2030 Jan 01-2030 Jun 30 Mo off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-2030 Jun 30 Mo off "commentaire avec des espaces"'))).to eql('2030 Jan 01-2030 Jun 30 Mo off "commentaire avec des espaces"')
  end
  it '2030 Jan 01-2030 Jun 30 Mo 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-2030 Jun 30 Mo 09:00-12:30,14:00-18:30'))).to eql('2030 Jan 01-2030 Jun 30 Mo 09:00-12:30,14:00-18:30')
  end
  it '2030 Jan 01-2030 Jun 30 Mo 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-2030 Jun 30 Mo 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('2030 Jan 01-2030 Jun 30 Mo 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it '2030 Jan 01-2030 Jun 30 Mo 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-2030 Jun 30 Mo 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('2030 Jan 01-2030 Jun 30 Mo 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it '2030 Jan 01-2030 Jun 30 Mo,We-Fr,Su 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-2030 Jun 30 Mo,We-Fr,Su 10:00-20:00'))).to eql('2030 Jan 01-2030 Jun 30 Mo,We-Fr,Su 10:00-20:00')
  end
  it '2030 Jan 01-2030 Jun 30 Mo,We-Fr,Su 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-2030 Jun 30 Mo,We-Fr,Su 10:00-20:00 "commentaire"'))).to eql('2030 Jan 01-2030 Jun 30 Mo,We-Fr,Su 10:00-20:00 "commentaire"')
  end
  it '2030 Jan 01-2030 Jun 30 Mo,We-Fr,Su 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-2030 Jun 30 Mo,We-Fr,Su 10:00-20:00 "commentaire avec des espaces"'))).to eql('2030 Jan 01-2030 Jun 30 Mo,We-Fr,Su 10:00-20:00 "commentaire avec des espaces"')
  end
  it '2030 Jan 01-2030 Jun 30 Mo,We-Fr,Su off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-2030 Jun 30 Mo,We-Fr,Su off'))).to eql('2030 Jan 01-2030 Jun 30 Mo,We-Fr,Su off')
  end
  it '2030 Jan 01-2030 Jun 30 Mo,We-Fr,Su off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-2030 Jun 30 Mo,We-Fr,Su off "commentaire"'))).to eql('2030 Jan 01-2030 Jun 30 Mo,We-Fr,Su off "commentaire"')
  end
  it '2030 Jan 01-2030 Jun 30 Mo,We-Fr,Su off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-2030 Jun 30 Mo,We-Fr,Su off "commentaire avec des espaces"'))).to eql('2030 Jan 01-2030 Jun 30 Mo,We-Fr,Su off "commentaire avec des espaces"')
  end
  it '2030 Jan 01-2030 Jun 30 Mo,We-Fr,Su 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-2030 Jun 30 Mo,We-Fr,Su 09:00-12:30,14:00-18:30'))).to eql('2030 Jan 01-2030 Jun 30 Mo,We-Fr,Su 09:00-12:30,14:00-18:30')
  end
  it '2030 Jan 01-2030 Jun 30 Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-2030 Jun 30 Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('2030 Jan 01-2030 Jun 30 Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it '2030 Jan 01-2030 Jun 30 Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-2030 Jun 30 Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('2030 Jan 01-2030 Jun 30 Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it '2030 Jan 01-2030 Jun 30 Mo-We,Fr,Sa 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-2030 Jun 30 Mo-We,Fr,Sa 10:00-20:00'))).to eql('2030 Jan 01-2030 Jun 30 Mo-We,Fr,Sa 10:00-20:00')
  end
  it '2030 Jan 01-2030 Jun 30 Mo-We,Fr,Sa 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-2030 Jun 30 Mo-We,Fr,Sa 10:00-20:00 "commentaire"'))).to eql('2030 Jan 01-2030 Jun 30 Mo-We,Fr,Sa 10:00-20:00 "commentaire"')
  end
  it '2030 Jan 01-2030 Jun 30 Mo-We,Fr,Sa 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-2030 Jun 30 Mo-We,Fr,Sa 10:00-20:00 "commentaire avec des espaces"'))).to eql('2030 Jan 01-2030 Jun 30 Mo-We,Fr,Sa 10:00-20:00 "commentaire avec des espaces"')
  end
  it '2030 Jan 01-2030 Jun 30 Mo-We,Fr,Sa off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-2030 Jun 30 Mo-We,Fr,Sa off'))).to eql('2030 Jan 01-2030 Jun 30 Mo-We,Fr,Sa off')
  end
  it '2030 Jan 01-2030 Jun 30 Mo-We,Fr,Sa off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-2030 Jun 30 Mo-We,Fr,Sa off "commentaire"'))).to eql('2030 Jan 01-2030 Jun 30 Mo-We,Fr,Sa off "commentaire"')
  end
  it '2030 Jan 01-2030 Jun 30 Mo-We,Fr,Sa off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-2030 Jun 30 Mo-We,Fr,Sa off "commentaire avec des espaces"'))).to eql('2030 Jan 01-2030 Jun 30 Mo-We,Fr,Sa off "commentaire avec des espaces"')
  end
  it '2030 Jan 01-2030 Jun 30 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-2030 Jun 30 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30'))).to eql('2030 Jan 01-2030 Jun 30 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30')
  end
  it '2030 Jan 01-2030 Jun 30 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-2030 Jun 30 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('2030 Jan 01-2030 Jun 30 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it '2030 Jan 01-2030 Jun 30 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-2030 Jun 30 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('2030 Jan 01-2030 Jun 30 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it '2030 Jan 01-2030 Jun 30 PH 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-2030 Jun 30 PH 10:00-20:00'))).to eql('2030 Jan 01-2030 Jun 30 PH 10:00-20:00')
  end
  it '2030 Jan 01-2030 Jun 30 PH 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-2030 Jun 30 PH 10:00-20:00 "commentaire"'))).to eql('2030 Jan 01-2030 Jun 30 PH 10:00-20:00 "commentaire"')
  end
  it '2030 Jan 01-2030 Jun 30 PH 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-2030 Jun 30 PH 10:00-20:00 "commentaire avec des espaces"'))).to eql('2030 Jan 01-2030 Jun 30 PH 10:00-20:00 "commentaire avec des espaces"')
  end
  it '2030 Jan 01-2030 Jun 30 PH off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-2030 Jun 30 PH off'))).to eql('2030 Jan 01-2030 Jun 30 PH off')
  end
  it '2030 Jan 01-2030 Jun 30 PH off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-2030 Jun 30 PH off "commentaire"'))).to eql('2030 Jan 01-2030 Jun 30 PH off "commentaire"')
  end
  it '2030 Jan 01-2030 Jun 30 PH off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-2030 Jun 30 PH off "commentaire avec des espaces"'))).to eql('2030 Jan 01-2030 Jun 30 PH off "commentaire avec des espaces"')
  end
  it '2030 Jan 01-2030 Jun 30 PH 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-2030 Jun 30 PH 09:00-12:30,14:00-18:30'))).to eql('2030 Jan 01-2030 Jun 30 PH 09:00-12:30,14:00-18:30')
  end
  it '2030 Jan 01-2030 Jun 30 PH 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-2030 Jun 30 PH 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('2030 Jan 01-2030 Jun 30 PH 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it '2030 Jan 01-2030 Jun 30 PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-2030 Jun 30 PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('2030 Jan 01-2030 Jun 30 PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it '2030 Jan 01-2030 Jun 30 PH,Mo,We-Fr 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-2030 Jun 30 PH,Mo,We-Fr 10:00-20:00'))).to eql('2030 Jan 01-2030 Jun 30 PH,Mo,We-Fr 10:00-20:00')
  end
  it '2030 Jan 01-2030 Jun 30 PH,Mo,We-Fr 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-2030 Jun 30 PH,Mo,We-Fr 10:00-20:00 "commentaire"'))).to eql('2030 Jan 01-2030 Jun 30 PH,Mo,We-Fr 10:00-20:00 "commentaire"')
  end
  it '2030 Jan 01-2030 Jun 30 PH,Mo,We-Fr 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-2030 Jun 30 PH,Mo,We-Fr 10:00-20:00 "commentaire avec des espaces"'))).to eql('2030 Jan 01-2030 Jun 30 PH,Mo,We-Fr 10:00-20:00 "commentaire avec des espaces"')
  end
  it '2030 Jan 01-2030 Jun 30 PH,Mo,We-Fr off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-2030 Jun 30 PH,Mo,We-Fr off'))).to eql('2030 Jan 01-2030 Jun 30 PH,Mo,We-Fr off')
  end
  it '2030 Jan 01-2030 Jun 30 PH,Mo,We-Fr off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-2030 Jun 30 PH,Mo,We-Fr off "commentaire"'))).to eql('2030 Jan 01-2030 Jun 30 PH,Mo,We-Fr off "commentaire"')
  end
  it '2030 Jan 01-2030 Jun 30 PH,Mo,We-Fr off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-2030 Jun 30 PH,Mo,We-Fr off "commentaire avec des espaces"'))).to eql('2030 Jan 01-2030 Jun 30 PH,Mo,We-Fr off "commentaire avec des espaces"')
  end
  it '2030 Jan 01-2030 Jun 30 PH,Mo,We-Fr 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-2030 Jun 30 PH,Mo,We-Fr 09:00-12:30,14:00-18:30'))).to eql('2030 Jan 01-2030 Jun 30 PH,Mo,We-Fr 09:00-12:30,14:00-18:30')
  end
  it '2030 Jan 01-2030 Jun 30 PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-2030 Jun 30 PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('2030 Jan 01-2030 Jun 30 PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it '2030 Jan 01-2030 Jun 30 PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-2030 Jun 30 PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('2030 Jan 01-2030 Jun 30 PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it '2030 Jan 01-2050 Jun 30 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-2050 Jun 30 10:00-20:00'))).to eql('2030 Jan 01-2050 Jun 30 10:00-20:00')
  end
  it '2030 Jan 01-2050 Jun 30 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-2050 Jun 30 10:00-20:00 "commentaire"'))).to eql('2030 Jan 01-2050 Jun 30 10:00-20:00 "commentaire"')
  end
  it '2030 Jan 01-2050 Jun 30 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-2050 Jun 30 10:00-20:00 "commentaire avec des espaces"'))).to eql('2030 Jan 01-2050 Jun 30 10:00-20:00 "commentaire avec des espaces"')
  end
  it '2030 Jan 01-2050 Jun 30 off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-2050 Jun 30 off'))).to eql('2030 Jan 01-2050 Jun 30 off')
  end
  it '2030 Jan 01-2050 Jun 30 off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-2050 Jun 30 off "commentaire"'))).to eql('2030 Jan 01-2050 Jun 30 off "commentaire"')
  end
  it '2030 Jan 01-2050 Jun 30 off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-2050 Jun 30 off "commentaire avec des espaces"'))).to eql('2030 Jan 01-2050 Jun 30 off "commentaire avec des espaces"')
  end
  it '2030 Jan 01-2050 Jun 30 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-2050 Jun 30 09:00-12:30,14:00-18:30'))).to eql('2030 Jan 01-2050 Jun 30 09:00-12:30,14:00-18:30')
  end
  it '2030 Jan 01-2050 Jun 30 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-2050 Jun 30 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('2030 Jan 01-2050 Jun 30 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it '2030 Jan 01-2050 Jun 30 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-2050 Jun 30 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('2030 Jan 01-2050 Jun 30 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it '2030 Jan 01-2050 Jun 30 Mo 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-2050 Jun 30 Mo 10:00-20:00'))).to eql('2030 Jan 01-2050 Jun 30 Mo 10:00-20:00')
  end
  it '2030 Jan 01-2050 Jun 30 Mo 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-2050 Jun 30 Mo 10:00-20:00 "commentaire"'))).to eql('2030 Jan 01-2050 Jun 30 Mo 10:00-20:00 "commentaire"')
  end
  it '2030 Jan 01-2050 Jun 30 Mo 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-2050 Jun 30 Mo 10:00-20:00 "commentaire avec des espaces"'))).to eql('2030 Jan 01-2050 Jun 30 Mo 10:00-20:00 "commentaire avec des espaces"')
  end
  it '2030 Jan 01-2050 Jun 30 Mo off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-2050 Jun 30 Mo off'))).to eql('2030 Jan 01-2050 Jun 30 Mo off')
  end
  it '2030 Jan 01-2050 Jun 30 Mo off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-2050 Jun 30 Mo off "commentaire"'))).to eql('2030 Jan 01-2050 Jun 30 Mo off "commentaire"')
  end
  it '2030 Jan 01-2050 Jun 30 Mo off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-2050 Jun 30 Mo off "commentaire avec des espaces"'))).to eql('2030 Jan 01-2050 Jun 30 Mo off "commentaire avec des espaces"')
  end
  it '2030 Jan 01-2050 Jun 30 Mo 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-2050 Jun 30 Mo 09:00-12:30,14:00-18:30'))).to eql('2030 Jan 01-2050 Jun 30 Mo 09:00-12:30,14:00-18:30')
  end
  it '2030 Jan 01-2050 Jun 30 Mo 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-2050 Jun 30 Mo 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('2030 Jan 01-2050 Jun 30 Mo 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it '2030 Jan 01-2050 Jun 30 Mo 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-2050 Jun 30 Mo 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('2030 Jan 01-2050 Jun 30 Mo 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it '2030 Jan 01-2050 Jun 30 Mo,We-Fr,Su 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-2050 Jun 30 Mo,We-Fr,Su 10:00-20:00'))).to eql('2030 Jan 01-2050 Jun 30 Mo,We-Fr,Su 10:00-20:00')
  end
  it '2030 Jan 01-2050 Jun 30 Mo,We-Fr,Su 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-2050 Jun 30 Mo,We-Fr,Su 10:00-20:00 "commentaire"'))).to eql('2030 Jan 01-2050 Jun 30 Mo,We-Fr,Su 10:00-20:00 "commentaire"')
  end
  it '2030 Jan 01-2050 Jun 30 Mo,We-Fr,Su 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-2050 Jun 30 Mo,We-Fr,Su 10:00-20:00 "commentaire avec des espaces"'))).to eql('2030 Jan 01-2050 Jun 30 Mo,We-Fr,Su 10:00-20:00 "commentaire avec des espaces"')
  end
  it '2030 Jan 01-2050 Jun 30 Mo,We-Fr,Su off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-2050 Jun 30 Mo,We-Fr,Su off'))).to eql('2030 Jan 01-2050 Jun 30 Mo,We-Fr,Su off')
  end
  it '2030 Jan 01-2050 Jun 30 Mo,We-Fr,Su off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-2050 Jun 30 Mo,We-Fr,Su off "commentaire"'))).to eql('2030 Jan 01-2050 Jun 30 Mo,We-Fr,Su off "commentaire"')
  end
  it '2030 Jan 01-2050 Jun 30 Mo,We-Fr,Su off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-2050 Jun 30 Mo,We-Fr,Su off "commentaire avec des espaces"'))).to eql('2030 Jan 01-2050 Jun 30 Mo,We-Fr,Su off "commentaire avec des espaces"')
  end
  it '2030 Jan 01-2050 Jun 30 Mo,We-Fr,Su 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-2050 Jun 30 Mo,We-Fr,Su 09:00-12:30,14:00-18:30'))).to eql('2030 Jan 01-2050 Jun 30 Mo,We-Fr,Su 09:00-12:30,14:00-18:30')
  end
  it '2030 Jan 01-2050 Jun 30 Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-2050 Jun 30 Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('2030 Jan 01-2050 Jun 30 Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it '2030 Jan 01-2050 Jun 30 Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-2050 Jun 30 Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('2030 Jan 01-2050 Jun 30 Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it '2030 Jan 01-2050 Jun 30 Mo-We,Fr,Sa 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-2050 Jun 30 Mo-We,Fr,Sa 10:00-20:00'))).to eql('2030 Jan 01-2050 Jun 30 Mo-We,Fr,Sa 10:00-20:00')
  end
  it '2030 Jan 01-2050 Jun 30 Mo-We,Fr,Sa 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-2050 Jun 30 Mo-We,Fr,Sa 10:00-20:00 "commentaire"'))).to eql('2030 Jan 01-2050 Jun 30 Mo-We,Fr,Sa 10:00-20:00 "commentaire"')
  end
  it '2030 Jan 01-2050 Jun 30 Mo-We,Fr,Sa 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-2050 Jun 30 Mo-We,Fr,Sa 10:00-20:00 "commentaire avec des espaces"'))).to eql('2030 Jan 01-2050 Jun 30 Mo-We,Fr,Sa 10:00-20:00 "commentaire avec des espaces"')
  end
  it '2030 Jan 01-2050 Jun 30 Mo-We,Fr,Sa off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-2050 Jun 30 Mo-We,Fr,Sa off'))).to eql('2030 Jan 01-2050 Jun 30 Mo-We,Fr,Sa off')
  end
  it '2030 Jan 01-2050 Jun 30 Mo-We,Fr,Sa off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-2050 Jun 30 Mo-We,Fr,Sa off "commentaire"'))).to eql('2030 Jan 01-2050 Jun 30 Mo-We,Fr,Sa off "commentaire"')
  end
  it '2030 Jan 01-2050 Jun 30 Mo-We,Fr,Sa off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-2050 Jun 30 Mo-We,Fr,Sa off "commentaire avec des espaces"'))).to eql('2030 Jan 01-2050 Jun 30 Mo-We,Fr,Sa off "commentaire avec des espaces"')
  end
  it '2030 Jan 01-2050 Jun 30 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-2050 Jun 30 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30'))).to eql('2030 Jan 01-2050 Jun 30 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30')
  end
  it '2030 Jan 01-2050 Jun 30 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-2050 Jun 30 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('2030 Jan 01-2050 Jun 30 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it '2030 Jan 01-2050 Jun 30 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-2050 Jun 30 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('2030 Jan 01-2050 Jun 30 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it '2030 Jan 01-2050 Jun 30 PH 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-2050 Jun 30 PH 10:00-20:00'))).to eql('2030 Jan 01-2050 Jun 30 PH 10:00-20:00')
  end
  it '2030 Jan 01-2050 Jun 30 PH 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-2050 Jun 30 PH 10:00-20:00 "commentaire"'))).to eql('2030 Jan 01-2050 Jun 30 PH 10:00-20:00 "commentaire"')
  end
  it '2030 Jan 01-2050 Jun 30 PH 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-2050 Jun 30 PH 10:00-20:00 "commentaire avec des espaces"'))).to eql('2030 Jan 01-2050 Jun 30 PH 10:00-20:00 "commentaire avec des espaces"')
  end
  it '2030 Jan 01-2050 Jun 30 PH off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-2050 Jun 30 PH off'))).to eql('2030 Jan 01-2050 Jun 30 PH off')
  end
  it '2030 Jan 01-2050 Jun 30 PH off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-2050 Jun 30 PH off "commentaire"'))).to eql('2030 Jan 01-2050 Jun 30 PH off "commentaire"')
  end
  it '2030 Jan 01-2050 Jun 30 PH off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-2050 Jun 30 PH off "commentaire avec des espaces"'))).to eql('2030 Jan 01-2050 Jun 30 PH off "commentaire avec des espaces"')
  end
  it '2030 Jan 01-2050 Jun 30 PH 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-2050 Jun 30 PH 09:00-12:30,14:00-18:30'))).to eql('2030 Jan 01-2050 Jun 30 PH 09:00-12:30,14:00-18:30')
  end
  it '2030 Jan 01-2050 Jun 30 PH 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-2050 Jun 30 PH 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('2030 Jan 01-2050 Jun 30 PH 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it '2030 Jan 01-2050 Jun 30 PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-2050 Jun 30 PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('2030 Jan 01-2050 Jun 30 PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it '2030 Jan 01-2050 Jun 30 PH,Mo,We-Fr 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-2050 Jun 30 PH,Mo,We-Fr 10:00-20:00'))).to eql('2030 Jan 01-2050 Jun 30 PH,Mo,We-Fr 10:00-20:00')
  end
  it '2030 Jan 01-2050 Jun 30 PH,Mo,We-Fr 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-2050 Jun 30 PH,Mo,We-Fr 10:00-20:00 "commentaire"'))).to eql('2030 Jan 01-2050 Jun 30 PH,Mo,We-Fr 10:00-20:00 "commentaire"')
  end
  it '2030 Jan 01-2050 Jun 30 PH,Mo,We-Fr 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-2050 Jun 30 PH,Mo,We-Fr 10:00-20:00 "commentaire avec des espaces"'))).to eql('2030 Jan 01-2050 Jun 30 PH,Mo,We-Fr 10:00-20:00 "commentaire avec des espaces"')
  end
  it '2030 Jan 01-2050 Jun 30 PH,Mo,We-Fr off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-2050 Jun 30 PH,Mo,We-Fr off'))).to eql('2030 Jan 01-2050 Jun 30 PH,Mo,We-Fr off')
  end
  it '2030 Jan 01-2050 Jun 30 PH,Mo,We-Fr off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-2050 Jun 30 PH,Mo,We-Fr off "commentaire"'))).to eql('2030 Jan 01-2050 Jun 30 PH,Mo,We-Fr off "commentaire"')
  end
  it '2030 Jan 01-2050 Jun 30 PH,Mo,We-Fr off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-2050 Jun 30 PH,Mo,We-Fr off "commentaire avec des espaces"'))).to eql('2030 Jan 01-2050 Jun 30 PH,Mo,We-Fr off "commentaire avec des espaces"')
  end
  it '2030 Jan 01-2050 Jun 30 PH,Mo,We-Fr 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-2050 Jun 30 PH,Mo,We-Fr 09:00-12:30,14:00-18:30'))).to eql('2030 Jan 01-2050 Jun 30 PH,Mo,We-Fr 09:00-12:30,14:00-18:30')
  end
  it '2030 Jan 01-2050 Jun 30 PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-2050 Jun 30 PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('2030 Jan 01-2050 Jun 30 PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it '2030 Jan 01-2050 Jun 30 PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01-2050 Jun 30 PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('2030 Jan 01-2050 Jun 30 PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it '2030 Jan 10-2050 Jun 30 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 10-2050 Jun 30 10:00-20:00'))).to eql('2030 Jan 10-2050 Jun 30 10:00-20:00')
  end
  it '2030 Jan 10-2050 Jun 30 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 10-2050 Jun 30 10:00-20:00 "commentaire"'))).to eql('2030 Jan 10-2050 Jun 30 10:00-20:00 "commentaire"')
  end
  it '2030 Jan 10-2050 Jun 30 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 10-2050 Jun 30 10:00-20:00 "commentaire avec des espaces"'))).to eql('2030 Jan 10-2050 Jun 30 10:00-20:00 "commentaire avec des espaces"')
  end
  it '2030 Jan 10-2050 Jun 30 off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 10-2050 Jun 30 off'))).to eql('2030 Jan 10-2050 Jun 30 off')
  end
  it '2030 Jan 10-2050 Jun 30 off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 10-2050 Jun 30 off "commentaire"'))).to eql('2030 Jan 10-2050 Jun 30 off "commentaire"')
  end
  it '2030 Jan 10-2050 Jun 30 off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 10-2050 Jun 30 off "commentaire avec des espaces"'))).to eql('2030 Jan 10-2050 Jun 30 off "commentaire avec des espaces"')
  end
  it '2030 Jan 10-2050 Jun 30 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 10-2050 Jun 30 09:00-12:30,14:00-18:30'))).to eql('2030 Jan 10-2050 Jun 30 09:00-12:30,14:00-18:30')
  end
  it '2030 Jan 10-2050 Jun 30 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 10-2050 Jun 30 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('2030 Jan 10-2050 Jun 30 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it '2030 Jan 10-2050 Jun 30 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 10-2050 Jun 30 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('2030 Jan 10-2050 Jun 30 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it '2030 Jan 10-2050 Jun 30 Mo 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 10-2050 Jun 30 Mo 10:00-20:00'))).to eql('2030 Jan 10-2050 Jun 30 Mo 10:00-20:00')
  end
  it '2030 Jan 10-2050 Jun 30 Mo 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 10-2050 Jun 30 Mo 10:00-20:00 "commentaire"'))).to eql('2030 Jan 10-2050 Jun 30 Mo 10:00-20:00 "commentaire"')
  end
  it '2030 Jan 10-2050 Jun 30 Mo 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 10-2050 Jun 30 Mo 10:00-20:00 "commentaire avec des espaces"'))).to eql('2030 Jan 10-2050 Jun 30 Mo 10:00-20:00 "commentaire avec des espaces"')
  end
  it '2030 Jan 10-2050 Jun 30 Mo off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 10-2050 Jun 30 Mo off'))).to eql('2030 Jan 10-2050 Jun 30 Mo off')
  end
  it '2030 Jan 10-2050 Jun 30 Mo off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 10-2050 Jun 30 Mo off "commentaire"'))).to eql('2030 Jan 10-2050 Jun 30 Mo off "commentaire"')
  end
  it '2030 Jan 10-2050 Jun 30 Mo off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 10-2050 Jun 30 Mo off "commentaire avec des espaces"'))).to eql('2030 Jan 10-2050 Jun 30 Mo off "commentaire avec des espaces"')
  end
  it '2030 Jan 10-2050 Jun 30 Mo 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 10-2050 Jun 30 Mo 09:00-12:30,14:00-18:30'))).to eql('2030 Jan 10-2050 Jun 30 Mo 09:00-12:30,14:00-18:30')
  end
  it '2030 Jan 10-2050 Jun 30 Mo 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 10-2050 Jun 30 Mo 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('2030 Jan 10-2050 Jun 30 Mo 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it '2030 Jan 10-2050 Jun 30 Mo 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 10-2050 Jun 30 Mo 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('2030 Jan 10-2050 Jun 30 Mo 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it '2030 Jan 10-2050 Jun 30 Mo,We-Fr,Su 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 10-2050 Jun 30 Mo,We-Fr,Su 10:00-20:00'))).to eql('2030 Jan 10-2050 Jun 30 Mo,We-Fr,Su 10:00-20:00')
  end
  it '2030 Jan 10-2050 Jun 30 Mo,We-Fr,Su 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 10-2050 Jun 30 Mo,We-Fr,Su 10:00-20:00 "commentaire"'))).to eql('2030 Jan 10-2050 Jun 30 Mo,We-Fr,Su 10:00-20:00 "commentaire"')
  end
  it '2030 Jan 10-2050 Jun 30 Mo,We-Fr,Su 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 10-2050 Jun 30 Mo,We-Fr,Su 10:00-20:00 "commentaire avec des espaces"'))).to eql('2030 Jan 10-2050 Jun 30 Mo,We-Fr,Su 10:00-20:00 "commentaire avec des espaces"')
  end
  it '2030 Jan 10-2050 Jun 30 Mo,We-Fr,Su off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 10-2050 Jun 30 Mo,We-Fr,Su off'))).to eql('2030 Jan 10-2050 Jun 30 Mo,We-Fr,Su off')
  end
  it '2030 Jan 10-2050 Jun 30 Mo,We-Fr,Su off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 10-2050 Jun 30 Mo,We-Fr,Su off "commentaire"'))).to eql('2030 Jan 10-2050 Jun 30 Mo,We-Fr,Su off "commentaire"')
  end
  it '2030 Jan 10-2050 Jun 30 Mo,We-Fr,Su off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 10-2050 Jun 30 Mo,We-Fr,Su off "commentaire avec des espaces"'))).to eql('2030 Jan 10-2050 Jun 30 Mo,We-Fr,Su off "commentaire avec des espaces"')
  end
  it '2030 Jan 10-2050 Jun 30 Mo,We-Fr,Su 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 10-2050 Jun 30 Mo,We-Fr,Su 09:00-12:30,14:00-18:30'))).to eql('2030 Jan 10-2050 Jun 30 Mo,We-Fr,Su 09:00-12:30,14:00-18:30')
  end
  it '2030 Jan 10-2050 Jun 30 Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 10-2050 Jun 30 Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('2030 Jan 10-2050 Jun 30 Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it '2030 Jan 10-2050 Jun 30 Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 10-2050 Jun 30 Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('2030 Jan 10-2050 Jun 30 Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it '2030 Jan 10-2050 Jun 30 Mo-We,Fr,Sa 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 10-2050 Jun 30 Mo-We,Fr,Sa 10:00-20:00'))).to eql('2030 Jan 10-2050 Jun 30 Mo-We,Fr,Sa 10:00-20:00')
  end
  it '2030 Jan 10-2050 Jun 30 Mo-We,Fr,Sa 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 10-2050 Jun 30 Mo-We,Fr,Sa 10:00-20:00 "commentaire"'))).to eql('2030 Jan 10-2050 Jun 30 Mo-We,Fr,Sa 10:00-20:00 "commentaire"')
  end
  it '2030 Jan 10-2050 Jun 30 Mo-We,Fr,Sa 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 10-2050 Jun 30 Mo-We,Fr,Sa 10:00-20:00 "commentaire avec des espaces"'))).to eql('2030 Jan 10-2050 Jun 30 Mo-We,Fr,Sa 10:00-20:00 "commentaire avec des espaces"')
  end
  it '2030 Jan 10-2050 Jun 30 Mo-We,Fr,Sa off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 10-2050 Jun 30 Mo-We,Fr,Sa off'))).to eql('2030 Jan 10-2050 Jun 30 Mo-We,Fr,Sa off')
  end
  it '2030 Jan 10-2050 Jun 30 Mo-We,Fr,Sa off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 10-2050 Jun 30 Mo-We,Fr,Sa off "commentaire"'))).to eql('2030 Jan 10-2050 Jun 30 Mo-We,Fr,Sa off "commentaire"')
  end
  it '2030 Jan 10-2050 Jun 30 Mo-We,Fr,Sa off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 10-2050 Jun 30 Mo-We,Fr,Sa off "commentaire avec des espaces"'))).to eql('2030 Jan 10-2050 Jun 30 Mo-We,Fr,Sa off "commentaire avec des espaces"')
  end
  it '2030 Jan 10-2050 Jun 30 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 10-2050 Jun 30 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30'))).to eql('2030 Jan 10-2050 Jun 30 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30')
  end
  it '2030 Jan 10-2050 Jun 30 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 10-2050 Jun 30 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('2030 Jan 10-2050 Jun 30 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it '2030 Jan 10-2050 Jun 30 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 10-2050 Jun 30 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('2030 Jan 10-2050 Jun 30 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it '2030 Jan 10-2050 Jun 30 PH 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 10-2050 Jun 30 PH 10:00-20:00'))).to eql('2030 Jan 10-2050 Jun 30 PH 10:00-20:00')
  end
  it '2030 Jan 10-2050 Jun 30 PH 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 10-2050 Jun 30 PH 10:00-20:00 "commentaire"'))).to eql('2030 Jan 10-2050 Jun 30 PH 10:00-20:00 "commentaire"')
  end
  it '2030 Jan 10-2050 Jun 30 PH 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 10-2050 Jun 30 PH 10:00-20:00 "commentaire avec des espaces"'))).to eql('2030 Jan 10-2050 Jun 30 PH 10:00-20:00 "commentaire avec des espaces"')
  end
  it '2030 Jan 10-2050 Jun 30 PH off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 10-2050 Jun 30 PH off'))).to eql('2030 Jan 10-2050 Jun 30 PH off')
  end
  it '2030 Jan 10-2050 Jun 30 PH off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 10-2050 Jun 30 PH off "commentaire"'))).to eql('2030 Jan 10-2050 Jun 30 PH off "commentaire"')
  end
  it '2030 Jan 10-2050 Jun 30 PH off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 10-2050 Jun 30 PH off "commentaire avec des espaces"'))).to eql('2030 Jan 10-2050 Jun 30 PH off "commentaire avec des espaces"')
  end
  it '2030 Jan 10-2050 Jun 30 PH 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 10-2050 Jun 30 PH 09:00-12:30,14:00-18:30'))).to eql('2030 Jan 10-2050 Jun 30 PH 09:00-12:30,14:00-18:30')
  end
  it '2030 Jan 10-2050 Jun 30 PH 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 10-2050 Jun 30 PH 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('2030 Jan 10-2050 Jun 30 PH 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it '2030 Jan 10-2050 Jun 30 PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 10-2050 Jun 30 PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('2030 Jan 10-2050 Jun 30 PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it '2030 Jan 10-2050 Jun 30 PH,Mo,We-Fr 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 10-2050 Jun 30 PH,Mo,We-Fr 10:00-20:00'))).to eql('2030 Jan 10-2050 Jun 30 PH,Mo,We-Fr 10:00-20:00')
  end
  it '2030 Jan 10-2050 Jun 30 PH,Mo,We-Fr 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 10-2050 Jun 30 PH,Mo,We-Fr 10:00-20:00 "commentaire"'))).to eql('2030 Jan 10-2050 Jun 30 PH,Mo,We-Fr 10:00-20:00 "commentaire"')
  end
  it '2030 Jan 10-2050 Jun 30 PH,Mo,We-Fr 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 10-2050 Jun 30 PH,Mo,We-Fr 10:00-20:00 "commentaire avec des espaces"'))).to eql('2030 Jan 10-2050 Jun 30 PH,Mo,We-Fr 10:00-20:00 "commentaire avec des espaces"')
  end
  it '2030 Jan 10-2050 Jun 30 PH,Mo,We-Fr off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 10-2050 Jun 30 PH,Mo,We-Fr off'))).to eql('2030 Jan 10-2050 Jun 30 PH,Mo,We-Fr off')
  end
  it '2030 Jan 10-2050 Jun 30 PH,Mo,We-Fr off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 10-2050 Jun 30 PH,Mo,We-Fr off "commentaire"'))).to eql('2030 Jan 10-2050 Jun 30 PH,Mo,We-Fr off "commentaire"')
  end
  it '2030 Jan 10-2050 Jun 30 PH,Mo,We-Fr off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 10-2050 Jun 30 PH,Mo,We-Fr off "commentaire avec des espaces"'))).to eql('2030 Jan 10-2050 Jun 30 PH,Mo,We-Fr off "commentaire avec des espaces"')
  end
  it '2030 Jan 10-2050 Jun 30 PH,Mo,We-Fr 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 10-2050 Jun 30 PH,Mo,We-Fr 09:00-12:30,14:00-18:30'))).to eql('2030 Jan 10-2050 Jun 30 PH,Mo,We-Fr 09:00-12:30,14:00-18:30')
  end
  it '2030 Jan 10-2050 Jun 30 PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 10-2050 Jun 30 PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('2030 Jan 10-2050 Jun 30 PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it '2030 Jan 10-2050 Jun 30 PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 10-2050 Jun 30 PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('2030 Jan 10-2050 Jun 30 PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it '2030-2050 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030-2050 10:00-20:00'))).to eql('2030-2050 10:00-20:00')
  end
  it '2030-2050 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030-2050 10:00-20:00 "commentaire"'))).to eql('2030-2050 10:00-20:00 "commentaire"')
  end
  it '2030-2050 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030-2050 10:00-20:00 "commentaire avec des espaces"'))).to eql('2030-2050 10:00-20:00 "commentaire avec des espaces"')
  end
  it '2030-2050 off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030-2050 off'))).to eql('2030-2050 off')
  end
  it '2030-2050 off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030-2050 off "commentaire"'))).to eql('2030-2050 off "commentaire"')
  end
  it '2030-2050 off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030-2050 off "commentaire avec des espaces"'))).to eql('2030-2050 off "commentaire avec des espaces"')
  end
  it '2030-2050 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030-2050 09:00-12:30,14:00-18:30'))).to eql('2030-2050 09:00-12:30,14:00-18:30')
  end
  it '2030-2050 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030-2050 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('2030-2050 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it '2030-2050 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030-2050 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('2030-2050 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it '2030-2050 Mo 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030-2050 Mo 10:00-20:00'))).to eql('2030-2050 Mo 10:00-20:00')
  end
  it '2030-2050 Mo 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030-2050 Mo 10:00-20:00 "commentaire"'))).to eql('2030-2050 Mo 10:00-20:00 "commentaire"')
  end
  it '2030-2050 Mo 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030-2050 Mo 10:00-20:00 "commentaire avec des espaces"'))).to eql('2030-2050 Mo 10:00-20:00 "commentaire avec des espaces"')
  end
  it '2030-2050 Mo off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030-2050 Mo off'))).to eql('2030-2050 Mo off')
  end
  it '2030-2050 Mo off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030-2050 Mo off "commentaire"'))).to eql('2030-2050 Mo off "commentaire"')
  end
  it '2030-2050 Mo off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030-2050 Mo off "commentaire avec des espaces"'))).to eql('2030-2050 Mo off "commentaire avec des espaces"')
  end
  it '2030-2050 Mo 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030-2050 Mo 09:00-12:30,14:00-18:30'))).to eql('2030-2050 Mo 09:00-12:30,14:00-18:30')
  end
  it '2030-2050 Mo 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030-2050 Mo 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('2030-2050 Mo 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it '2030-2050 Mo 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030-2050 Mo 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('2030-2050 Mo 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it '2030-2050 Mo,We-Fr,Su 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030-2050 Mo,We-Fr,Su 10:00-20:00'))).to eql('2030-2050 Mo,We-Fr,Su 10:00-20:00')
  end
  it '2030-2050 Mo,We-Fr,Su 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030-2050 Mo,We-Fr,Su 10:00-20:00 "commentaire"'))).to eql('2030-2050 Mo,We-Fr,Su 10:00-20:00 "commentaire"')
  end
  it '2030-2050 Mo,We-Fr,Su 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030-2050 Mo,We-Fr,Su 10:00-20:00 "commentaire avec des espaces"'))).to eql('2030-2050 Mo,We-Fr,Su 10:00-20:00 "commentaire avec des espaces"')
  end
  it '2030-2050 Mo,We-Fr,Su off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030-2050 Mo,We-Fr,Su off'))).to eql('2030-2050 Mo,We-Fr,Su off')
  end
  it '2030-2050 Mo,We-Fr,Su off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030-2050 Mo,We-Fr,Su off "commentaire"'))).to eql('2030-2050 Mo,We-Fr,Su off "commentaire"')
  end
  it '2030-2050 Mo,We-Fr,Su off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030-2050 Mo,We-Fr,Su off "commentaire avec des espaces"'))).to eql('2030-2050 Mo,We-Fr,Su off "commentaire avec des espaces"')
  end
  it '2030-2050 Mo,We-Fr,Su 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030-2050 Mo,We-Fr,Su 09:00-12:30,14:00-18:30'))).to eql('2030-2050 Mo,We-Fr,Su 09:00-12:30,14:00-18:30')
  end
  it '2030-2050 Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030-2050 Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('2030-2050 Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it '2030-2050 Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030-2050 Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('2030-2050 Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it '2030-2050 Mo-We,Fr,Sa 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030-2050 Mo-We,Fr,Sa 10:00-20:00'))).to eql('2030-2050 Mo-We,Fr,Sa 10:00-20:00')
  end
  it '2030-2050 Mo-We,Fr,Sa 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030-2050 Mo-We,Fr,Sa 10:00-20:00 "commentaire"'))).to eql('2030-2050 Mo-We,Fr,Sa 10:00-20:00 "commentaire"')
  end
  it '2030-2050 Mo-We,Fr,Sa 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030-2050 Mo-We,Fr,Sa 10:00-20:00 "commentaire avec des espaces"'))).to eql('2030-2050 Mo-We,Fr,Sa 10:00-20:00 "commentaire avec des espaces"')
  end
  it '2030-2050 Mo-We,Fr,Sa off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030-2050 Mo-We,Fr,Sa off'))).to eql('2030-2050 Mo-We,Fr,Sa off')
  end
  it '2030-2050 Mo-We,Fr,Sa off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030-2050 Mo-We,Fr,Sa off "commentaire"'))).to eql('2030-2050 Mo-We,Fr,Sa off "commentaire"')
  end
  it '2030-2050 Mo-We,Fr,Sa off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030-2050 Mo-We,Fr,Sa off "commentaire avec des espaces"'))).to eql('2030-2050 Mo-We,Fr,Sa off "commentaire avec des espaces"')
  end
  it '2030-2050 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030-2050 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30'))).to eql('2030-2050 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30')
  end
  it '2030-2050 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030-2050 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('2030-2050 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it '2030-2050 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030-2050 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('2030-2050 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it '2030-2050 PH 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030-2050 PH 10:00-20:00'))).to eql('2030-2050 PH 10:00-20:00')
  end
  it '2030-2050 PH 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030-2050 PH 10:00-20:00 "commentaire"'))).to eql('2030-2050 PH 10:00-20:00 "commentaire"')
  end
  it '2030-2050 PH 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030-2050 PH 10:00-20:00 "commentaire avec des espaces"'))).to eql('2030-2050 PH 10:00-20:00 "commentaire avec des espaces"')
  end
  it '2030-2050 PH off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030-2050 PH off'))).to eql('2030-2050 PH off')
  end
  it '2030-2050 PH off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030-2050 PH off "commentaire"'))).to eql('2030-2050 PH off "commentaire"')
  end
  it '2030-2050 PH off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030-2050 PH off "commentaire avec des espaces"'))).to eql('2030-2050 PH off "commentaire avec des espaces"')
  end
  it '2030-2050 PH 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030-2050 PH 09:00-12:30,14:00-18:30'))).to eql('2030-2050 PH 09:00-12:30,14:00-18:30')
  end
  it '2030-2050 PH 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030-2050 PH 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('2030-2050 PH 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it '2030-2050 PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030-2050 PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('2030-2050 PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it '2030-2050 PH,Mo,We-Fr 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030-2050 PH,Mo,We-Fr 10:00-20:00'))).to eql('2030-2050 PH,Mo,We-Fr 10:00-20:00')
  end
  it '2030-2050 PH,Mo,We-Fr 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030-2050 PH,Mo,We-Fr 10:00-20:00 "commentaire"'))).to eql('2030-2050 PH,Mo,We-Fr 10:00-20:00 "commentaire"')
  end
  it '2030-2050 PH,Mo,We-Fr 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030-2050 PH,Mo,We-Fr 10:00-20:00 "commentaire avec des espaces"'))).to eql('2030-2050 PH,Mo,We-Fr 10:00-20:00 "commentaire avec des espaces"')
  end
  it '2030-2050 PH,Mo,We-Fr off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030-2050 PH,Mo,We-Fr off'))).to eql('2030-2050 PH,Mo,We-Fr off')
  end
  it '2030-2050 PH,Mo,We-Fr off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030-2050 PH,Mo,We-Fr off "commentaire"'))).to eql('2030-2050 PH,Mo,We-Fr off "commentaire"')
  end
  it '2030-2050 PH,Mo,We-Fr off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030-2050 PH,Mo,We-Fr off "commentaire avec des espaces"'))).to eql('2030-2050 PH,Mo,We-Fr off "commentaire avec des espaces"')
  end
  it '2030-2050 PH,Mo,We-Fr 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030-2050 PH,Mo,We-Fr 09:00-12:30,14:00-18:30'))).to eql('2030-2050 PH,Mo,We-Fr 09:00-12:30,14:00-18:30')
  end
  it '2030-2050 PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030-2050 PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('2030-2050 PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it '2030-2050 PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030-2050 PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('2030-2050 PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it 'Jan 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan 10:00-20:00'))).to eql('Jan 10:00-20:00')
  end
  it 'Jan 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan 10:00-20:00 "commentaire"'))).to eql('Jan 10:00-20:00 "commentaire"')
  end
  it 'Jan 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan 10:00-20:00 "commentaire avec des espaces"'))).to eql('Jan 10:00-20:00 "commentaire avec des espaces"')
  end
  it 'Jan off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan off'))).to eql('Jan off')
  end
  it 'Jan off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan off "commentaire"'))).to eql('Jan off "commentaire"')
  end
  it 'Jan off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan off "commentaire avec des espaces"'))).to eql('Jan off "commentaire avec des espaces"')
  end
  it 'Jan 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan 09:00-12:30,14:00-18:30'))).to eql('Jan 09:00-12:30,14:00-18:30')
  end
  it 'Jan 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('Jan 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it 'Jan 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('Jan 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it 'Jan Mo 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan Mo 10:00-20:00'))).to eql('Jan Mo 10:00-20:00')
  end
  it 'Jan Mo 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan Mo 10:00-20:00 "commentaire"'))).to eql('Jan Mo 10:00-20:00 "commentaire"')
  end
  it 'Jan Mo 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan Mo 10:00-20:00 "commentaire avec des espaces"'))).to eql('Jan Mo 10:00-20:00 "commentaire avec des espaces"')
  end
  it 'Jan Mo off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan Mo off'))).to eql('Jan Mo off')
  end
  it 'Jan Mo off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan Mo off "commentaire"'))).to eql('Jan Mo off "commentaire"')
  end
  it 'Jan Mo off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan Mo off "commentaire avec des espaces"'))).to eql('Jan Mo off "commentaire avec des espaces"')
  end
  it 'Jan Mo 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan Mo 09:00-12:30,14:00-18:30'))).to eql('Jan Mo 09:00-12:30,14:00-18:30')
  end
  it 'Jan Mo 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan Mo 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('Jan Mo 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it 'Jan Mo 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan Mo 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('Jan Mo 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it 'Jan Mo,We-Fr,Su 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan Mo,We-Fr,Su 10:00-20:00'))).to eql('Jan Mo,We-Fr,Su 10:00-20:00')
  end
  it 'Jan Mo,We-Fr,Su 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan Mo,We-Fr,Su 10:00-20:00 "commentaire"'))).to eql('Jan Mo,We-Fr,Su 10:00-20:00 "commentaire"')
  end
  it 'Jan Mo,We-Fr,Su 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan Mo,We-Fr,Su 10:00-20:00 "commentaire avec des espaces"'))).to eql('Jan Mo,We-Fr,Su 10:00-20:00 "commentaire avec des espaces"')
  end
  it 'Jan Mo,We-Fr,Su off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan Mo,We-Fr,Su off'))).to eql('Jan Mo,We-Fr,Su off')
  end
  it 'Jan Mo,We-Fr,Su off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan Mo,We-Fr,Su off "commentaire"'))).to eql('Jan Mo,We-Fr,Su off "commentaire"')
  end
  it 'Jan Mo,We-Fr,Su off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan Mo,We-Fr,Su off "commentaire avec des espaces"'))).to eql('Jan Mo,We-Fr,Su off "commentaire avec des espaces"')
  end
  it 'Jan Mo,We-Fr,Su 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan Mo,We-Fr,Su 09:00-12:30,14:00-18:30'))).to eql('Jan Mo,We-Fr,Su 09:00-12:30,14:00-18:30')
  end
  it 'Jan Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('Jan Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it 'Jan Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('Jan Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it 'Jan Mo-We,Fr,Sa 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan Mo-We,Fr,Sa 10:00-20:00'))).to eql('Jan Mo-We,Fr,Sa 10:00-20:00')
  end
  it 'Jan Mo-We,Fr,Sa 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan Mo-We,Fr,Sa 10:00-20:00 "commentaire"'))).to eql('Jan Mo-We,Fr,Sa 10:00-20:00 "commentaire"')
  end
  it 'Jan Mo-We,Fr,Sa 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan Mo-We,Fr,Sa 10:00-20:00 "commentaire avec des espaces"'))).to eql('Jan Mo-We,Fr,Sa 10:00-20:00 "commentaire avec des espaces"')
  end
  it 'Jan Mo-We,Fr,Sa off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan Mo-We,Fr,Sa off'))).to eql('Jan Mo-We,Fr,Sa off')
  end
  it 'Jan Mo-We,Fr,Sa off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan Mo-We,Fr,Sa off "commentaire"'))).to eql('Jan Mo-We,Fr,Sa off "commentaire"')
  end
  it 'Jan Mo-We,Fr,Sa off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan Mo-We,Fr,Sa off "commentaire avec des espaces"'))).to eql('Jan Mo-We,Fr,Sa off "commentaire avec des espaces"')
  end
  it 'Jan Mo-We,Fr,Sa 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan Mo-We,Fr,Sa 09:00-12:30,14:00-18:30'))).to eql('Jan Mo-We,Fr,Sa 09:00-12:30,14:00-18:30')
  end
  it 'Jan Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('Jan Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it 'Jan Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('Jan Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it 'Jan PH 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan PH 10:00-20:00'))).to eql('Jan PH 10:00-20:00')
  end
  it 'Jan PH 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan PH 10:00-20:00 "commentaire"'))).to eql('Jan PH 10:00-20:00 "commentaire"')
  end
  it 'Jan PH 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan PH 10:00-20:00 "commentaire avec des espaces"'))).to eql('Jan PH 10:00-20:00 "commentaire avec des espaces"')
  end
  it 'Jan PH off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan PH off'))).to eql('Jan PH off')
  end
  it 'Jan PH off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan PH off "commentaire"'))).to eql('Jan PH off "commentaire"')
  end
  it 'Jan PH off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan PH off "commentaire avec des espaces"'))).to eql('Jan PH off "commentaire avec des espaces"')
  end
  it 'Jan PH 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan PH 09:00-12:30,14:00-18:30'))).to eql('Jan PH 09:00-12:30,14:00-18:30')
  end
  it 'Jan PH 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan PH 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('Jan PH 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it 'Jan PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('Jan PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it 'Jan PH,Mo,We-Fr 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan PH,Mo,We-Fr 10:00-20:00'))).to eql('Jan PH,Mo,We-Fr 10:00-20:00')
  end
  it 'Jan PH,Mo,We-Fr 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan PH,Mo,We-Fr 10:00-20:00 "commentaire"'))).to eql('Jan PH,Mo,We-Fr 10:00-20:00 "commentaire"')
  end
  it 'Jan PH,Mo,We-Fr 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan PH,Mo,We-Fr 10:00-20:00 "commentaire avec des espaces"'))).to eql('Jan PH,Mo,We-Fr 10:00-20:00 "commentaire avec des espaces"')
  end
  it 'Jan PH,Mo,We-Fr off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan PH,Mo,We-Fr off'))).to eql('Jan PH,Mo,We-Fr off')
  end
  it 'Jan PH,Mo,We-Fr off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan PH,Mo,We-Fr off "commentaire"'))).to eql('Jan PH,Mo,We-Fr off "commentaire"')
  end
  it 'Jan PH,Mo,We-Fr off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan PH,Mo,We-Fr off "commentaire avec des espaces"'))).to eql('Jan PH,Mo,We-Fr off "commentaire avec des espaces"')
  end
  it 'Jan PH,Mo,We-Fr 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan PH,Mo,We-Fr 09:00-12:30,14:00-18:30'))).to eql('Jan PH,Mo,We-Fr 09:00-12:30,14:00-18:30')
  end
  it 'Jan PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('Jan PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it 'Jan PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('Jan PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it 'Jan-Jun 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan-Jun 10:00-20:00'))).to eql('Jan-Jun 10:00-20:00')
  end
  it 'Jan-Jun 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan-Jun 10:00-20:00 "commentaire"'))).to eql('Jan-Jun 10:00-20:00 "commentaire"')
  end
  it 'Jan-Jun 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan-Jun 10:00-20:00 "commentaire avec des espaces"'))).to eql('Jan-Jun 10:00-20:00 "commentaire avec des espaces"')
  end
  it 'Jan-Jun off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan-Jun off'))).to eql('Jan-Jun off')
  end
  it 'Jan-Jun off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan-Jun off "commentaire"'))).to eql('Jan-Jun off "commentaire"')
  end
  it 'Jan-Jun off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan-Jun off "commentaire avec des espaces"'))).to eql('Jan-Jun off "commentaire avec des espaces"')
  end
  it 'Jan-Jun 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan-Jun 09:00-12:30,14:00-18:30'))).to eql('Jan-Jun 09:00-12:30,14:00-18:30')
  end
  it 'Jan-Jun 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan-Jun 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('Jan-Jun 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it 'Jan-Jun 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan-Jun 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('Jan-Jun 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it 'Jan-Jun Mo 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan-Jun Mo 10:00-20:00'))).to eql('Jan-Jun Mo 10:00-20:00')
  end
  it 'Jan-Jun Mo 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan-Jun Mo 10:00-20:00 "commentaire"'))).to eql('Jan-Jun Mo 10:00-20:00 "commentaire"')
  end
  it 'Jan-Jun Mo 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan-Jun Mo 10:00-20:00 "commentaire avec des espaces"'))).to eql('Jan-Jun Mo 10:00-20:00 "commentaire avec des espaces"')
  end
  it 'Jan-Jun Mo off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan-Jun Mo off'))).to eql('Jan-Jun Mo off')
  end
  it 'Jan-Jun Mo off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan-Jun Mo off "commentaire"'))).to eql('Jan-Jun Mo off "commentaire"')
  end
  it 'Jan-Jun Mo off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan-Jun Mo off "commentaire avec des espaces"'))).to eql('Jan-Jun Mo off "commentaire avec des espaces"')
  end
  it 'Jan-Jun Mo 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan-Jun Mo 09:00-12:30,14:00-18:30'))).to eql('Jan-Jun Mo 09:00-12:30,14:00-18:30')
  end
  it 'Jan-Jun Mo 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan-Jun Mo 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('Jan-Jun Mo 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it 'Jan-Jun Mo 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan-Jun Mo 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('Jan-Jun Mo 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it 'Jan-Jun Mo,We-Fr,Su 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan-Jun Mo,We-Fr,Su 10:00-20:00'))).to eql('Jan-Jun Mo,We-Fr,Su 10:00-20:00')
  end
  it 'Jan-Jun Mo,We-Fr,Su 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan-Jun Mo,We-Fr,Su 10:00-20:00 "commentaire"'))).to eql('Jan-Jun Mo,We-Fr,Su 10:00-20:00 "commentaire"')
  end
  it 'Jan-Jun Mo,We-Fr,Su 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan-Jun Mo,We-Fr,Su 10:00-20:00 "commentaire avec des espaces"'))).to eql('Jan-Jun Mo,We-Fr,Su 10:00-20:00 "commentaire avec des espaces"')
  end
  it 'Jan-Jun Mo,We-Fr,Su off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan-Jun Mo,We-Fr,Su off'))).to eql('Jan-Jun Mo,We-Fr,Su off')
  end
  it 'Jan-Jun Mo,We-Fr,Su off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan-Jun Mo,We-Fr,Su off "commentaire"'))).to eql('Jan-Jun Mo,We-Fr,Su off "commentaire"')
  end
  it 'Jan-Jun Mo,We-Fr,Su off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan-Jun Mo,We-Fr,Su off "commentaire avec des espaces"'))).to eql('Jan-Jun Mo,We-Fr,Su off "commentaire avec des espaces"')
  end
  it 'Jan-Jun Mo,We-Fr,Su 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan-Jun Mo,We-Fr,Su 09:00-12:30,14:00-18:30'))).to eql('Jan-Jun Mo,We-Fr,Su 09:00-12:30,14:00-18:30')
  end
  it 'Jan-Jun Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan-Jun Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('Jan-Jun Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it 'Jan-Jun Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan-Jun Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('Jan-Jun Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it 'Jan-Jun Mo-We,Fr,Sa 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan-Jun Mo-We,Fr,Sa 10:00-20:00'))).to eql('Jan-Jun Mo-We,Fr,Sa 10:00-20:00')
  end
  it 'Jan-Jun Mo-We,Fr,Sa 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan-Jun Mo-We,Fr,Sa 10:00-20:00 "commentaire"'))).to eql('Jan-Jun Mo-We,Fr,Sa 10:00-20:00 "commentaire"')
  end
  it 'Jan-Jun Mo-We,Fr,Sa 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan-Jun Mo-We,Fr,Sa 10:00-20:00 "commentaire avec des espaces"'))).to eql('Jan-Jun Mo-We,Fr,Sa 10:00-20:00 "commentaire avec des espaces"')
  end
  it 'Jan-Jun Mo-We,Fr,Sa off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan-Jun Mo-We,Fr,Sa off'))).to eql('Jan-Jun Mo-We,Fr,Sa off')
  end
  it 'Jan-Jun Mo-We,Fr,Sa off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan-Jun Mo-We,Fr,Sa off "commentaire"'))).to eql('Jan-Jun Mo-We,Fr,Sa off "commentaire"')
  end
  it 'Jan-Jun Mo-We,Fr,Sa off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan-Jun Mo-We,Fr,Sa off "commentaire avec des espaces"'))).to eql('Jan-Jun Mo-We,Fr,Sa off "commentaire avec des espaces"')
  end
  it 'Jan-Jun Mo-We,Fr,Sa 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan-Jun Mo-We,Fr,Sa 09:00-12:30,14:00-18:30'))).to eql('Jan-Jun Mo-We,Fr,Sa 09:00-12:30,14:00-18:30')
  end
  it 'Jan-Jun Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan-Jun Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('Jan-Jun Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it 'Jan-Jun Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan-Jun Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('Jan-Jun Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it 'Jan-Jun PH 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan-Jun PH 10:00-20:00'))).to eql('Jan-Jun PH 10:00-20:00')
  end
  it 'Jan-Jun PH 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan-Jun PH 10:00-20:00 "commentaire"'))).to eql('Jan-Jun PH 10:00-20:00 "commentaire"')
  end
  it 'Jan-Jun PH 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan-Jun PH 10:00-20:00 "commentaire avec des espaces"'))).to eql('Jan-Jun PH 10:00-20:00 "commentaire avec des espaces"')
  end
  it 'Jan-Jun PH off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan-Jun PH off'))).to eql('Jan-Jun PH off')
  end
  it 'Jan-Jun PH off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan-Jun PH off "commentaire"'))).to eql('Jan-Jun PH off "commentaire"')
  end
  it 'Jan-Jun PH off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan-Jun PH off "commentaire avec des espaces"'))).to eql('Jan-Jun PH off "commentaire avec des espaces"')
  end
  it 'Jan-Jun PH 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan-Jun PH 09:00-12:30,14:00-18:30'))).to eql('Jan-Jun PH 09:00-12:30,14:00-18:30')
  end
  it 'Jan-Jun PH 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan-Jun PH 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('Jan-Jun PH 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it 'Jan-Jun PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan-Jun PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('Jan-Jun PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it 'Jan-Jun PH,Mo,We-Fr 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan-Jun PH,Mo,We-Fr 10:00-20:00'))).to eql('Jan-Jun PH,Mo,We-Fr 10:00-20:00')
  end
  it 'Jan-Jun PH,Mo,We-Fr 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan-Jun PH,Mo,We-Fr 10:00-20:00 "commentaire"'))).to eql('Jan-Jun PH,Mo,We-Fr 10:00-20:00 "commentaire"')
  end
  it 'Jan-Jun PH,Mo,We-Fr 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan-Jun PH,Mo,We-Fr 10:00-20:00 "commentaire avec des espaces"'))).to eql('Jan-Jun PH,Mo,We-Fr 10:00-20:00 "commentaire avec des espaces"')
  end
  it 'Jan-Jun PH,Mo,We-Fr off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan-Jun PH,Mo,We-Fr off'))).to eql('Jan-Jun PH,Mo,We-Fr off')
  end
  it 'Jan-Jun PH,Mo,We-Fr off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan-Jun PH,Mo,We-Fr off "commentaire"'))).to eql('Jan-Jun PH,Mo,We-Fr off "commentaire"')
  end
  it 'Jan-Jun PH,Mo,We-Fr off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan-Jun PH,Mo,We-Fr off "commentaire avec des espaces"'))).to eql('Jan-Jun PH,Mo,We-Fr off "commentaire avec des espaces"')
  end
  it 'Jan-Jun PH,Mo,We-Fr 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan-Jun PH,Mo,We-Fr 09:00-12:30,14:00-18:30'))).to eql('Jan-Jun PH,Mo,We-Fr 09:00-12:30,14:00-18:30')
  end
  it 'Jan-Jun PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan-Jun PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('Jan-Jun PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it 'Jan-Jun PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan-Jun PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('Jan-Jun PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it 'Jan 10-Jun 30 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan 10-Jun 30 10:00-20:00'))).to eql('Jan 10-Jun 30 10:00-20:00')
  end
  it 'Jan 10-Jun 30 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan 10-Jun 30 10:00-20:00 "commentaire"'))).to eql('Jan 10-Jun 30 10:00-20:00 "commentaire"')
  end
  it 'Jan 10-Jun 30 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan 10-Jun 30 10:00-20:00 "commentaire avec des espaces"'))).to eql('Jan 10-Jun 30 10:00-20:00 "commentaire avec des espaces"')
  end
  it 'Jan 10-Jun 30 off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan 10-Jun 30 off'))).to eql('Jan 10-Jun 30 off')
  end
  it 'Jan 10-Jun 30 off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan 10-Jun 30 off "commentaire"'))).to eql('Jan 10-Jun 30 off "commentaire"')
  end
  it 'Jan 10-Jun 30 off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan 10-Jun 30 off "commentaire avec des espaces"'))).to eql('Jan 10-Jun 30 off "commentaire avec des espaces"')
  end
  it 'Jan 10-Jun 30 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan 10-Jun 30 09:00-12:30,14:00-18:30'))).to eql('Jan 10-Jun 30 09:00-12:30,14:00-18:30')
  end
  it 'Jan 10-Jun 30 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan 10-Jun 30 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('Jan 10-Jun 30 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it 'Jan 10-Jun 30 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan 10-Jun 30 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('Jan 10-Jun 30 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it 'Jan 10-Jun 30 Mo 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan 10-Jun 30 Mo 10:00-20:00'))).to eql('Jan 10-Jun 30 Mo 10:00-20:00')
  end
  it 'Jan 10-Jun 30 Mo 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan 10-Jun 30 Mo 10:00-20:00 "commentaire"'))).to eql('Jan 10-Jun 30 Mo 10:00-20:00 "commentaire"')
  end
  it 'Jan 10-Jun 30 Mo 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan 10-Jun 30 Mo 10:00-20:00 "commentaire avec des espaces"'))).to eql('Jan 10-Jun 30 Mo 10:00-20:00 "commentaire avec des espaces"')
  end
  it 'Jan 10-Jun 30 Mo off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan 10-Jun 30 Mo off'))).to eql('Jan 10-Jun 30 Mo off')
  end
  it 'Jan 10-Jun 30 Mo off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan 10-Jun 30 Mo off "commentaire"'))).to eql('Jan 10-Jun 30 Mo off "commentaire"')
  end
  it 'Jan 10-Jun 30 Mo off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan 10-Jun 30 Mo off "commentaire avec des espaces"'))).to eql('Jan 10-Jun 30 Mo off "commentaire avec des espaces"')
  end
  it 'Jan 10-Jun 30 Mo 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan 10-Jun 30 Mo 09:00-12:30,14:00-18:30'))).to eql('Jan 10-Jun 30 Mo 09:00-12:30,14:00-18:30')
  end
  it 'Jan 10-Jun 30 Mo 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan 10-Jun 30 Mo 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('Jan 10-Jun 30 Mo 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it 'Jan 10-Jun 30 Mo 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan 10-Jun 30 Mo 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('Jan 10-Jun 30 Mo 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it 'Jan 10-Jun 30 Mo,We-Fr,Su 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan 10-Jun 30 Mo,We-Fr,Su 10:00-20:00'))).to eql('Jan 10-Jun 30 Mo,We-Fr,Su 10:00-20:00')
  end
  it 'Jan 10-Jun 30 Mo,We-Fr,Su 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan 10-Jun 30 Mo,We-Fr,Su 10:00-20:00 "commentaire"'))).to eql('Jan 10-Jun 30 Mo,We-Fr,Su 10:00-20:00 "commentaire"')
  end
  it 'Jan 10-Jun 30 Mo,We-Fr,Su 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan 10-Jun 30 Mo,We-Fr,Su 10:00-20:00 "commentaire avec des espaces"'))).to eql('Jan 10-Jun 30 Mo,We-Fr,Su 10:00-20:00 "commentaire avec des espaces"')
  end
  it 'Jan 10-Jun 30 Mo,We-Fr,Su off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan 10-Jun 30 Mo,We-Fr,Su off'))).to eql('Jan 10-Jun 30 Mo,We-Fr,Su off')
  end
  it 'Jan 10-Jun 30 Mo,We-Fr,Su off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan 10-Jun 30 Mo,We-Fr,Su off "commentaire"'))).to eql('Jan 10-Jun 30 Mo,We-Fr,Su off "commentaire"')
  end
  it 'Jan 10-Jun 30 Mo,We-Fr,Su off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan 10-Jun 30 Mo,We-Fr,Su off "commentaire avec des espaces"'))).to eql('Jan 10-Jun 30 Mo,We-Fr,Su off "commentaire avec des espaces"')
  end
  it 'Jan 10-Jun 30 Mo,We-Fr,Su 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan 10-Jun 30 Mo,We-Fr,Su 09:00-12:30,14:00-18:30'))).to eql('Jan 10-Jun 30 Mo,We-Fr,Su 09:00-12:30,14:00-18:30')
  end
  it 'Jan 10-Jun 30 Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan 10-Jun 30 Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('Jan 10-Jun 30 Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it 'Jan 10-Jun 30 Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan 10-Jun 30 Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('Jan 10-Jun 30 Mo,We-Fr,Su 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it 'Jan 10-Jun 30 Mo-We,Fr,Sa 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan 10-Jun 30 Mo-We,Fr,Sa 10:00-20:00'))).to eql('Jan 10-Jun 30 Mo-We,Fr,Sa 10:00-20:00')
  end
  it 'Jan 10-Jun 30 Mo-We,Fr,Sa 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan 10-Jun 30 Mo-We,Fr,Sa 10:00-20:00 "commentaire"'))).to eql('Jan 10-Jun 30 Mo-We,Fr,Sa 10:00-20:00 "commentaire"')
  end
  it 'Jan 10-Jun 30 Mo-We,Fr,Sa 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan 10-Jun 30 Mo-We,Fr,Sa 10:00-20:00 "commentaire avec des espaces"'))).to eql('Jan 10-Jun 30 Mo-We,Fr,Sa 10:00-20:00 "commentaire avec des espaces"')
  end
  it 'Jan 10-Jun 30 Mo-We,Fr,Sa off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan 10-Jun 30 Mo-We,Fr,Sa off'))).to eql('Jan 10-Jun 30 Mo-We,Fr,Sa off')
  end
  it 'Jan 10-Jun 30 Mo-We,Fr,Sa off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan 10-Jun 30 Mo-We,Fr,Sa off "commentaire"'))).to eql('Jan 10-Jun 30 Mo-We,Fr,Sa off "commentaire"')
  end
  it 'Jan 10-Jun 30 Mo-We,Fr,Sa off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan 10-Jun 30 Mo-We,Fr,Sa off "commentaire avec des espaces"'))).to eql('Jan 10-Jun 30 Mo-We,Fr,Sa off "commentaire avec des espaces"')
  end
  it 'Jan 10-Jun 30 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan 10-Jun 30 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30'))).to eql('Jan 10-Jun 30 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30')
  end
  it 'Jan 10-Jun 30 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan 10-Jun 30 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('Jan 10-Jun 30 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it 'Jan 10-Jun 30 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan 10-Jun 30 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('Jan 10-Jun 30 Mo-We,Fr,Sa 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it 'Jan 10-Jun 30 PH 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan 10-Jun 30 PH 10:00-20:00'))).to eql('Jan 10-Jun 30 PH 10:00-20:00')
  end
  it 'Jan 10-Jun 30 PH 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan 10-Jun 30 PH 10:00-20:00 "commentaire"'))).to eql('Jan 10-Jun 30 PH 10:00-20:00 "commentaire"')
  end
  it 'Jan 10-Jun 30 PH 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan 10-Jun 30 PH 10:00-20:00 "commentaire avec des espaces"'))).to eql('Jan 10-Jun 30 PH 10:00-20:00 "commentaire avec des espaces"')
  end
  it 'Jan 10-Jun 30 PH off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan 10-Jun 30 PH off'))).to eql('Jan 10-Jun 30 PH off')
  end
  it 'Jan 10-Jun 30 PH off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan 10-Jun 30 PH off "commentaire"'))).to eql('Jan 10-Jun 30 PH off "commentaire"')
  end
  it 'Jan 10-Jun 30 PH off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan 10-Jun 30 PH off "commentaire avec des espaces"'))).to eql('Jan 10-Jun 30 PH off "commentaire avec des espaces"')
  end
  it 'Jan 10-Jun 30 PH 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan 10-Jun 30 PH 09:00-12:30,14:00-18:30'))).to eql('Jan 10-Jun 30 PH 09:00-12:30,14:00-18:30')
  end
  it 'Jan 10-Jun 30 PH 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan 10-Jun 30 PH 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('Jan 10-Jun 30 PH 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it 'Jan 10-Jun 30 PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan 10-Jun 30 PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('Jan 10-Jun 30 PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it 'Jan 10-Jun 30 PH,Mo,We-Fr 10:00-20:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan 10-Jun 30 PH,Mo,We-Fr 10:00-20:00'))).to eql('Jan 10-Jun 30 PH,Mo,We-Fr 10:00-20:00')
  end
  it 'Jan 10-Jun 30 PH,Mo,We-Fr 10:00-20:00 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan 10-Jun 30 PH,Mo,We-Fr 10:00-20:00 "commentaire"'))).to eql('Jan 10-Jun 30 PH,Mo,We-Fr 10:00-20:00 "commentaire"')
  end
  it 'Jan 10-Jun 30 PH,Mo,We-Fr 10:00-20:00 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan 10-Jun 30 PH,Mo,We-Fr 10:00-20:00 "commentaire avec des espaces"'))).to eql('Jan 10-Jun 30 PH,Mo,We-Fr 10:00-20:00 "commentaire avec des espaces"')
  end
  it 'Jan 10-Jun 30 PH,Mo,We-Fr off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan 10-Jun 30 PH,Mo,We-Fr off'))).to eql('Jan 10-Jun 30 PH,Mo,We-Fr off')
  end
  it 'Jan 10-Jun 30 PH,Mo,We-Fr off "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan 10-Jun 30 PH,Mo,We-Fr off "commentaire"'))).to eql('Jan 10-Jun 30 PH,Mo,We-Fr off "commentaire"')
  end
  it 'Jan 10-Jun 30 PH,Mo,We-Fr off "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan 10-Jun 30 PH,Mo,We-Fr off "commentaire avec des espaces"'))).to eql('Jan 10-Jun 30 PH,Mo,We-Fr off "commentaire avec des espaces"')
  end
  it 'Jan 10-Jun 30 PH,Mo,We-Fr 09:00-12:30,14:00-18:30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan 10-Jun 30 PH,Mo,We-Fr 09:00-12:30,14:00-18:30'))).to eql('Jan 10-Jun 30 PH,Mo,We-Fr 09:00-12:30,14:00-18:30')
  end
  it 'Jan 10-Jun 30 PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan 10-Jun 30 PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('Jan 10-Jun 30 PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire"')
  end
  it 'Jan 10-Jun 30 PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan 10-Jun 30 PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('Jan 10-Jun 30 PH,Mo,We-Fr 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
  end
  it '2030 Jan 01 off; 2031 Jan 01 off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01 off; 2031 Jan 01 off'))).to eql('2030 Jan 01,2031 Jan 01 off')
  end
  it '2030 Jan 01,2031 Jan 01 off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 01,2031 Jan 01 off'))).to eql('2030 Jan 01,2031 Jan 01 off')
  end
  it 'Tu,We,Fr-Su 05:00-12:00; 2020 Jan 01,Apr 13,May 01,May 08,May 21,Jun 01,Jul 14,Aug 15,Nov 01,Nov 11,Dec 25,2021 Jan 01,Apr 05,May 01,May 08,May 13,May 24,Jul 14,Aug 15,Nov 01,Nov 11,Dec 25 off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Tu,We,Fr-Su 05:00-12:00; 2020 Jan 01,Apr 13,May 01,May 08,May 21,Jun 01,Jul 14,Aug 15,Nov 01,Nov 11,Dec 25,2021 Jan 01,Apr 05,May 01,May 08,May 13,May 24,Jul 14,Aug 15,Nov 01,Nov 11,Dec 25 off'))).to eql('Tu,We,Fr-Su 05:00-12:00; 2020 Jan 01,Apr 13,May 01,May 08,May 21,Jun 01,Jul 14,Aug 15,Nov 01,Nov 11,Dec 25,2021 Jan 01,Apr 05,May 01,May 08,May 13,May 24,Jul 14,Aug 15,Nov 01,Nov 11,Dec 25 off')
  end
  it 'Sep-Feb 08:00-10:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Dec-Feb 08:00-10:00'))).to eql('Jan-Feb,Dec 08:00-10:00')
  end
  it 'Mar-Aug 10:00-12:00; Sep-Feb 08:00-10:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Mar-Aug 10:00-12:00; Sep-Feb 08:00-10:00'))).to eql('Mar-Aug 10:00-12:00; Jan-Feb,Sep-Dec 08:00-10:00')
  end
  it 'Nov 01-Feb 02 7:30-18:00; Dec-Feb off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Nov 01-Feb 02 7:30-18:00; Dec-Feb off'))).to eql('Jan 01-Feb 02,Nov-Dec 07:30-18:00; Jan-Feb,Dec off')
  end
  it 'Jan 01-Feb 02,Nov-Dec 07:30-18:00; Jan-Feb,Dec off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan 01-Feb 02,Nov-Dec 07:30-18:00; Jan-Feb,Dec off'))).to eql('Jan 01-Feb 02,Nov-Dec 07:30-18:00; Jan-Feb off; Dec off')
  end
  it 'Jan 01-Feb 02,Oct,Dec 07:30-18:00; Jan-Feb,Dec off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan 01-Feb 02,Oct,Dec 07:30-18:00; Jan-Feb off'))).to eql('Jan 01-Feb 02,Oct,Dec 07:30-18:00; Jan-Feb off')
  end
  it 'Feb 04;Mar 18;Apr 29;Jun 10;Jul 22;Sep 02;Oct 14;Nov 25' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Feb 04;Mar 18;Apr 29;Jun 10;Jul 22;Sep 02;Oct 14;Nov 25'))).to eql('Feb 04,Mar 18,Apr 29,Jun 10,Jul 22,Sep 02,Oct 14,Nov 25 00:00-23:59')
  end
  it 'We' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('We'))).to eql('We 00:00-23:59')
  end
  it 'Mo-We' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Mo-We'))).to eql('Mo-We 00:00-23:59')
  end
  it 'Nov 30' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Nov 30'))).to eql('Nov 30 00:00-23:59')
  end
  it 'Nov 30 We' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Nov 30 We'))).to eql('Nov 30 00:00-23:59')
  end
  it 'WE OFF' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('WE OFF'))).to eql('We off')
  end
  it 'Ph off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Ph off'))).to eql('PH off')
  end
  it 'ph off' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('ph off'))).to eql('PH off')
  end
  it 'pH OFf' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('pH OFf'))).to eql('PH off')
  end
  it 'we 08:00-12:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('we 08:00-12:00'))).to eql('We 08:00-12:00')
  end
  it 'NOv-dEc wE 08:00-12:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('NOv-dEc wE 08:00-12:00'))).to eql('Nov-Dec We 08:00-12:00')
  end
  it 'NOv-dEc wE-Fr 08:00-12:00' do
    expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('NOv-dEc wE-Fr 08:00-12:00'))).to eql('Nov-Dec We-Fr 08:00-12:00')
  end
end