# require 'opening_hours_converter'

# RSpec.describe OpeningHoursConverter::OpeningHoursParser, '#parse' do
#   it 'PH 09:00-12:30,14:00-18:30' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('PH 09:00-12:30,14:00-18:30'))).to eql('PH 09:00-12:30,14:00-18:30')
#     # PH,Mo-Su off
#   end
#   it 'PH 09:00-12:30,14:00-18:30 "commentaire"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('PH 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('PH 09:00-12:30,14:00-18:30 "commentaire"')
#     # PH,Mo-Su off "commentaire"
#   end
#   it 'PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
#     # PH,Mo-Su off "commentaire avec des espaces"
#   end
#   it 'PH,Mo,We-Fr off' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('PH,Mo,We-Fr off'))).to eql('PH,Mo,We-Fr off')
#     # Mo,We-Fr off; PH off
#   end
#   it 'PH,Mo,We-Fr off "commentaire"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('PH,Mo,We-Fr off "commentaire"'))).to eql('PH,Mo,We-Fr off "commentaire"')
#     # Mo,We-Fr off "commentaire"; PH off
#   end
#   it 'PH,Mo,We-Fr off "commentaire avec des espaces"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('PH,Mo,We-Fr off "commentaire avec des espaces"'))).to eql('PH,Mo,We-Fr off "commentaire avec des espaces"')
#     # Mo,We-Fr off "commentaire avec des espaces"; PH off
#   end
#   it '2030 PH 09:00-12:30,14:00-18:30' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 PH 09:00-12:30,14:00-18:30'))).to eql('2030 PH 09:00-12:30,14:00-18:30')
#     # 2030 PH,Mo-Su off
#   end
#   it '2030 PH 09:00-12:30,14:00-18:30 "commentaire"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 PH 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('2030 PH 09:00-12:30,14:00-18:30 "commentaire"')
#     # 2030 PH,Mo-Su off "commentaire"
#   end
#   it '2030 PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('2030 PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
#     # 2030 PH,Mo-Su off "commentaire avec des espaces"
#   end
#   it '2030 PH,Mo,We-Fr off' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 PH,Mo,We-Fr off'))).to eql('2030 PH,Mo,We-Fr off')
#     # 2030 Mo,We-Fr off; 2030 PH off
#   end
#   it '2030 PH,Mo,We-Fr off "commentaire"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 PH,Mo,We-Fr off "commentaire"'))).to eql('2030 PH,Mo,We-Fr off "commentaire"')
#     # 2030 Mo,We-Fr off "commentaire"; 2030 PH off
#   end
#   it '2030 PH,Mo,We-Fr off "commentaire avec des espaces"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 PH,Mo,We-Fr off "commentaire avec des espaces"'))).to eql('2030 PH,Mo,We-Fr off "commentaire avec des espaces"')
#     # 2030 Mo,We-Fr off "commentaire avec des espaces"; 2030 PH off
#   end
#   it '2030 week 1 PH 10:00-20:00' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1 PH 10:00-20:00'))).to eql('2030 week 1 PH 10:00-20:00')
#     # 2030 week 1 PH,Mo-Su off
#   end
#   it '2030 week 1 PH 10:00-20:00 "commentaire"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1 PH 10:00-20:00 "commentaire"'))).to eql('2030 week 1 PH 10:00-20:00 "commentaire"')
#     # 2030 week 1 PH,Mo-Su off "commentaire"
#   end
#   it '2030 week 1 PH 10:00-20:00 "commentaire avec des espaces"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1 PH 10:00-20:00 "commentaire avec des espaces"'))).to eql('2030 week 1 PH 10:00-20:00 "commentaire avec des espaces"')
#     # 2030 week 1 PH,Mo-Su off "commentaire avec des espaces"
#   end
#   it '2030 week 1 PH off' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1 PH off'))).to eql('2030 week 1 PH off')
#     # 2030 week 1 PH,Mo-Su off
#   end
#   it '2030 week 1 PH off "commentaire"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1 PH off "commentaire"'))).to eql('2030 week 1 PH off "commentaire"')
#     # 2030 week 1 PH,Mo-Su off "commentaire"
#   end
#   it '2030 week 1 PH off "commentaire avec des espaces"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1 PH off "commentaire avec des espaces"'))).to eql('2030 week 1 PH off "commentaire avec des espaces"')
#     # 2030 week 1 PH,Mo-Su off "commentaire avec des espaces"
#   end
#   it '2030 week 1 PH 09:00-12:30,14:00-18:30' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1 PH 09:00-12:30,14:00-18:30'))).to eql('2030 week 1 PH 09:00-12:30,14:00-18:30')
#     # 2030 week 1 PH,Mo-Su off
#   end
#   it '2030 week 1 PH 09:00-12:30,14:00-18:30 "commentaire"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1 PH 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('2030 week 1 PH 09:00-12:30,14:00-18:30 "commentaire"')
#     # 2030 week 1 PH,Mo-Su off "commentaire"
#   end
#   it '2030 week 1 PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1 PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('2030 week 1 PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
#     # 2030 week 1 PH,Mo-Su off "commentaire avec des espaces"
#   end
#   it '2030 week 1,3 PH 10:00-20:00' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3 PH 10:00-20:00'))).to eql('2030 week 1,3 PH 10:00-20:00')
#     # 2030 week 1,3 PH,Mo-Su off
#   end
#   it '2030 week 1,3 PH 10:00-20:00 "commentaire"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3 PH 10:00-20:00 "commentaire"'))).to eql('2030 week 1,3 PH 10:00-20:00 "commentaire"')
#     # 2030 week 1,3 PH,Mo-Su off "commentaire"
#   end
#   it '2030 week 1,3 PH 10:00-20:00 "commentaire avec des espaces"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3 PH 10:00-20:00 "commentaire avec des espaces"'))).to eql('2030 week 1,3 PH 10:00-20:00 "commentaire avec des espaces"')
#     # 2030 week 1,3 PH,Mo-Su off "commentaire avec des espaces"
#   end
#   it '2030 week 1,3 PH off' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3 PH off'))).to eql('2030 week 1,3 PH off')
#     # 2030 week 1,3 PH,Mo-Su off
#   end
#   it '2030 week 1,3 PH off "commentaire"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3 PH off "commentaire"'))).to eql('2030 week 1,3 PH off "commentaire"')
#     # 2030 week 1,3 PH,Mo-Su off "commentaire"
#   end
#   it '2030 week 1,3 PH off "commentaire avec des espaces"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3 PH off "commentaire avec des espaces"'))).to eql('2030 week 1,3 PH off "commentaire avec des espaces"')
#     # 2030 week 1,3 PH,Mo-Su off "commentaire avec des espaces"
#   end
#   it '2030 week 1,3 PH 09:00-12:30,14:00-18:30' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3 PH 09:00-12:30,14:00-18:30'))).to eql('2030 week 1,3 PH 09:00-12:30,14:00-18:30')
#     # 2030 week 1,3 PH,Mo-Su off
#   end
#   it '2030 week 1,3 PH 09:00-12:30,14:00-18:30 "commentaire"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3 PH 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('2030 week 1,3 PH 09:00-12:30,14:00-18:30 "commentaire"')
#     # 2030 week 1,3 PH,Mo-Su off "commentaire"
#   end
#   it '2030 week 1,3 PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3 PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('2030 week 1,3 PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
#     # 2030 week 1,3 PH,Mo-Su off "commentaire avec des espaces"
#   end
#   it '2030 week 1,3,10-30 PH 10:00-20:00' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30 PH 10:00-20:00'))).to eql('2030 week 1,3,10-30 PH 10:00-20:00')
#     # 2030 week 1,3,10-30 PH,Mo-Su off
#   end
#   it '2030 week 1,3,10-30 PH 10:00-20:00 "commentaire"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30 PH 10:00-20:00 "commentaire"'))).to eql('2030 week 1,3,10-30 PH 10:00-20:00 "commentaire"')
#     # 2030 week 1,3,10-30 PH,Mo-Su off "commentaire"
#   end
#   it '2030 week 1,3,10-30 PH 10:00-20:00 "commentaire avec des espaces"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30 PH 10:00-20:00 "commentaire avec des espaces"'))).to eql('2030 week 1,3,10-30 PH 10:00-20:00 "commentaire avec des espaces"')
#     # 2030 week 1,3,10-30 PH,Mo-Su off "commentaire avec des espaces"
#   end
#   it '2030 week 1,3,10-30 PH off' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30 PH off'))).to eql('2030 week 1,3,10-30 PH off')
#     # 2030 week 1,3,10-30 PH,Mo-Su off
#   end
#   it '2030 week 1,3,10-30 PH off "commentaire"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30 PH off "commentaire"'))).to eql('2030 week 1,3,10-30 PH off "commentaire"')
#     # 2030 week 1,3,10-30 PH,Mo-Su off "commentaire"
#   end
#   it '2030 week 1,3,10-30 PH off "commentaire avec des espaces"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30 PH off "commentaire avec des espaces"'))).to eql('2030 week 1,3,10-30 PH off "commentaire avec des espaces"')
#     # 2030 week 1,3,10-30 PH,Mo-Su off "commentaire avec des espaces"
#   end
#   it '2030 week 1,3,10-30 PH 09:00-12:30,14:00-18:30' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30 PH 09:00-12:30,14:00-18:30'))).to eql('2030 week 1,3,10-30 PH 09:00-12:30,14:00-18:30')
#     # 2030 week 1,3,10-30 PH,Mo-Su off
#   end
#   it '2030 week 1,3,10-30 PH 09:00-12:30,14:00-18:30 "commentaire"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30 PH 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('2030 week 1,3,10-30 PH 09:00-12:30,14:00-18:30 "commentaire"')
#     # 2030 week 1,3,10-30 PH,Mo-Su off "commentaire"
#   end
#   it '2030 week 1,3,10-30 PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30 PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('2030 week 1,3,10-30 PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
#     # 2030 week 1,3,10-30 PH,Mo-Su off "commentaire avec des espaces"
#   end
#   it '2030 week 1,3,10-30/2 PH 10:00-20:00' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2 PH 10:00-20:00'))).to eql('2030 week 1,3,10-30/2 PH 10:00-20:00')
#     # 2030 week 1,3,10-30/2 PH,Mo-Su off
#   end
#   it '2030 week 1,3,10-30/2 PH 10:00-20:00 "commentaire"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2 PH 10:00-20:00 "commentaire"'))).to eql('2030 week 1,3,10-30/2 PH 10:00-20:00 "commentaire"')
#     # 2030 week 1,3,10-30/2 PH,Mo-Su off "commentaire"
#   end
#   it '2030 week 1,3,10-30/2 PH 10:00-20:00 "commentaire avec des espaces"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2 PH 10:00-20:00 "commentaire avec des espaces"'))).to eql('2030 week 1,3,10-30/2 PH 10:00-20:00 "commentaire avec des espaces"')
#     # 2030 week 1,3,10-30/2 PH,Mo-Su off "commentaire avec des espaces"
#   end
#   it '2030 week 1,3,10-30/2 PH off' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2 PH off'))).to eql('2030 week 1,3,10-30/2 PH off')
#     # 2030 week 1,3,10-30/2 PH,Mo-Su off
#   end
#   it '2030 week 1,3,10-30/2 PH off "commentaire"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2 PH off "commentaire"'))).to eql('2030 week 1,3,10-30/2 PH off "commentaire"')
#     # 2030 week 1,3,10-30/2 PH,Mo-Su off "commentaire"
#   end
#   it '2030 week 1,3,10-30/2 PH off "commentaire avec des espaces"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2 PH off "commentaire avec des espaces"'))).to eql('2030 week 1,3,10-30/2 PH off "commentaire avec des espaces"')
#     # 2030 week 1,3,10-30/2 PH,Mo-Su off "commentaire avec des espaces"
#   end
#   it '2030 week 1,3,10-30/2 PH 09:00-12:30,14:00-18:30' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2 PH 09:00-12:30,14:00-18:30'))).to eql('2030 week 1,3,10-30/2 PH 09:00-12:30,14:00-18:30')
#     # 2030 week 1,3,10-30/2 PH,Mo-Su off
#   end
#   it '2030 week 1,3,10-30/2 PH 09:00-12:30,14:00-18:30 "commentaire"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2 PH 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('2030 week 1,3,10-30/2 PH 09:00-12:30,14:00-18:30 "commentaire"')
#     # 2030 week 1,3,10-30/2 PH,Mo-Su off "commentaire"
#   end
#   it '2030 week 1,3,10-30/2 PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2 PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('2030 week 1,3,10-30/2 PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
#     # 2030 week 1,3,10-30/2 PH,Mo-Su off "commentaire avec des espaces"
#   end
#   it '2030 week 1,3,10-30/2,50 PH 10:00-20:00' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2,50 PH 10:00-20:00'))).to eql('2030 week 1,3,10-30/2,50 PH 10:00-20:00')
#     # 2030 week 1,3,10-30/2,50 PH,Mo-Su off
#   end
#   it '2030 week 1,3,10-30/2,50 PH 10:00-20:00 "commentaire"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2,50 PH 10:00-20:00 "commentaire"'))).to eql('2030 week 1,3,10-30/2,50 PH 10:00-20:00 "commentaire"')
#     # 2030 week 1,3,10-30/2,50 PH,Mo-Su off "commentaire"
#   end
#   it '2030 week 1,3,10-30/2,50 PH 10:00-20:00 "commentaire avec des espaces"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2,50 PH 10:00-20:00 "commentaire avec des espaces"'))).to eql('2030 week 1,3,10-30/2,50 PH 10:00-20:00 "commentaire avec des espaces"')
#     # 2030 week 1,3,10-30/2,50 PH,Mo-Su off "commentaire avec des espaces"
#   end
#   it '2030 week 1,3,10-30/2,50 PH off' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2,50 PH off'))).to eql('2030 week 1,3,10-30/2,50 PH off')
#     # 2030 week 1,3,10-30/2,50 PH,Mo-Su off
#   end
#   it '2030 week 1,3,10-30/2,50 PH off "commentaire"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2,50 PH off "commentaire"'))).to eql('2030 week 1,3,10-30/2,50 PH off "commentaire"')
#     # 2030 week 1,3,10-30/2,50 PH,Mo-Su off "commentaire"
#   end
#   it '2030 week 1,3,10-30/2,50 PH off "commentaire avec des espaces"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2,50 PH off "commentaire avec des espaces"'))).to eql('2030 week 1,3,10-30/2,50 PH off "commentaire avec des espaces"')
#     # 2030 week 1,3,10-30/2,50 PH,Mo-Su off "commentaire avec des espaces"
#   end
#   it '2030 week 1,3,10-30/2,50 PH 09:00-12:30,14:00-18:30' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2,50 PH 09:00-12:30,14:00-18:30'))).to eql('2030 week 1,3,10-30/2,50 PH 09:00-12:30,14:00-18:30')
#     # 2030 week 1,3,10-30/2,50 PH,Mo-Su off
#   end
#   it '2030 week 1,3,10-30/2,50 PH 09:00-12:30,14:00-18:30 "commentaire"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2,50 PH 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('2030 week 1,3,10-30/2,50 PH 09:00-12:30,14:00-18:30 "commentaire"')
#     # 2030 week 1,3,10-30/2,50 PH,Mo-Su off "commentaire"
#   end
#   it '2030 week 1,3,10-30/2,50 PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 week 1,3,10-30/2,50 PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('2030 week 1,3,10-30/2,50 PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
#     # 2030 week 1,3,10-30/2,50 PH,Mo-Su off "commentaire avec des espaces"
#   end
#   it 'week 1 PH 10:00-20:00' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1 PH 10:00-20:00'))).to eql('week 1 PH 10:00-20:00')
#     # week 1 PH,Mo-Su off
#   end
#   it 'week 1 PH 10:00-20:00 "commentaire"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1 PH 10:00-20:00 "commentaire"'))).to eql('week 1 PH 10:00-20:00 "commentaire"')
#     # week 1 PH,Mo-Su off "commentaire"
#   end
#   it 'week 1 PH 10:00-20:00 "commentaire avec des espaces"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1 PH 10:00-20:00 "commentaire avec des espaces"'))).to eql('week 1 PH 10:00-20:00 "commentaire avec des espaces"')
#     # week 1 PH,Mo-Su off "commentaire avec des espaces"
#   end
#   it 'week 1 PH off' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1 PH off'))).to eql('week 1 PH off')
#     # week 1 PH,Mo-Su off
#   end
#   it 'week 1 PH off "commentaire"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1 PH off "commentaire"'))).to eql('week 1 PH off "commentaire"')
#     # week 1 PH,Mo-Su off "commentaire"
#   end
#   it 'week 1 PH off "commentaire avec des espaces"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1 PH off "commentaire avec des espaces"'))).to eql('week 1 PH off "commentaire avec des espaces"')
#     # week 1 PH,Mo-Su off "commentaire avec des espaces"
#   end
#   it 'week 1 PH 09:00-12:30,14:00-18:30' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1 PH 09:00-12:30,14:00-18:30'))).to eql('week 1 PH 09:00-12:30,14:00-18:30')
#     # week 1 PH,Mo-Su off
#   end
#   it 'week 1 PH 09:00-12:30,14:00-18:30 "commentaire"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1 PH 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('week 1 PH 09:00-12:30,14:00-18:30 "commentaire"')
#     # week 1 PH,Mo-Su off "commentaire"
#   end
#   it 'week 1 PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1 PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('week 1 PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
#     # week 1 PH,Mo-Su off "commentaire avec des espaces"
#   end
#   it 'week 1,3 PH 10:00-20:00' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3 PH 10:00-20:00'))).to eql('week 1,3 PH 10:00-20:00')
#     # week 1,3 PH,Mo-Su off
#   end
#   it 'week 1,3 PH 10:00-20:00 "commentaire"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3 PH 10:00-20:00 "commentaire"'))).to eql('week 1,3 PH 10:00-20:00 "commentaire"')
#     # week 1,3 PH,Mo-Su off "commentaire"
#   end
#   it 'week 1,3 PH 10:00-20:00 "commentaire avec des espaces"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3 PH 10:00-20:00 "commentaire avec des espaces"'))).to eql('week 1,3 PH 10:00-20:00 "commentaire avec des espaces"')
#     # week 1,3 PH,Mo-Su off "commentaire avec des espaces"
#   end
#   it 'week 1,3 PH off' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3 PH off'))).to eql('week 1,3 PH off')
#     # week 1,3 PH,Mo-Su off
#   end
#   it 'week 1,3 PH off "commentaire"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3 PH off "commentaire"'))).to eql('week 1,3 PH off "commentaire"')
#     # week 1,3 PH,Mo-Su off "commentaire"
#   end
#   it 'week 1,3 PH off "commentaire avec des espaces"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3 PH off "commentaire avec des espaces"'))).to eql('week 1,3 PH off "commentaire avec des espaces"')
#     # week 1,3 PH,Mo-Su off "commentaire avec des espaces"
#   end
#   it 'week 1,3 PH 09:00-12:30,14:00-18:30' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3 PH 09:00-12:30,14:00-18:30'))).to eql('week 1,3 PH 09:00-12:30,14:00-18:30')
#     # week 1,3 PH,Mo-Su off
#   end
#   it 'week 1,3 PH 09:00-12:30,14:00-18:30 "commentaire"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3 PH 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('week 1,3 PH 09:00-12:30,14:00-18:30 "commentaire"')
#     # week 1,3 PH,Mo-Su off "commentaire"
#   end
#   it 'week 1,3 PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3 PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('week 1,3 PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
#     # week 1,3 PH,Mo-Su off "commentaire avec des espaces"
#   end
#   it 'week 1,3,10-30 PH 10:00-20:00' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30 PH 10:00-20:00'))).to eql('week 1,3,10-30 PH 10:00-20:00')
#     # week 1,3,10-30 PH,Mo-Su off
#   end
#   it 'week 1,3,10-30 PH 10:00-20:00 "commentaire"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30 PH 10:00-20:00 "commentaire"'))).to eql('week 1,3,10-30 PH 10:00-20:00 "commentaire"')
#     # week 1,3,10-30 PH,Mo-Su off "commentaire"
#   end
#   it 'week 1,3,10-30 PH 10:00-20:00 "commentaire avec des espaces"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30 PH 10:00-20:00 "commentaire avec des espaces"'))).to eql('week 1,3,10-30 PH 10:00-20:00 "commentaire avec des espaces"')
#     # week 1,3,10-30 PH,Mo-Su off "commentaire avec des espaces"
#   end
#   it 'week 1,3,10-30 PH off' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30 PH off'))).to eql('week 1,3,10-30 PH off')
#     # week 1,3,10-30 PH,Mo-Su off
#   end
#   it 'week 1,3,10-30 PH off "commentaire"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30 PH off "commentaire"'))).to eql('week 1,3,10-30 PH off "commentaire"')
#     # week 1,3,10-30 PH,Mo-Su off "commentaire"
#   end
#   it 'week 1,3,10-30 PH off "commentaire avec des espaces"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30 PH off "commentaire avec des espaces"'))).to eql('week 1,3,10-30 PH off "commentaire avec des espaces"')
#     # week 1,3,10-30 PH,Mo-Su off "commentaire avec des espaces"
#   end
#   it 'week 1,3,10-30 PH 09:00-12:30,14:00-18:30' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30 PH 09:00-12:30,14:00-18:30'))).to eql('week 1,3,10-30 PH 09:00-12:30,14:00-18:30')
#     # week 1,3,10-30 PH,Mo-Su off
#   end
#   it 'week 1,3,10-30 PH 09:00-12:30,14:00-18:30 "commentaire"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30 PH 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('week 1,3,10-30 PH 09:00-12:30,14:00-18:30 "commentaire"')
#     # week 1,3,10-30 PH,Mo-Su off "commentaire"
#   end
#   it 'week 1,3,10-30 PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30 PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('week 1,3,10-30 PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
#     # week 1,3,10-30 PH,Mo-Su off "commentaire avec des espaces"
#   end
#   it 'week 1,3,10-30/2 PH 10:00-20:00' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2 PH 10:00-20:00'))).to eql('week 1,3,10-30/2 PH 10:00-20:00')
#     # week 1,3,10-30/2 PH,Mo-Su off
#   end
#   it 'week 1,3,10-30/2 PH 10:00-20:00 "commentaire"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2 PH 10:00-20:00 "commentaire"'))).to eql('week 1,3,10-30/2 PH 10:00-20:00 "commentaire"')
#     # week 1,3,10-30/2 PH,Mo-Su off "commentaire"
#   end
#   it 'week 1,3,10-30/2 PH 10:00-20:00 "commentaire avec des espaces"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2 PH 10:00-20:00 "commentaire avec des espaces"'))).to eql('week 1,3,10-30/2 PH 10:00-20:00 "commentaire avec des espaces"')
#     # week 1,3,10-30/2 PH,Mo-Su off "commentaire avec des espaces"
#   end
#   it 'week 1,3,10-30/2 PH off' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2 PH off'))).to eql('week 1,3,10-30/2 PH off')
#     # week 1,3,10-30/2 PH,Mo-Su off
#   end
#   it 'week 1,3,10-30/2 PH off "commentaire"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2 PH off "commentaire"'))).to eql('week 1,3,10-30/2 PH off "commentaire"')
#     # week 1,3,10-30/2 PH,Mo-Su off "commentaire"
#   end
#   it 'week 1,3,10-30/2 PH off "commentaire avec des espaces"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2 PH off "commentaire avec des espaces"'))).to eql('week 1,3,10-30/2 PH off "commentaire avec des espaces"')
#     # week 1,3,10-30/2 PH,Mo-Su off "commentaire avec des espaces"
#   end
#   it 'week 1,3,10-30/2 PH 09:00-12:30,14:00-18:30' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2 PH 09:00-12:30,14:00-18:30'))).to eql('week 1,3,10-30/2 PH 09:00-12:30,14:00-18:30')
#     # week 1,3,10-30/2 PH,Mo-Su off
#   end
#   it 'week 1,3,10-30/2 PH 09:00-12:30,14:00-18:30 "commentaire"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2 PH 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('week 1,3,10-30/2 PH 09:00-12:30,14:00-18:30 "commentaire"')
#     # week 1,3,10-30/2 PH,Mo-Su off "commentaire"
#   end
#   it 'week 1,3,10-30/2 PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2 PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('week 1,3,10-30/2 PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
#     # week 1,3,10-30/2 PH,Mo-Su off "commentaire avec des espaces"
#   end
#   it 'week 1,3,10-30/2,50 PH 10:00-20:00' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2,50 PH 10:00-20:00'))).to eql('week 1,3,10-30/2,50 PH 10:00-20:00')
#     # week 1,3,10-30/2,50 PH,Mo-Su off
#   end
#   it 'week 1,3,10-30/2,50 PH 10:00-20:00 "commentaire"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2,50 PH 10:00-20:00 "commentaire"'))).to eql('week 1,3,10-30/2,50 PH 10:00-20:00 "commentaire"')
#     # week 1,3,10-30/2,50 PH,Mo-Su off "commentaire"
#   end
#   it 'week 1,3,10-30/2,50 PH 10:00-20:00 "commentaire avec des espaces"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2,50 PH 10:00-20:00 "commentaire avec des espaces"'))).to eql('week 1,3,10-30/2,50 PH 10:00-20:00 "commentaire avec des espaces"')
#     # week 1,3,10-30/2,50 PH,Mo-Su off "commentaire avec des espaces"
#   end
#   it 'week 1,3,10-30/2,50 PH off' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2,50 PH off'))).to eql('week 1,3,10-30/2,50 PH off')
#     # week 1,3,10-30/2,50 PH,Mo-Su off
#   end
#   it 'week 1,3,10-30/2,50 PH off "commentaire"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2,50 PH off "commentaire"'))).to eql('week 1,3,10-30/2,50 PH off "commentaire"')
#     # week 1,3,10-30/2,50 PH,Mo-Su off "commentaire"
#   end
#   it 'week 1,3,10-30/2,50 PH off "commentaire avec des espaces"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2,50 PH off "commentaire avec des espaces"'))).to eql('week 1,3,10-30/2,50 PH off "commentaire avec des espaces"')
#     # week 1,3,10-30/2,50 PH,Mo-Su off "commentaire avec des espaces"
#   end
#   it 'week 1,3,10-30/2,50 PH 09:00-12:30,14:00-18:30' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2,50 PH 09:00-12:30,14:00-18:30'))).to eql('week 1,3,10-30/2,50 PH 09:00-12:30,14:00-18:30')
#     # week 1,3,10-30/2,50 PH,Mo-Su off
#   end
#   it 'week 1,3,10-30/2,50 PH 09:00-12:30,14:00-18:30 "commentaire"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2,50 PH 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('week 1,3,10-30/2,50 PH 09:00-12:30,14:00-18:30 "commentaire"')
#     # week 1,3,10-30/2,50 PH,Mo-Su off "commentaire"
#   end
#   it 'week 1,3,10-30/2,50 PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('week 1,3,10-30/2,50 PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('week 1,3,10-30/2,50 PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
#     # week 1,3,10-30/2,50 PH,Mo-Su off "commentaire avec des espaces"
#   end
#   it '2030 Jan PH 10:00-20:00' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan PH 10:00-20:00'))).to eql('2030 Jan PH 10:00-20:00')
#     # 2030 PH 10:00-20:00
#   end
#   it '2030 Jan PH 10:00-20:00 "commentaire"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan PH 10:00-20:00 "commentaire"'))).to eql('2030 Jan PH 10:00-20:00 "commentaire"')
#     # 2030 PH 10:00-20:00 "commentaire"
#   end
#   it '2030 Jan PH 10:00-20:00 "commentaire avec des espaces"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan PH 10:00-20:00 "commentaire avec des espaces"'))).to eql('2030 Jan PH 10:00-20:00 "commentaire avec des espaces"')
#     # 2030 PH 10:00-20:00 "commentaire avec des espaces"
#   end
#   it '2030 Jan PH off' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan PH off'))).to eql('2030 Jan PH off')
#     # 2030 PH off
#   end
#   it '2030 Jan PH off "commentaire"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan PH off "commentaire"'))).to eql('2030 Jan PH off "commentaire"')
#     # 2030 PH off "commentaire"
#   end
#   it '2030 Jan PH off "commentaire avec des espaces"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan PH off "commentaire avec des espaces"'))).to eql('2030 Jan PH off "commentaire avec des espaces"')
#     # 2030 PH off "commentaire avec des espaces"
#   end
#   it '2030 Jan PH 09:00-12:30,14:00-18:30' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan PH 09:00-12:30,14:00-18:30'))).to eql('2030 Jan PH 09:00-12:30,14:00-18:30')
#     # 2030 Jan PH,Mo-Su off
#   end
#   it '2030 Jan PH 09:00-12:30,14:00-18:30 "commentaire"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan PH 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('2030 Jan PH 09:00-12:30,14:00-18:30 "commentaire"')
#     # 2030 Jan PH,Mo-Su off "commentaire"
#   end
#   it '2030 Jan PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('2030 Jan PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
#     # 2030 Jan PH,Mo-Su off "commentaire avec des espaces"
#   end
#   it '2030 Jan PH,Mo,We-Fr off' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan PH,Mo,We-Fr off'))).to eql('2030 Jan PH,Mo,We-Fr off')
#     # 2030 Jan Mo,We-Fr off; 2030 PH off
#   end
#   it '2030 Jan PH,Mo,We-Fr off "commentaire"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan PH,Mo,We-Fr off "commentaire"'))).to eql('2030 Jan PH,Mo,We-Fr off "commentaire"')
#     # 2030 Jan Mo,We-Fr off "commentaire"; 2030 PH off
#   end
#   it '2030 Jan PH,Mo,We-Fr off "commentaire avec des espaces"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan PH,Mo,We-Fr off "commentaire avec des espaces"'))).to eql('2030 Jan PH,Mo,We-Fr off "commentaire avec des espaces"')
#     # 2030 Jan Mo,We-Fr off "commentaire avec des espaces"; 2030 PH off
#   end
#   it '2030 Jan-Jun PH 10:00-20:00' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan-Jun PH 10:00-20:00'))).to eql('2030 Jan-Jun PH 10:00-20:00')
#     # 2030 PH 10:00-20:00
#   end
#   it '2030 Jan-Jun PH 10:00-20:00 "commentaire"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan-Jun PH 10:00-20:00 "commentaire"'))).to eql('2030 Jan-Jun PH 10:00-20:00 "commentaire"')
#     # 2030 PH 10:00-20:00 "commentaire"
#   end
#   it '2030 Jan-Jun PH 10:00-20:00 "commentaire avec des espaces"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan-Jun PH 10:00-20:00 "commentaire avec des espaces"'))).to eql('2030 Jan-Jun PH 10:00-20:00 "commentaire avec des espaces"')
#     # 2030 PH 10:00-20:00 "commentaire avec des espaces"
#   end
#   it '2030 Jan-Jun PH off' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan-Jun PH off'))).to eql('2030 Jan-Jun PH off')
#     # 2030 PH off
#   end
#   it '2030 Jan-Jun PH off "commentaire"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan-Jun PH off "commentaire"'))).to eql('2030 Jan-Jun PH off "commentaire"')
#     # 2030 PH off "commentaire"
#   end
#   it '2030 Jan-Jun PH off "commentaire avec des espaces"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan-Jun PH off "commentaire avec des espaces"'))).to eql('2030 Jan-Jun PH off "commentaire avec des espaces"')
#     # 2030 PH off "commentaire avec des espaces"
#   end
#   it '2030 Jan-Jun PH 09:00-12:30,14:00-18:30' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan-Jun PH 09:00-12:30,14:00-18:30'))).to eql('2030 Jan-Jun PH 09:00-12:30,14:00-18:30')
#     # 2030 Jan-Jun PH,Mo-Su off
#   end
#   it '2030 Jan-Jun PH 09:00-12:30,14:00-18:30 "commentaire"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan-Jun PH 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('2030 Jan-Jun PH 09:00-12:30,14:00-18:30 "commentaire"')
#     # 2030 Jan-Jun PH,Mo-Su off "commentaire"
#   end
#   it '2030 Jan-Jun PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan-Jun PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('2030 Jan-Jun PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
#     # 2030 Jan-Jun PH,Mo-Su off "commentaire avec des espaces"
#   end
#   it '2030 Jan-Jun PH,Mo,We-Fr off' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan-Jun PH,Mo,We-Fr off'))).to eql('2030 Jan-Jun PH,Mo,We-Fr off')
#     # 2030 Jan-Jun Mo,We-Fr off; 2030 PH off
#   end
#   it '2030 Jan-Jun PH,Mo,We-Fr off "commentaire"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan-Jun PH,Mo,We-Fr off "commentaire"'))).to eql('2030 Jan-Jun PH,Mo,We-Fr off "commentaire"')
#     # 2030 Jan-Jun Mo,We-Fr off "commentaire"; 2030 PH off
#   end
#   it '2030 Jan-Jun PH,Mo,We-Fr off "commentaire avec des espaces"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan-Jun PH,Mo,We-Fr off "commentaire avec des espaces"'))).to eql('2030 Jan-Jun PH,Mo,We-Fr off "commentaire avec des espaces"')
#     # 2030 Jan-Jun Mo,We-Fr off "commentaire avec des espaces"; 2030 PH off
#   end
#   it '2030 Jan-2050 Jun PH 10:00-20:00' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan-2050 Jun PH 10:00-20:00'))).to eql('2030 Jan-2050 Jun PH 10:00-20:00')
#     # 2030-2050 PH 10:00-20:00
#   end
#   it '2030 Jan-2050 Jun PH 10:00-20:00 "commentaire"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan-2050 Jun PH 10:00-20:00 "commentaire"'))).to eql('2030 Jan-2050 Jun PH 10:00-20:00 "commentaire"')
#     # 2030-2050 PH 10:00-20:00 "commentaire"
#   end
#   it '2030 Jan-2050 Jun PH 10:00-20:00 "commentaire avec des espaces"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan-2050 Jun PH 10:00-20:00 "commentaire avec des espaces"'))).to eql('2030 Jan-2050 Jun PH 10:00-20:00 "commentaire avec des espaces"')
#     # 2030-2050 PH 10:00-20:00 "commentaire avec des espaces"
#   end
#   it '2030 Jan-2050 Jun PH off' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan-2050 Jun PH off'))).to eql('2030 Jan-2050 Jun PH off')
#     # 2030-2050 PH off
#   end
#   it '2030 Jan-2050 Jun PH off "commentaire"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan-2050 Jun PH off "commentaire"'))).to eql('2030 Jan-2050 Jun PH off "commentaire"')
#     # 2030-2050 PH off "commentaire"
#   end
#   it '2030 Jan-2050 Jun PH off "commentaire avec des espaces"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan-2050 Jun PH off "commentaire avec des espaces"'))).to eql('2030 Jan-2050 Jun PH off "commentaire avec des espaces"')
#     # 2030-2050 PH off "commentaire avec des espaces"
#   end
#   it '2030 Jan-2050 Jun PH 09:00-12:30,14:00-18:30' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan-2050 Jun PH 09:00-12:30,14:00-18:30'))).to eql('2030 Jan-2050 Jun PH 09:00-12:30,14:00-18:30')
#     # 2030 Jan-2050 Jun PH,Mo-Su off
#   end
#   it '2030 Jan-2050 Jun PH 09:00-12:30,14:00-18:30 "commentaire"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan-2050 Jun PH 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('2030 Jan-2050 Jun PH 09:00-12:30,14:00-18:30 "commentaire"')
#     # 2030 Jan-2050 Jun PH,Mo-Su off "commentaire"
#   end
#   it '2030 Jan-2050 Jun PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan-2050 Jun PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('2030 Jan-2050 Jun PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
#     # 2030 Jan-2050 Jun PH,Mo-Su off "commentaire avec des espaces"
#   end
#   it '2030 Jan-2050 Jun PH,Mo,We-Fr off' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan-2050 Jun PH,Mo,We-Fr off'))).to eql('2030 Jan-2050 Jun PH,Mo,We-Fr off')
#     # 2030 Jan-2050 Jun Mo,We-Fr off; 2030-2050 PH off
#   end
#   it '2030 Jan-2050 Jun PH,Mo,We-Fr off "commentaire"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan-2050 Jun PH,Mo,We-Fr off "commentaire"'))).to eql('2030 Jan-2050 Jun PH,Mo,We-Fr off "commentaire"')
#     # 2030 Jan-2050 Jun Mo,We-Fr off "commentaire"; 2030-2050 PH off
#   end
#   it '2030 Jan-2050 Jun PH,Mo,We-Fr off "commentaire avec des espaces"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan-2050 Jun PH,Mo,We-Fr off "commentaire avec des espaces"'))).to eql('2030 Jan-2050 Jun PH,Mo,We-Fr off "commentaire avec des espaces"')
#     # 2030 Jan-2050 Jun Mo,We-Fr off "commentaire avec des espaces"; 2030-2050 PH off
#   end
#   it '2030 Jan 10-2050 Jun 30 PH 10:00-20:00' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 10-2050 Jun 30 PH 10:00-20:00'))).to eql('2030 Jan 10-2050 Jun 30 PH 10:00-20:00')
#     # 2030-2050 PH 10:00-20:00
#   end
#   it '2030 Jan 10-2050 Jun 30 PH 10:00-20:00 "commentaire"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 10-2050 Jun 30 PH 10:00-20:00 "commentaire"'))).to eql('2030 Jan 10-2050 Jun 30 PH 10:00-20:00 "commentaire"')
#     # 2030-2050 PH 10:00-20:00 "commentaire"
#   end
#   it '2030 Jan 10-2050 Jun 30 PH 10:00-20:00 "commentaire avec des espaces"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 10-2050 Jun 30 PH 10:00-20:00 "commentaire avec des espaces"'))).to eql('2030 Jan 10-2050 Jun 30 PH 10:00-20:00 "commentaire avec des espaces"')
#     # 2030-2050 PH 10:00-20:00 "commentaire avec des espaces"
#   end
#   it '2030 Jan 10-2050 Jun 30 PH off' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 10-2050 Jun 30 PH off'))).to eql('2030 Jan 10-2050 Jun 30 PH off')
#     # 2030-2050 PH off
#   end
#   it '2030 Jan 10-2050 Jun 30 PH off "commentaire"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 10-2050 Jun 30 PH off "commentaire"'))).to eql('2030 Jan 10-2050 Jun 30 PH off "commentaire"')
#     # 2030-2050 PH off "commentaire"
#   end
#   it '2030 Jan 10-2050 Jun 30 PH off "commentaire avec des espaces"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 10-2050 Jun 30 PH off "commentaire avec des espaces"'))).to eql('2030 Jan 10-2050 Jun 30 PH off "commentaire avec des espaces"')
#     # 2030-2050 PH off "commentaire avec des espaces"
#   end
#   it '2030 Jan 10-2050 Jun 30 PH 09:00-12:30,14:00-18:30' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 10-2050 Jun 30 PH 09:00-12:30,14:00-18:30'))).to eql('2030 Jan 10-2050 Jun 30 PH 09:00-12:30,14:00-18:30')
#     # 2030 Jan 10-2050 Jun 30 PH,Mo-Su off
#   end
#   it '2030 Jan 10-2050 Jun 30 PH 09:00-12:30,14:00-18:30 "commentaire"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 10-2050 Jun 30 PH 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('2030 Jan 10-2050 Jun 30 PH 09:00-12:30,14:00-18:30 "commentaire"')
#     # 2030 Jan 10-2050 Jun 30 PH,Mo-Su off "commentaire"
#   end
#   it '2030 Jan 10-2050 Jun 30 PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 10-2050 Jun 30 PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('2030 Jan 10-2050 Jun 30 PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
#     # 2030 Jan 10-2050 Jun 30 PH,Mo-Su off "commentaire avec des espaces"
#   end
#   it '2030 Jan 10-2050 Jun 30 PH,Mo,We-Fr off' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 10-2050 Jun 30 PH,Mo,We-Fr off'))).to eql('2030 Jan 10-2050 Jun 30 PH,Mo,We-Fr off')
#     # 2030 Jan 10-2050 Jun 30 Mo,We-Fr off; 2030-2050 PH off
#   end
#   it '2030 Jan 10-2050 Jun 30 PH,Mo,We-Fr off "commentaire"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 10-2050 Jun 30 PH,Mo,We-Fr off "commentaire"'))).to eql('2030 Jan 10-2050 Jun 30 PH,Mo,We-Fr off "commentaire"')
#     # 2030 Jan 10-2050 Jun 30 Mo,We-Fr off "commentaire"; 2030-2050 PH off
#   end
#   it '2030 Jan 10-2050 Jun 30 PH,Mo,We-Fr off "commentaire avec des espaces"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030 Jan 10-2050 Jun 30 PH,Mo,We-Fr off "commentaire avec des espaces"'))).to eql('2030 Jan 10-2050 Jun 30 PH,Mo,We-Fr off "commentaire avec des espaces"')
#     # 2030 Jan 10-2050 Jun 30 Mo,We-Fr off "commentaire avec des espaces"; 2030-2050 PH off
#   end
#   it '2030-2050 PH 09:00-12:30,14:00-18:30' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030-2050 PH 09:00-12:30,14:00-18:30'))).to eql('2030-2050 PH 09:00-12:30,14:00-18:30')
#     # 2030-2050 PH,Mo-Su off
#   end
#   it '2030-2050 PH 09:00-12:30,14:00-18:30 "commentaire"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030-2050 PH 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('2030-2050 PH 09:00-12:30,14:00-18:30 "commentaire"')
#     # 2030-2050 PH,Mo-Su off "commentaire"
#   end
#   it '2030-2050 PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030-2050 PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('2030-2050 PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
#     # 2030-2050 PH,Mo-Su off "commentaire avec des espaces"
#   end
#   it '2030-2050 PH,Mo,We-Fr off' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030-2050 PH,Mo,We-Fr off'))).to eql('2030-2050 PH,Mo,We-Fr off')
#     # 2030-2050 Mo,We-Fr off; 2030-2050 PH off
#   end
#   it '2030-2050 PH,Mo,We-Fr off "commentaire"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030-2050 PH,Mo,We-Fr off "commentaire"'))).to eql('2030-2050 PH,Mo,We-Fr off "commentaire"')
#     # 2030-2050 Mo,We-Fr off "commentaire"; 2030-2050 PH off
#   end
#   it '2030-2050 PH,Mo,We-Fr off "commentaire avec des espaces"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('2030-2050 PH,Mo,We-Fr off "commentaire avec des espaces"'))).to eql('2030-2050 PH,Mo,We-Fr off "commentaire avec des espaces"')
#     # 2030-2050 Mo,We-Fr off "commentaire avec des espaces"; 2030-2050 PH off
#   end
#   it 'Jan PH 10:00-20:00' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan PH 10:00-20:00'))).to eql('Jan PH 10:00-20:00')
#     # PH 10:00-20:00
#   end
#   it 'Jan PH 10:00-20:00 "commentaire"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan PH 10:00-20:00 "commentaire"'))).to eql('Jan PH 10:00-20:00 "commentaire"')
#     # PH 10:00-20:00 "commentaire"
#   end
#   it 'Jan PH 10:00-20:00 "commentaire avec des espaces"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan PH 10:00-20:00 "commentaire avec des espaces"'))).to eql('Jan PH 10:00-20:00 "commentaire avec des espaces"')
#     # PH 10:00-20:00 "commentaire avec des espaces"
#   end
#   it 'Jan PH off' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan PH off'))).to eql('Jan PH off')
#     # PH off
#   end
#   it 'Jan PH off "commentaire"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan PH off "commentaire"'))).to eql('Jan PH off "commentaire"')
#     # PH off "commentaire"
#   end
#   it 'Jan PH off "commentaire avec des espaces"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan PH off "commentaire avec des espaces"'))).to eql('Jan PH off "commentaire avec des espaces"')
#     # PH off "commentaire avec des espaces"
#   end
#   it 'Jan PH 09:00-12:30,14:00-18:30' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan PH 09:00-12:30,14:00-18:30'))).to eql('Jan PH 09:00-12:30,14:00-18:30')
#     # Jan PH,Mo-Su off
#   end
#   it 'Jan PH 09:00-12:30,14:00-18:30 "commentaire"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan PH 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('Jan PH 09:00-12:30,14:00-18:30 "commentaire"')
#     # Jan PH,Mo-Su off "commentaire"
#   end
#   it 'Jan PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('Jan PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
#     # Jan PH,Mo-Su off "commentaire avec des espaces"
#   end
#   it 'Jan PH,Mo,We-Fr off' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan PH,Mo,We-Fr off'))).to eql('Jan PH,Mo,We-Fr off')
#     # Jan Mo,We-Fr off; PH off
#   end
#   it 'Jan PH,Mo,We-Fr off "commentaire"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan PH,Mo,We-Fr off "commentaire"'))).to eql('Jan PH,Mo,We-Fr off "commentaire"')
#     # Jan Mo,We-Fr off "commentaire"; PH off
#   end
#   it 'Jan PH,Mo,We-Fr off "commentaire avec des espaces"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan PH,Mo,We-Fr off "commentaire avec des espaces"'))).to eql('Jan PH,Mo,We-Fr off "commentaire avec des espaces"')
#     # Jan Mo,We-Fr off "commentaire avec des espaces"; PH off
#   end
#   it 'Jan-Jun PH 10:00-20:00' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan-Jun PH 10:00-20:00'))).to eql('Jan-Jun PH 10:00-20:00')
#     # PH 10:00-20:00
#   end
#   it 'Jan-Jun PH 10:00-20:00 "commentaire"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan-Jun PH 10:00-20:00 "commentaire"'))).to eql('Jan-Jun PH 10:00-20:00 "commentaire"')
#     # PH 10:00-20:00 "commentaire"
#   end
#   it 'Jan-Jun PH 10:00-20:00 "commentaire avec des espaces"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan-Jun PH 10:00-20:00 "commentaire avec des espaces"'))).to eql('Jan-Jun PH 10:00-20:00 "commentaire avec des espaces"')
#     # PH 10:00-20:00 "commentaire avec des espaces"
#   end
#   it 'Jan-Jun PH off' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan-Jun PH off'))).to eql('Jan-Jun PH off')
#     # PH off
#   end
#   it 'Jan-Jun PH off "commentaire"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan-Jun PH off "commentaire"'))).to eql('Jan-Jun PH off "commentaire"')
#     # PH off "commentaire"
#   end
#   it 'Jan-Jun PH off "commentaire avec des espaces"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan-Jun PH off "commentaire avec des espaces"'))).to eql('Jan-Jun PH off "commentaire avec des espaces"')
#     # PH off "commentaire avec des espaces"
#   end
#   it 'Jan-Jun PH 09:00-12:30,14:00-18:30' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan-Jun PH 09:00-12:30,14:00-18:30'))).to eql('Jan-Jun PH 09:00-12:30,14:00-18:30')
#     # Jan-Jun PH,Mo-Su off
#   end
#   it 'Jan-Jun PH 09:00-12:30,14:00-18:30 "commentaire"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan-Jun PH 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('Jan-Jun PH 09:00-12:30,14:00-18:30 "commentaire"')
#     # Jan-Jun PH,Mo-Su off "commentaire"
#   end
#   it 'Jan-Jun PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan-Jun PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('Jan-Jun PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
#     # Jan-Jun PH,Mo-Su off "commentaire avec des espaces"
#   end
#   it 'Jan-Jun PH,Mo,We-Fr off' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan-Jun PH,Mo,We-Fr off'))).to eql('Jan-Jun PH,Mo,We-Fr off')
#     # Jan-Jun Mo,We-Fr off; PH off
#   end
#   it 'Jan-Jun PH,Mo,We-Fr off "commentaire"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan-Jun PH,Mo,We-Fr off "commentaire"'))).to eql('Jan-Jun PH,Mo,We-Fr off "commentaire"')
#     # Jan-Jun Mo,We-Fr off "commentaire"; PH off
#   end
#   it 'Jan-Jun PH,Mo,We-Fr off "commentaire avec des espaces"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan-Jun PH,Mo,We-Fr off "commentaire avec des espaces"'))).to eql('Jan-Jun PH,Mo,We-Fr off "commentaire avec des espaces"')
#     # Jan-Jun Mo,We-Fr off "commentaire avec des espaces"; PH off
#   end
#   it 'Jan 10-Jun 30 PH 10:00-20:00' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan 10-Jun 30 PH 10:00-20:00'))).to eql('Jan 10-Jun 30 PH 10:00-20:00')
#     # PH 10:00-20:00
#   end
#   it 'Jan 10-Jun 30 PH 10:00-20:00 "commentaire"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan 10-Jun 30 PH 10:00-20:00 "commentaire"'))).to eql('Jan 10-Jun 30 PH 10:00-20:00 "commentaire"')
#     # PH 10:00-20:00 "commentaire"
#   end
#   it 'Jan 10-Jun 30 PH 10:00-20:00 "commentaire avec des espaces"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan 10-Jun 30 PH 10:00-20:00 "commentaire avec des espaces"'))).to eql('Jan 10-Jun 30 PH 10:00-20:00 "commentaire avec des espaces"')
#     # PH 10:00-20:00 "commentaire avec des espaces"
#   end
#   it 'Jan 10-Jun 30 PH off' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan 10-Jun 30 PH off'))).to eql('Jan 10-Jun 30 PH off')
#     # PH off
#   end
#   it 'Jan 10-Jun 30 PH off "commentaire"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan 10-Jun 30 PH off "commentaire"'))).to eql('Jan 10-Jun 30 PH off "commentaire"')
#     # PH off "commentaire"
#   end
#   it 'Jan 10-Jun 30 PH off "commentaire avec des espaces"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan 10-Jun 30 PH off "commentaire avec des espaces"'))).to eql('Jan 10-Jun 30 PH off "commentaire avec des espaces"')
#     # PH off "commentaire avec des espaces"
#   end
#   it 'Jan 10-Jun 30 PH 09:00-12:30,14:00-18:30' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan 10-Jun 30 PH 09:00-12:30,14:00-18:30'))).to eql('Jan 10-Jun 30 PH 09:00-12:30,14:00-18:30')
#     # Jan 10-Jun 30 PH,Mo-Su off
#   end
#   it 'Jan 10-Jun 30 PH 09:00-12:30,14:00-18:30 "commentaire"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan 10-Jun 30 PH 09:00-12:30,14:00-18:30 "commentaire"'))).to eql('Jan 10-Jun 30 PH 09:00-12:30,14:00-18:30 "commentaire"')
#     # Jan 10-Jun 30 PH,Mo-Su off "commentaire"
#   end
#   it 'Jan 10-Jun 30 PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan 10-Jun 30 PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"'))).to eql('Jan 10-Jun 30 PH 09:00-12:30,14:00-18:30 "commentaire avec des espaces"')
#     # Jan 10-Jun 30 PH,Mo-Su off "commentaire avec des espaces"
#   end
#   it 'Jan 10-Jun 30 PH,Mo,We-Fr off' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan 10-Jun 30 PH,Mo,We-Fr off'))).to eql('Jan 10-Jun 30 PH,Mo,We-Fr off')
#     # Jan 10-Jun 30 Mo,We-Fr off; PH off
#   end
#   it 'Jan 10-Jun 30 PH,Mo,We-Fr off "commentaire"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan 10-Jun 30 PH,Mo,We-Fr off "commentaire"'))).to eql('Jan 10-Jun 30 PH,Mo,We-Fr off "commentaire"')
#     # Jan 10-Jun 30 Mo,We-Fr off "commentaire"; PH off
#   end
#   it 'Jan 10-Jun 30 PH,Mo,We-Fr off "commentaire avec des espaces"' do
#     expect(OpeningHoursConverter::OpeningHoursBuilder.new.build(OpeningHoursConverter::OpeningHoursParser.new.parse('Jan 10-Jun 30 PH,Mo,We-Fr off "commentaire avec des espaces"'))).to eql('Jan 10-Jun 30 PH,Mo,We-Fr off "commentaire avec des espaces"')
#     # Jan 10-Jun 30 Mo,We-Fr off "commentaire avec des espaces"; PH off
#   end
# end
