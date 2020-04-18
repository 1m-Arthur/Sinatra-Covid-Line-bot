require 'sinatra'
require 'line/bot'
require 'net/http'
require 'json'
require 'active_support'
require 'date'

include ActiveSupport::NumberHelper

set :app_base_url, ENV['APP_BASE_URL']

def client
    @client ||= Line::Bot::Client.new do |config|
        config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
        config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
        config.http_options = {
            open_timeout: 5,
            read_timeout: 5,
        }
    end
end

def reply_text(event, texts)
    texts = [texts] if texts.is_a?(String)
    client.reply_message(
        event['replyToken'],
        texts.map { |text| {type: 'text', text: text} }
    )
end

get '/' do
    'Axe said Good day sir!'
end

post '/webhooked' do

    body = request.body.read

    signature = request.env['HTTP_X_LINE_SIGNATURE']
    unless client.validate_signature(body, signature)
        halt 400, {'Content-Type' => 'text/plain'}, 'Bad Request'
    end

    events = client.parse_events_from(body)

    events.each do |event|
        case event
        when Line::Bot::Event::Message
            handle_message(event)
        
        when Line::Bot::Event::Follow
            if event['source']['type'] == 'user'
                profile = client.get_profile(event['source']['userId'])
                profile = JSON.parse(profile.read_body)
                reply_text(event, "Hai #{profile['displayName']}, Terimakasih telah menambahkan kami sebagai teman. \n\n"+
                    "Jika kalian ingin tau mengenai kami kalian bisa kenalan dengan kami dengan ketik \"about us\". \n\n"+
                    "Dan Kalian bisa ketik \"Negara List\" atau \"Provinsi List\" untuk melihat semua daftar negara mana saja yang terkena dampak virus ini sob. \n\n"+
                    "Selanjutnya, kalian bisa ketik \"Negara tujuan\" atau \"Provinsi tujuan\" untuk mengetahui berapa banyaknya orang yang dinyatakan positif, sembuh dan meninggal. \n\n"+
                    "Serta kalian bisa ketik \"Global Data\" untuk mengetahui total data. atau bisa secara spesifik dengan \"global positif\", \"global sembuh\", \"global meninggal\"
                ")
            else
                reply_text(event, "Bot can't use profile API without user ID")
            end
        else
            reply_text(event, "Aku tidak tau maksud dari apa yang kalian lakukan :(")
        end
    end   
    "OK"
end

def handle_message(event)
    case event.type
    when Line::Bot::Event::MessageType::Text
        eventMsgText = event.message['text'].downcase!
        if (eventMsgText.include? "about us")
            return reply_text(event, "Kami adalah bot yang dibuat dari bahasa pemrograman Ruby framework Sinatra. \nData kami berasal dari kawalcorona.com dan kami yakin data tersebut valid. \n")
        elsif (eventMsgText.include? "negara")
            if (eventMsgText.include? "list")
                countries = []
                api_handler.each do |item|
                    countries.concat([item['attributes']['Country_Region']])
                end
                return reply_text(event, "Berikut adalah daftar-daftar negara yang kami ketahui: \n#{countries.join("\n")}")
            elsif ((eventMsgText.include? "us") || (eventMsgText.include? "usa") || (eventMsgText.include? "united states"))
                return reply_text(event, countryReply(0))
            elsif ((eventMsgText.include? "spain") || (eventMsgText.include? "spanyol"))
                return reply_text(event, countryReply(1))
            elsif ((eventMsgText.include? "italy") || (eventMsgText.include? "Italia"))
                return reply_text(event, countryReply(2))
            elsif ((eventMsgText.include? "france") || (eventMsgText.include? "perancis"))
                return reply_text(event, countryReply(3))
            elsif ((eventMsgText.include? "germany") || (eventMsgText.include? "jerman"))
                return reply_text(event, countryReply(4))
            elsif ((eventMsgText.include? "uk") || (eventMsgText.include? "united kingdom"))
                return reply_text(event, countryReply(5))
            elsif (eventMsgText.include? "china")
                return reply_text(event, countryReply(6))
            elsif (eventMsgText.include? "iran")
                return reply_text(event, countryReply(7))
            elsif (eventMsgText.include? "turkey") || (eventMsgText.include? "turki")
                return reply_text(event, countryReply(8))
            elsif (eventMsgText.include? "belgium") || (eventMsgText.include? "belgia")
                return reply_text(event, countryReply(9))
            elsif (eventMsgText.include? "brazil")
                return reply_text(event, countryReply(10))
            elsif (eventMsgText.include? "canada")
                return reply_text(event, countryReply(11))
            elsif (eventMsgText.include? "russia") || (eventMsgText.include? "rusia")
                return reply_text(event, countryReply(12))
            elsif (eventMsgText.include? "netherlands") || (eventMsgText.include? "belanda")
                return reply_text(event, countryReply(13))
            elsif (eventMsgText.include? "switzerland") || (eventMsgText.include? "swis")
                return reply_text(event, countryReply(14))
            elsif (eventMsgText.include? "portugal")
                return reply_text(event, countryReply(15))
            elsif (eventMsgText.include? "austria")
                return reply_text(event, countryReply(16))
            elsif (eventMsgText.include? "india")
                return reply_text(event, countryReply(17))
            elsif (eventMsgText.include? "ireland") || (eventMsgText.include? "irlandia")
                return reply_text(event, countryReply(18))
            elsif (eventMsgText.include? "peru")
                return reply_text(event, countryReply(19))
            elsif (eventMsgText.include? "sweden")
                return reply_text(event, countryReply(20))
            elsif (eventMsgText.include? "israel")
                return reply_text(event, countryReply(21))
            elsif (eventMsgText.include? "korea") || (eventMsgText.include? "south korea") || (eventMsgText.include? "korea, south")
                return reply_text(event, countryReply(22))
            elsif (eventMsgText.include? "japan") || (eventMsgText.include? "jepang")
                return reply_text(event, countryReply(23))
            elsif (eventMsgText.include? "chile")
                return reply_text(event, countryReply(24))
            elsif (eventMsgText.include? "ecuador") || (eventMsgText.include? "ekuador")
                return reply_text(event, countryReply(25))
            elsif (eventMsgText.include? "poland") || (eventMsgText.include? "polandia")
                return reply_text(event, countryReply(26))
            elsif (eventMsgText.include? "romania") || (eventMsgText.include? "roma")
                return reply_text(event, countryReply(27))
            elsif (eventMsgText.include? "denmark")
                return reply_text(event, countryReply(28))
            elsif (eventMsgText.include? "saudi arabia") || (eventMsgText.include? "arab")
                return reply_text(event, countryReply(29))
            elsif (eventMsgText.include? "pakistan")
                return reply_text(event, countryReply(30))
            elsif (eventMsgText.include? "norway")
                return reply_text(event, countryReply(31))
            elsif (eventMsgText.include? "australia")
                return reply_text(event, countryReply(32))
            elsif (eventMsgText.include? "czechia") || (eventMsgText.include? "czech")
                return reply_text(event, countryReply(33))
            elsif (eventMsgText.include? "united arab emirates") || (eventMsgText.include? "uae")
                return reply_text(event, countryReply(34))
            elsif (eventMsgText.include? "mexico") || (eventMsgText.include? "meksiko")
                return reply_text(event, countryReply(35))
            elsif (eventMsgText.include? "indonesia")
                return reply_text(event, countryReply(36))
            elsif (eventMsgText.include? "philippines") || (eventMsgText.include? "filipina")
                return reply_text(event, countryReply(37))
            elsif (eventMsgText.include? "serbia")
                return reply_text(event, countryReply(38))
            elsif (eventMsgText.include? "malaysia")
                return reply_text(event, countryReply(39))
            elsif (eventMsgText.include? "singapore") || (eventMsgText.include? "singapura")
                return reply_text(event, countryReply(40))
            elsif (eventMsgText.include? "belarus")
                return reply_text(event, countryReply(41))
            elsif (eventMsgText.include? "qatar")
                return reply_text(event, countryReply(42))
            elsif (eventMsgText.include? "ukraine") || (eventMsgText.include? "ukraina")
                return reply_text(event, countryReply(43))
            elsif (eventMsgText.include? "dominican republic")
                return reply_text(event, countryReply(44))
            elsif (eventMsgText.include? "panama")
                return reply_text(event, countryReply(45))
            elsif (eventMsgText.include? "findland")
                return reply_text(event, countryReply(46))
            elsif (eventMsgText.include? "luxembourg")
                return reply_text(event, countryReply(47))
            elsif (eventMsgText.include? "colombia")
                return reply_text(event, countryReply(48))
            elsif (eventMsgText.include? "egypt")
                return reply_text(event, countryReply(49))
            elsif (eventMsgText.include? "south africa") || (eventMsgText.include? "afrika selatan")
                return reply_text(event, countryReply(50))
            elsif (eventMsgText.include? "thailand")
                return reply_text(event, countryReply(51))
            elsif (eventMsgText.include? "argentina")
                return reply_text(event, countryReply(52))
            elsif (eventMsgText.include? "morocco")
                return reply_text(event, countryReply(53))
            elsif (eventMsgText.include? "algeria")
                return reply_text(event, countryReply(54))
            elsif (eventMsgText.include? "moldova")
                return reply_text(event, countryReply(55))
            elsif (eventMsgText.include? "greece")
                return reply_text(event, countryReply(56))
            elsif (eventMsgText.include? "bangladesh")
                return reply_text(event, countryReply(57))
            elsif (eventMsgText.include? "croatia")
                return reply_text(event, countryReply(58))
            elsif (eventMsgText.include? "hungary")
                return reply_text(event, countryReply(59))
            elsif (eventMsgText.include? "iceland")
                return reply_text(event, countryReply(60))
            elsif (eventMsgText.include? "bahrain")
                return reply_text(event, countryReply(61))
            elsif (eventMsgText.include? "kuwait")
                return reply_text(event, countryReply(62))
            elsif (eventMsgText.include? "kazakhstan")
                return reply_text(event, countryReply(63))
            elsif (eventMsgText.include? "iraq")
                return reply_text(event, countryReply(64))
            elsif (eventMsgText.include? "estonia")
                return reply_text(event, countryReply(65))
            elsif (eventMsgText.include? "new zealand")
                return reply_text(event, countryReply(66))
            elsif (eventMsgText.include? "uzbekistan")
                return reply_text(event, countryReply(66))
            elsif (eventMsgText.include? "azerbaijan")
                return reply_text(event, countryReply(67))
            elsif (eventMsgText.include? "slovenia")
                return reply_text(event, countryReply(68))
            elsif (eventMsgText.include? "cameroon")
                return reply_text(event, countryReply(67))
            elsif (eventMsgText.include? "cuba")
                return reply_text(event, countryReply(68))
            elsif (eventMsgText.include? "afghanistan")
                return reply_text(event, countryReply(69))
            elsif (eventMsgText.include? "tunisia")
                return reply_text(event, countryReply(70))
            elsif (eventMsgText.include? "bulgaria")
                return reply_text(event, countryReply(71))
            elsif (eventMsgText.include? "cyprus")
                return reply_text(event, countryReply(72))
            elsif (eventMsgText.include? "djibouti")
                return reply_text(event, countryReply(73))
            elsif (eventMsgText.include? "diamond princess")
                return reply_text(event, countryReply(74))
            elsif (eventMsgText.include? "andorra")
                return reply_text(event, countryReply(75))
            elsif (eventMsgText.include? "cote d'ivoire")
                return reply_text(event, countryReply(76))
            elsif (eventMsgText.include? "latvia")
                return reply_text(event, countryReply(77))
            elsif (eventMsgText.include? "lebanon")
                return reply_text(event, countryReply(78))
            elsif (eventMsgText.include? "costa rica")
                return reply_text(event, countryReply(79))
            elsif (eventMsgText.include? "ghana")
                return reply_text(event, countryReply(80))
            elsif (eventMsgText.include? "niger")
                return reply_text(event, countryReply(81))
            elsif (eventMsgText.include? "burkina faso")
                return reply_text(event, countryReply(82))
            elsif (eventMsgText.include? "albania")
                return reply_text(event, countryReply(83))
            elsif (eventMsgText.include? "uruguay")
                return reply_text(event, countryReply(84))
            elsif (eventMsgText.include? "nigeria")
                return reply_text(event, countryReply(85))
            elsif (eventMsgText.include? "kyrgyzstan")
                return reply_text(event, countryReply(86))
            elsif (eventMsgText.include? "kosovo")
                return reply_text(event, countryReply(87))
            elsif (eventMsgText.include? "guinea")
                return reply_text(event, countryReply(88))
            elsif (eventMsgText.include? "bolivia")
                return reply_text(event, countryReply(89))
            elsif (eventMsgText.include? "honduras")
                return reply_text(event, countryReply(90))
            elsif (eventMsgText.include? "san marino")
                return reply_text(event, countryReply(91))
            elsif (eventMsgText.include? "malta")
                return reply_text(event, countryReply(92))
            elsif (eventMsgText.include? "jordan")
                return reply_text(event, countryReply(93))
            elsif (eventMsgText.include? "west bank and gaza")
                return reply_text(event, countryReply(94))
            elsif (eventMsgText.include? "taiwan")
                return reply_text(event, countryReply(95))
            elsif (eventMsgText.include? "georgia")
                return reply_text(event, countryReply(96))
            elsif (eventMsgText.include? "senegal")
                return reply_text(event, countryReply(97))
            elsif (eventMsgText.include? "mauritius")
                return reply_text(event, countryReply(98))
            elsif (eventMsgText.include? "montenegoro")
                return reply_text(event, countryReply(99))
            elsif (eventMsgText.include? "congo")
                return reply_text(event, countryReply(100))
            elsif (eventMsgText.include? "vietnam")
                return reply_text(event, countryReply(101))
            elsif (eventMsgText.include? "kenya")
                return reply_text(event, countryReply(102))
            elsif (eventMsgText.include? "sri lanka")
                return reply_text(event, countryReply(103))
            elsif (eventMsgText.include? "guatemala")
                return reply_text(event, countryReply(104))
            elsif (eventMsgText.include? "venezuela")
                return reply_text(event, countryReply(105))
            elsif (eventMsgText.include? "paraguay")
                return reply_text(event, countryReply(106))
            elsif (eventMsgText.include? "el salvador")
                return reply_text(event, countryReply(107))
            elsif (eventMsgText.include? "mali")
                return reply_text(event, countryReply(108))
            elsif (eventMsgText.include? "tanzania")
                return reply_text(event, countryReply(109))
            elsif (eventMsgText.include? "congo") || (eventMsgText.include? "brazzaville")
                return reply_text(event, countryReply(110))
            elsif (eventMsgText.include? "jamaica")
                return reply_text(event, countryReply(111))
            elsif (eventMsgText.include? "rwanda")
                return reply_text(event, countryReply(112))
            elsif (eventMsgText.include? "brunei")
                return reply_text(event, countryReply(113))
            elsif (eventMsgText.include? "cambodia")
                return reply_text(event, countryReply(114))
            elsif (eventMsgText.include? "madagascar")
                return reply_text(event, countryReply(115))
            elsif (eventMsgText.include? "somalia")
                return reply_text(event, countryReply(116))
            elsif (eventMsgText.include? "trinidad and tobago")
                return reply_text(event, countryReply(117))
            elsif (eventMsgText.include? "gabon")
                return reply_text(event, countryReply(118))
            elsif (eventMsgText.include? "ethiopia")
                return reply_text(event, countryReply(119))
            elsif (eventMsgText.include? "monaco")
                return reply_text(event, countryReply(120))
            elsif (eventMsgText.include? "burma")
                return reply_text(event, countryReply(121))
            elsif (eventMsgText.include? "togo")
                return reply_text(event, countryReply(122))
            elsif (eventMsgText.include? "equatorial guinea")
                return reply_text(event, countryReply(123))
            elsif (eventMsgText.include? "liechtenstein")
                return reply_text(event, countryReply(124))
            elsif (eventMsgText.include? "liberia")
                return reply_text(event, countryReply(125))
            elsif (eventMsgText.include? "barbados")
                return reply_text(event, countryReply(126))
            elsif (eventMsgText.include? "guyana")
                return reply_text(event, countryReply(127))
            elsif (eventMsgText.include? "cabo verde")
                return reply_text(event, countryReply(128))
            elsif (eventMsgText.include? "uganda")
                return reply_text(event, countryReply(129))
            elsif (eventMsgText.include? "bahamas")
                return reply_text(event, countryReply(130))
            elsif (eventMsgText.include? "zambia")
                return reply_text(event, countryReply(131))
            elsif (eventMsgText.include? "libya")
                return reply_text(event, countryReply(132))
            elsif (eventMsgText.include? "guinea-bissau")
                return reply_text(event, countryReply(133))
            elsif (eventMsgText.include? "haiti")
                return reply_text(event, countryReply(134))
            elsif (eventMsgText.include? "syria")
                return reply_text(event, countryReply(135))
            elsif (eventMsgText.include? "benin")
                return reply_text(event, countryReply(136))
            elsif (eventMsgText.include? "eritrea")
                return reply_text(event, countryReply(137))
            elsif (eventMsgText.include? "mozambique")
                return reply_text(event, countryReply(138))
            elsif (eventMsgText.include? "sudan")
                return reply_text(event, countryReply(139))
            elsif (eventMsgText.include? "mongolia")
                return reply_text(event, countryReply(140))
            elsif (eventMsgText.include? "nepal")
                return reply_text(event, countryReply(141))
            elsif (eventMsgText.include? "maldives")
                return reply_text(event, countryReply(142))
            elsif (eventMsgText.include? "chad")
                return reply_text(event, countryReply(143))
            elsif (eventMsgText.include? "sierra leone")
                return reply_text(event, countryReply(144))
            elsif (eventMsgText.include? "zimbabwe")
                return reply_text(event, countryReply(145))
            elsif (eventMsgText.include? "antigua and barbuda")
                return reply_text(event, countryReply(146))
            elsif (eventMsgText.include? "angola")
                return reply_text(event, countryReply(147))
            elsif (eventMsgText.include? "laos")
                return reply_text(event, countryReply(148))
            elsif (eventMsgText.include? "belize")
                return reply_text(event, countryReply(149))
            elsif (eventMsgText.include? "timor-leste")
                return reply_text(event, countryReply(150))
            elsif (eventMsgText.include? "eswatini")
                return reply_text(event, countryReply(151))
            elsif (eventMsgText.include? "fiji")
                return reply_text(event, countryReply(152))
            elsif (eventMsgText.include? "malawi")
                return reply_text(event, countryReply(153))
            elsif (eventMsgText.include? "dominica")
                return reply_text(event, countryReply(154))
            elsif (eventMsgText.include? "namibia")
                return reply_text(event, countryReply(155))
            elsif (eventMsgText.include? "botswana")
                return reply_text(event, countryReply(156))
            elsif (eventMsgText.include? "saint lucia")
                return reply_text(event, countryReply(157))
            elsif (eventMsgText.include? "grenada")
                return reply_text(event, countryReply(158))
            elsif (eventMsgText.include? "saint kitts and nevis")
                return reply_text(event, countryReply(159))
            elsif (eventMsgText.include? "central african republic")
                return reply_text(event, countryReply(160))
            elsif (eventMsgText.include? "saint vincent and the grenadines")
                return reply_text(event, countryReply(161))
            elsif (eventMsgText.include? "seychelles")
                return reply_text(event, countryReply(162))
            elsif (eventMsgText.include? "suriname")
                return reply_text(event, countryReply(163))
            elsif (eventMsgText.include? "gambia")
                return reply_text(event, countryReply(164))
            elsif (eventMsgText.include? "ms zaandam")
                return reply_text(event, countryReply(165))
            elsif (eventMsgText.include? "nicaragua")
                return reply_text(event, countryReply(166))
            elsif (eventMsgText.include? "holy see")
                return reply_text(event, countryReply(167))
            elsif (eventMsgText.include? "mauritania")
                return reply_text(event, countryReply(168))
            elsif (eventMsgText.include? "papua new guinea")
                return reply_text(event, countryReply(169))
            elsif (eventMsgText.include? "western sahara")
                return reply_text(event, countryReply(170))
            elsif (eventMsgText.include? "bhutan")
                return reply_text(event, countryReply(171))
            elsif (eventMsgText.include? "burundi")
                return reply_text(event, countryReply(172))
            elsif (eventMsgText.include? "sao tome and principe")
                return reply_text(event, countryReply(173))
            elsif (eventMsgText.include? "south sudan")
                return reply_text(event, countryReply(174))
            elsif (eventMsgText.include? "yemen")
                return reply_text(event, countryReply(175))
            else
                return reply_text(event, "kami belum kenal negara yang kamu tuju")
            end
        elsif (eventMsgText.include? "provinsi")
            if (eventMsgText.include? "list")
                provinces = []
                api_handler_province.each do |item|
                    provinces.concat([item['attributes']['Provinsi']])
                end
                return reply_text(event, "Berikut adalah daftar-daftar provinsi yang kami ketahui: \n#{provinces.join("\n")}")
            elsif (eventMsgText.include? "dki jakarta") || (eventMsgText.include? "jakarta")
                return reply_text(event, provinceReply(0))
            elsif (eventMsgText.include? "jawa barat") || (eventMsgText.include? "jabar")
                return reply_text(event, provinceReply(1))
            elsif (eventMsgText.include? "jawa timur")
                return reply_text(event, provinceReply(2))
            elsif (eventMsgText.include? "sulawesi selatan") || (eventMsgText.include? "sulsel")
                return reply_text(event, provinceReply(3))
            elsif (eventMsgText.include? "banten")
                return reply_text(event, provinceReply(4))
            elsif (eventMsgText.include? "jawa tengah")
                return reply_text(event, provinceReply(5))
            elsif (eventMsgText.include? "bali")
                return reply_text(event, provinceReply(6))
            elsif (eventMsgText.include? "papua")
                return reply_text(event, provinceReply(7))
            elsif (eventMsgText.include? "sumatera utara") || (eventMsgText.include? "sumut")
                return reply_text(event, provinceReply(8))
            elsif (eventMsgText.include? "kalimantan selatan") || (eventMsgText.include? "kalsel")
                return reply_text(event, provinceReply(9))
            elsif (eventMsgText.include? "daerah istimewa yogyakarta") || (eventMsgText.include? "jogja") || (eventMsgText.include? "yogyakarta")
                return reply_text(event, provinceReply(10))
            elsif (eventMsgText.include? "sumatera barat") || (eventMsgText.include? "sumbar")
                return reply_text(event, provinceReply(11))
            elsif (eventMsgText.include? "kepulauan riau")
                return reply_text(event, provinceReply(12))
            elsif (eventMsgText.include? "sumatera selatan") || (eventMsgText.include? "sumsel")
                return reply_text(event, provinceReply(13))
            elsif (eventMsgText.include? "nusa tenggara barat") || (eventMsgText.include? "ntb")
                return reply_text(event, provinceReply(14))
            elsif (eventMsgText.include? "kalimantan utara") || (eventMsgText.include? "kalut")
                return reply_text(event, provinceReply(15))
            elsif (eventMsgText.include? "kalimantan timur") || (eventMsgText.include? "kaltim")
                return reply_text(event, provinceReply(16))
            elsif (eventMsgText.include? "kalimantan tengah") || (eventMsgText.include? "kalteng")
                return reply_text(event, provinceReply(17))
            elsif (eventMsgText.include? "sulawesi tenggara")
                return reply_text(event, provinceReply(18))
            elsif (eventMsgText.include? "riau")
                return reply_text(event, provinceReply(19))
            elsif (eventMsgText.include? "lampung")
                return reply_text(event, provinceReply(20))
            elsif (eventMsgText.include? "sulawesi tengah") || (eventMsgText.include? "sulteng")
                return reply_text(event, provinceReply(21))
            elsif (eventMsgText.include? "kalimantan barat") || (eventMsgText.include? "kalbar")
                return reply_text(event, provinceReply(22))
            elsif (eventMsgText.include? "sulawesi utara") || (eventMsgText.include? "sulut")
                return reply_text(event, provinceReply(23))
            elsif (eventMsgText.include? "maluku")
                return reply_text(event, provinceReply(24))
            elsif (eventMsgText.include? "jambi")
                return reply_text(event, provinceReply(25))
            elsif (eventMsgText.include? "sulawesi barat") || (eventMsgText.include? "sulbar")
                return reply_text(event, provinceReply(26))
            elsif (eventMsgText.include? "kepulauan bangka belitung") || (eventMsgText.include? "bangka belitung") || (eventMsgText.include? "belitung")
                return reply_text(event, provinceReply(27))
            elsif (eventMsgText.include? "aceh")
                return reply_text(event, provinceReply(28))
            elsif (eventMsgText.include? "papua barat")
                return reply_text(event, provinceReply(29))
            elsif (eventMsgText.include? "bengkulu")
                return reply_text(event, provinceReply(30))
            elsif (eventMsgText.include? "gorontalo")
                return reply_text(event, provinceReply(31))
            elsif (eventMsgText.include? "maluku utara")
                return reply_text(event, provinceReply(32))
            elsif (eventMsgText.include? "nusa tenggara timur") || (eventMsgText.include? "ntt")
                return reply_text(event, provinceReply(33))
            else
                return reply_text(event, "kami belum punya data provinsi yang kamu tuju")
            end
        elsif (eventMsgText.include? "global")
            if (eventMsgText.include? "positif")
                return reply_text(event, api_handler_global_confirm)
            elsif (eventMsgText.include? "sembuh")
                return reply_text(event, api_handler_global_recovered)
            elsif (eventMsgText.include? "meninggal")
                return reply_text(event, api_handler_global_deaths)
            else
                return reply_text(
                                event, 
                                    api_handler_global_confirm+ " \n" + 
                                    api_handler_global_recovered+ " \n" +
                                    api_handler_global_deaths+ " \n"
                                )
            end
        elsif (eventMsgText.include? "hi") || (eventMsgText.include? "hai")
            return reply_text(event, "Hai, juga zheyeng")
        elsif (eventMsgText.include? "hello")
            return reply_text(event, "Axe said, Good day Sir!")
        else
            return reply_text(event, "maaf sob, aku ga tau yang kalian tulis itu apa :(")
        end
    else
        logger.info "Unknown message type: #{event.type}"
        return reply_text(event, "Perintah: \n#{event.type} belum kami kenali. tunggu update selanjutnya ya :(")
    end 
end
def api_handler_global_res (res)
    jsonData = JSON.parse(res.body)
    data = "#{jsonData['name']} : #{jsonData['value']}"
    return data
end

def api_handler_global_recovered
    res = Net::HTTP.get_response(URI.parse("https://api.kawalcorona.com/sembuh/"))
    data = api_handler_global_res(res)
    return data
end

def api_handler_global_deaths
    res = Net::HTTP.get_response(URI.parse("https://api.kawalcorona.com/meninggal/"))
    data = api_handler_global_res(res)
    return data
end

def api_handler_global_confirm
    res = Net::HTTP.get_response(URI.parse("https://api.kawalcorona.com/positif/"))
    data = api_handler_global_res(res)
    return data
end


def api_handler
    res = Net::HTTP.get_response(URI.parse("https://api.kawalcorona.com/"))
    jsonData = JSON.parse(res.body)
    return jsonData
end

def api_handler_province
    res = Net::HTTP.get_response(URI.parse("https://api.kawalcorona.com/indonesia/provinsi/"))
    jsonData = JSON.parse(res.body)
    return jsonData
end

def provinceReply (index)
   apiHandlerIndex = api_handler_province[index]['attributes']
   data = "Provinsi #{apiHandlerIndex['Provinsi']}, \n" +
            "Data kasus positif: #{number_to_delimited(apiHandlerIndex['Kasus_Posi'])} \n" +
            "Data Kasus sembuh: #{number_to_delimited(apiHandlerIndex['Kasus_Semb'])} \n" +
            "Data kasus meninggal: #{number_to_delimited(apiHandlerIndex['Kasus_Meni'])} \n"
    return data
end

def countryReply (index)
    apiHandlerIndex = api_handler[index]['attributes']
    data = "Negara #{apiHandlerIndex['Country_Region']}, \n" +
            "Data orang terkonfirmasi: #{number_to_delimited(apiHandlerIndex['Confirmed'])} \n"+
            "Data orang meninggal: #{number_to_delimited(apiHandlerIndex['Deaths'])} \n"+ 
            "Data dinyatakan sembuh: #{number_to_delimited(apiHandlerIndex['Recovered'])} \n"+
            "Data pasien aktif: #{number_to_delimited(apiHandlerIndex['Active'])} \n"+ 
            "Update terakhir: #{Time.at(apiHandlerIndex["Last_Update"].to_s[0...-3].to_i).strftime("%d-%m-%Y (%T)")}"
    return data
end