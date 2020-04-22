require 'sinatra'
require 'line/bot'
require 'net/http'
require 'json'
require 'active_support'
require 'date'
require 'openssl'

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
                countryCounter = 0
                lastDataCountry = api_handler_countrylist.count - 120
                api_handler_countrylist.each do |item|
                    countryCounter += 1
                    countries.concat([countryCounter.to_s+". "+item])
                end
                reply_text(event,[
                    "Berikut adalah daftar-daftar negara yang kami ketahui: \n"+countries.first(120).join("\n"), 
                    "#{countries.last(lastDataCountry).join("\n")}"
                    ])
            elsif (eventMsgText.include? "afghanistan")
                return reply_text(event, countryReply("Afghanistan"))
            elsif (eventMsgText.include? "albania")
                return reply_text(event, countryReply("Albania"))
            elsif (eventMsgText.include? "algeria")
                return reply_text(event, countryReply("Algeria"))
            elsif (eventMsgText.include? "andorra")
                return reply_text(event, countryReply("Andorra"))
            elsif (eventMsgText.include? "angola")
                return reply_text(event, countryReply("Angola"))
            elsif (eventMsgText.include? "anguilla")
                return reply_text(event, countryReply("Anguilla"))
            elsif (eventMsgText.include? "antigua-and-barbuda")
                return reply_text(event, countryReply("Antigua-and-Barbuda"))
            elsif (eventMsgText.include? "argentina")
                return reply_text(event, countryReply("Argentina"))
            elsif (eventMsgText.include? "armenia")
                return reply_text(event, countryReply("Armenia"))
            elsif (eventMsgText.include? "aruba")
                return reply_text(event, countryReply("Aruba"))
            elsif (eventMsgText.include? "australia")
                return reply_text(event, countryReply("Australia"))
            elsif (eventMsgText.include? "austria")
                return reply_text(event, countryReply("Austria"))
            elsif (eventMsgText.include? "azerbaijan")
                return reply_text(event, countryReply("Azerbaijan"))
            elsif (eventMsgText.include? "bahamas")
                return reply_text(event, countryReply("Bahamas"))
            elsif (eventMsgText.include? "bahrain")
                return reply_text(event, countryReply("Bahrain"))
            elsif (eventMsgText.include? "bangladesh")
                return reply_text(event, countryReply("Bangladesh"))
            elsif (eventMsgText.include? "barbados")
                return reply_text(event, countryReply("Barbados"))
            elsif (eventMsgText.include? "belarus")
                return reply_text(event, countryReply("Belarus"))
            elsif (eventMsgText.include? "belgium")
                return reply_text(event, countryReply("Belgium"))
            elsif (eventMsgText.include? "belize")
                return reply_text(event, countryReply("Belize"))
            elsif (eventMsgText.include? "benin")
                return reply_text(event, countryReply("Benin"))
            elsif (eventMsgText.include? "bermuda")
                return reply_text(event, countryReply("Bermuda"))
            elsif (eventMsgText.include? "bhutan")
                return reply_text(event, countryReply("Bhutan"))
            elsif (eventMsgText.include? "bolivia")
                return reply_text(event, countryReply("Bolivia"))
            elsif (eventMsgText.include? "bosnia-and-herzegovina")
                return reply_text(event, countryReply("Bosnia-and-Herzegovina"))
            elsif (eventMsgText.include? "botswana")
                return reply_text(event, countryReply("Botswana"))
            elsif (eventMsgText.include? "brazil")
                return reply_text(event, countryReply("Brazil"))
            elsif (eventMsgText.include? "british-virgin-islands")
                return reply_text(event, countryReply("British-Virgin-Islands"))
            elsif (eventMsgText.include? "brunei")
                return reply_text(event, countryReply("Brunei"))
            elsif (eventMsgText.include? "bulgaria")
                return reply_text(event, countryReply("Bulgaria"))
            elsif (eventMsgText.include? "burkina-faso")
                return reply_text(event, countryReply("Burkina-Faso"))
            elsif (eventMsgText.include? "burundi")
                return reply_text(event, countryReply("Burundi"))
            elsif (eventMsgText.include? "cabo-verde")
                return reply_text(event, countryReply("Cabo-Verde"))
            elsif (eventMsgText.include? "cambodia")
                return reply_text(event, countryReply("Cambodia"))
            elsif (eventMsgText.include? "cameroon")
                return reply_text(event, countryReply("Cameroon"))
            elsif (eventMsgText.include? "canada")
                return reply_text(event, countryReply("Canada"))
            elsif (eventMsgText.include? "car")
                return reply_text(event, countryReply("CAR"))
            elsif (eventMsgText.include? "caribbean-netherlands")
                return reply_text(event, countryReply("Caribbean-Netherlands"))
            elsif (eventMsgText.include? "cayman-islands")
                return reply_text(event, countryReply("Cayman-Islands"))
            elsif (eventMsgText.include? "chad")
                return reply_text(event, countryReply("Chad"))
            elsif (eventMsgText.include? "channel-islands")
                return reply_text(event, countryReply("Channel-Islands"))
            elsif (eventMsgText.include? "chile")
                return reply_text(event, countryReply("Chile"))
            elsif (eventMsgText.include? "china")
                return reply_text(event, countryReply("China"))
            elsif (eventMsgText.include? "colombia")
                return reply_text(event, countryReply("Colombia"))
            elsif (eventMsgText.include? "congo")
                return reply_text(event, countryReply("Congo"))
            elsif (eventMsgText.include? "costa-rica")
                return reply_text(event, countryReply("Costa-Rica"))
            elsif (eventMsgText.include? "croatia")
                return reply_text(event, countryReply("Croatia"))
            elsif (eventMsgText.include? "cuba")
                return reply_text(event, countryReply("Cuba"))
            elsif (eventMsgText.include? "curaçao") || (eventMsgText.include? "curacao")
                return reply_text(event, countryReply("Cura&ccedil;ao"))
            elsif (eventMsgText.include? "cyprus")
                return reply_text(event, countryReply("Cyprus"))
            elsif (eventMsgText.include? "czechia")
                return reply_text(event, countryReply("Czechia"))
            elsif (eventMsgText.include? "denmark")
                return reply_text(event, countryReply("Denmark"))
            elsif (eventMsgText.include? "diamond-princess")
                return reply_text(event, countryReply("Diamond-Princess"))
            elsif (eventMsgText.include? "diamond-princess-")
                return reply_text(event, countryReply("Diamond-Princess-"))
            elsif (eventMsgText.include? "djibouti")
                return reply_text(event, countryReply("Djibouti"))
            elsif (eventMsgText.include? "dominica")
                return reply_text(event, countryReply("Dominica"))
            elsif (eventMsgText.include? "dominican-republic")
                return reply_text(event, countryReply("Dominican-Republic"))
            elsif (eventMsgText.include? "drc")
                return reply_text(event, countryReply("DRC"))
            elsif (eventMsgText.include? "ecuador")
                return reply_text(event, countryReply("Ecuador"))
            elsif (eventMsgText.include? "egypt")
                return reply_text(event, countryReply("Egypt"))
            elsif (eventMsgText.include? "el-salvador")
                return reply_text(event, countryReply("El-Salvador"))
            elsif (eventMsgText.include? "equatorial-guinea")
                return reply_text(event, countryReply("Equatorial-Guinea"))
            elsif (eventMsgText.include? "eritrea")
                return reply_text(event, countryReply("Eritrea"))
            elsif (eventMsgText.include? "estonia")
                return reply_text(event, countryReply("Estonia"))
            elsif (eventMsgText.include? "eswatini")
                return reply_text(event, countryReply("Eswatini"))
            elsif (eventMsgText.include? "ethiopia")
                return reply_text(event, countryReply("Ethiopia"))
            elsif (eventMsgText.include? "faeroe-islands")
                return reply_text(event, countryReply("Faeroe-Islands"))
            elsif (eventMsgText.include? "falkland-islands")
                return reply_text(event, countryReply("Falkland-Islands"))
            elsif (eventMsgText.include? "fiji")
                return reply_text(event, countryReply("Fiji"))
            elsif (eventMsgText.include? "finland")
                return reply_text(event, countryReply("Finland"))
            elsif (eventMsgText.include? "france")
                return reply_text(event, countryReply("France"))
            elsif (eventMsgText.include? "french-guiana")
                return reply_text(event, countryReply("French-Guiana"))
            elsif (eventMsgText.include? "french-polynesia")
                return reply_text(event, countryReply("French-Polynesia"))
            elsif (eventMsgText.include? "gabon")
                return reply_text(event, countryReply("Gabon"))
            elsif (eventMsgText.include? "gambia")
                return reply_text(event, countryReply("Gambia"))
            elsif (eventMsgText.include? "georgia")
                return reply_text(event, countryReply("Georgia"))
            elsif (eventMsgText.include? "germany")
                return reply_text(event, countryReply("Germany"))
            elsif (eventMsgText.include? "ghana")
                return reply_text(event, countryReply("Ghana"))
            elsif (eventMsgText.include? "gibraltar")
                return reply_text(event, countryReply("Gibraltar"))
            elsif (eventMsgText.include? "greece")
                return reply_text(event, countryReply("Greece"))
            elsif (eventMsgText.include? "greenland")
                return reply_text(event, countryReply("Greenland"))
            elsif (eventMsgText.include? "grenada")
                return reply_text(event, countryReply("Grenada"))
            elsif (eventMsgText.include? "guadeloupe")
                return reply_text(event, countryReply("Guadeloupe"))
            elsif (eventMsgText.include? "guam")
                return reply_text(event, countryReply("Guam"))
            elsif (eventMsgText.include? "guatemala")
                return reply_text(event, countryReply("Guatemala"))
            elsif (eventMsgText.include? "guinea")
                return reply_text(event, countryReply("Guinea"))
            elsif (eventMsgText.include? "guinea-bissau")
                return reply_text(event, countryReply("Guinea-Bissau"))
            elsif (eventMsgText.include? "guyana")
                return reply_text(event, countryReply("Guyana"))
            elsif (eventMsgText.include? "haiti")
                return reply_text(event, countryReply("Haiti"))
            elsif (eventMsgText.include? "honduras")
                return reply_text(event, countryReply("Honduras"))
            elsif (eventMsgText.include? "hong-kong")
                return reply_text(event, countryReply("Hong-Kong"))
            elsif (eventMsgText.include? "hungary")
                return reply_text(event, countryReply("Hungary"))
            elsif (eventMsgText.include? "iceland")
                return reply_text(event, countryReply("Iceland"))
            elsif (eventMsgText.include? "india")
                return reply_text(event, countryReply("India"))
            elsif (eventMsgText.include? "indonesia")
                return reply_text(event, countryReply("Indonesia"))
            elsif (eventMsgText.include? "iran")
                return reply_text(event, countryReply("Iran"))
            elsif (eventMsgText.include? "iraq")
                return reply_text(event, countryReply("Iraq"))
            elsif (eventMsgText.include? "ireland")
                return reply_text(event, countryReply("Ireland"))
            elsif (eventMsgText.include? "isle-of-man")
                return reply_text(event, countryReply("Isle-of-Man"))
            elsif (eventMsgText.include? "israel")
                return reply_text(event, countryReply("Israel"))
            elsif (eventMsgText.include? "italy")
                return reply_text(event, countryReply("Italy"))
            elsif (eventMsgText.include? "ivory-coast")
                return reply_text(event, countryReply("Ivory-Coast"))
            elsif (eventMsgText.include? "jamaica")
                return reply_text(event, countryReply("Jamaica"))
            elsif (eventMsgText.include? "japan")
                return reply_text(event, countryReply("Japan"))
            elsif (eventMsgText.include? "jordan")
                return reply_text(event, countryReply("Jordan"))
            elsif (eventMsgText.include? "kazakhstan")
                return reply_text(event, countryReply("Kazakhstan"))
            elsif (eventMsgText.include? "kenya")
                return reply_text(event, countryReply("Kenya"))
            elsif (eventMsgText.include? "kuwait")
                return reply_text(event, countryReply("Kuwait"))
            elsif (eventMsgText.include? "kyrgyzstan")
                return reply_text(event, countryReply("Kyrgyzstan"))
            elsif (eventMsgText.include? "laos")
                return reply_text(event, countryReply("Laos"))
            elsif (eventMsgText.include? "latvia")
                return reply_text(event, countryReply("Latvia"))
            elsif (eventMsgText.include? "lebanon")
                return reply_text(event, countryReply("Lebanon"))
            elsif (eventMsgText.include? "liberia")
                return reply_text(event, countryReply("Liberia"))
            elsif (eventMsgText.include? "libya")
                return reply_text(event, countryReply("Libya"))
            elsif (eventMsgText.include? "liechtenstein")
                return reply_text(event, countryReply("Liechtenstein"))
            elsif (eventMsgText.include? "lithuania")
                return reply_text(event, countryReply("Lithuania"))
            elsif (eventMsgText.include? "luxembourg")
                return reply_text(event, countryReply("Luxembourg"))
            elsif (eventMsgText.include? "macao")
                return reply_text(event, countryReply("Macao"))
            elsif (eventMsgText.include? "madagascar")
                return reply_text(event, countryReply("Madagascar"))
            elsif (eventMsgText.include? "malawi")
                return reply_text(event, countryReply("Malawi"))
            elsif (eventMsgText.include? "malaysia")
                return reply_text(event, countryReply("Malaysia"))
            elsif (eventMsgText.include? "maldives")
                return reply_text(event, countryReply("Maldives"))
            elsif (eventMsgText.include? "mali")
                return reply_text(event, countryReply("Mali"))
            elsif (eventMsgText.include? "malta")
                return reply_text(event, countryReply("Malta"))
            elsif (eventMsgText.include? "martinique")
                return reply_text(event, countryReply("Martinique"))
            elsif (eventMsgText.include? "mauritania")
                return reply_text(event, countryReply("Mauritania"))
            elsif (eventMsgText.include? "mauritius")
                return reply_text(event, countryReply("Mauritius"))
            elsif (eventMsgText.include? "mayotte")
                return reply_text(event, countryReply("Mayotte"))
            elsif (eventMsgText.include? "mexico")
                return reply_text(event, countryReply("Mexico"))
            elsif (eventMsgText.include? "moldova")
                return reply_text(event, countryReply("Moldova"))
            elsif (eventMsgText.include? "monaco")
                return reply_text(event, countryReply("Monaco"))
            elsif (eventMsgText.include? "mongolia")
                return reply_text(event, countryReply("Mongolia"))
            elsif (eventMsgText.include? "montenegro")
                return reply_text(event, countryReply("Montenegro"))
            elsif (eventMsgText.include? "montserrat")
                return reply_text(event, countryReply("Montserrat"))
            elsif (eventMsgText.include? "morocco")
                return reply_text(event, countryReply("Morocco"))
            elsif (eventMsgText.include? "mozambique")
                return reply_text(event, countryReply("Mozambique"))
            elsif (eventMsgText.include? "ms-zaandam")
                return reply_text(event, countryReply("Ms-Zaandam"))
            elsif (eventMsgText.include? "ms-zaandam-")
                return reply_text(event, countryReply("Ms-Zaandam-"))
            elsif (eventMsgText.include? "myanmar")
                return reply_text(event, countryReply("Myanmar"))
            elsif (eventMsgText.include? "namibia")
                return reply_text(event, countryReply("Namibia"))
            elsif (eventMsgText.include? "nepal")
                return reply_text(event, countryReply("Nepal"))
            elsif (eventMsgText.include? "netherlands")
                return reply_text(event, countryReply("Netherlands"))
            elsif (eventMsgText.include? "new-caledonia")
                return reply_text(event, countryReply("New-Caledonia"))
            elsif (eventMsgText.include? "new-zealand")
                return reply_text(event, countryReply("New-Zealand"))
            elsif (eventMsgText.include? "nicaragua")
                return reply_text(event, countryReply("Nicaragua"))
            elsif (eventMsgText.include? "niger")
                return reply_text(event, countryReply("Niger"))
            elsif (eventMsgText.include? "nigeria")
                return reply_text(event, countryReply("Nigeria"))
            elsif (eventMsgText.include? "north-macedonia")
                return reply_text(event, countryReply("North-Macedonia"))
            elsif (eventMsgText.include? "norway")
                return reply_text(event, countryReply("Norway"))
            elsif (eventMsgText.include? "oman")
                return reply_text(event, countryReply("Oman"))
            elsif (eventMsgText.include? "pakistan")
                return reply_text(event, countryReply("Pakistan"))
            elsif (eventMsgText.include? "palestine")
                return reply_text(event, countryReply("Palestine"))
            elsif (eventMsgText.include? "panama")
                return reply_text(event, countryReply("Panama"))
            elsif (eventMsgText.include? "papua-new-guinea")
                return reply_text(event, countryReply("Papua-New-Guinea"))
            elsif (eventMsgText.include? "paraguay")
                return reply_text(event, countryReply("Paraguay"))
            elsif (eventMsgText.include? "peru")
                return reply_text(event, countryReply("Peru"))
            elsif (eventMsgText.include? "philippines")
                return reply_text(event, countryReply("Philippines"))
            elsif (eventMsgText.include? "poland")
                return reply_text(event, countryReply("Poland"))
            elsif (eventMsgText.include? "portugal")
                return reply_text(event, countryReply("Portugal"))
            elsif (eventMsgText.include? "puerto-rico")
                return reply_text(event, countryReply("Puerto-Rico"))
            elsif (eventMsgText.include? "qatar")
                return reply_text(event, countryReply("Qatar"))
            elsif (eventMsgText.include? "réunion") || (eventMsgText.include? "reunion")
                return reply_text(event, countryReply("R&eacute;union"))
            elsif (eventMsgText.include? "romania")
                return reply_text(event, countryReply("Romania"))
            elsif (eventMsgText.include? "russia")
                return reply_text(event, countryReply("Russia"))
            elsif (eventMsgText.include? "rwanda")
                return reply_text(event, countryReply("Rwanda"))
            elsif (eventMsgText.include? "s-korea") || (eventMsgText.include? "south korea")
                return reply_text(event, countryReply("S-Korea"))
            elsif (eventMsgText.include? "saint-kitts-and-nevis")
                return reply_text(event, countryReply("Saint-Kitts-and-Nevis"))
            elsif (eventMsgText.include? "saint-lucia")
                return reply_text(event, countryReply("Saint-Lucia"))
            elsif (eventMsgText.include? "saint-martin")
                return reply_text(event, countryReply("Saint-Martin"))
            elsif (eventMsgText.include? "saint-pierre-miquelon")
                return reply_text(event, countryReply("Saint-Pierre-Miquelon"))
            elsif (eventMsgText.include? "san-marino")
                return reply_text(event, countryReply("San-Marino"))
            elsif (eventMsgText.include? "sao-tome-and-principe")
                return reply_text(event, countryReply("Sao-Tome-and-Principe"))
            elsif (eventMsgText.include? "saudi-arabia")
                return reply_text(event, countryReply("Saudi-Arabia"))
            elsif (eventMsgText.include? "senegal")
                return reply_text(event, countryReply("Senegal"))
            elsif (eventMsgText.include? "serbia")
                return reply_text(event, countryReply("Serbia"))
            elsif (eventMsgText.include? "seychelles")
                return reply_text(event, countryReply("Seychelles"))
            elsif (eventMsgText.include? "sierra-leone")
                return reply_text(event, countryReply("Sierra-Leone"))
            elsif (eventMsgText.include? "singapore")
                return reply_text(event, countryReply("Singapore"))
            elsif (eventMsgText.include? "sint-maarten")
                return reply_text(event, countryReply("Sint-Maarten"))
            elsif (eventMsgText.include? "slovakia")
                return reply_text(event, countryReply("Slovakia"))
            elsif (eventMsgText.include? "slovenia")
                return reply_text(event, countryReply("Slovenia"))
            elsif (eventMsgText.include? "somalia")
                return reply_text(event, countryReply("Somalia"))
            elsif (eventMsgText.include? "south-africa") || (eventMsgText.include? "south africa")
                return reply_text(event, countryReply("South-Africa"))
            elsif (eventMsgText.include? "south-sudan")
                return reply_text(event, countryReply("South-Sudan"))
            elsif (eventMsgText.include? "spain")
                return reply_text(event, countryReply("Spain"))
            elsif (eventMsgText.include? "sri-lanka")
                return reply_text(event, countryReply("Sri-Lanka"))
            elsif (eventMsgText.include? "st-barth")
                return reply_text(event, countryReply("St-Barth"))
            elsif (eventMsgText.include? "st-vincent-grenadines")
                return reply_text(event, countryReply("St-Vincent-Grenadines"))
            elsif (eventMsgText.include? "sudan")
                return reply_text(event, countryReply("Sudan"))
            elsif (eventMsgText.include? "suriname")
                return reply_text(event, countryReply("Suriname"))
            elsif (eventMsgText.include? "sweden")
                return reply_text(event, countryReply("Sweden"))
            elsif (eventMsgText.include? "switzerland")
                return reply_text(event, countryReply("Switzerland"))
            elsif (eventMsgText.include? "syria")
                return reply_text(event, countryReply("Syria"))
            elsif (eventMsgText.include? "taiwan")
                return reply_text(event, countryReply("Taiwan"))
            elsif (eventMsgText.include? "tanzania")
                return reply_text(event, countryReply("Tanzania"))
            elsif (eventMsgText.include? "thailand")
                return reply_text(event, countryReply("Thailand"))
            elsif (eventMsgText.include? "timor-leste")
                return reply_text(event, countryReply("Timor-Leste"))
            elsif (eventMsgText.include? "togo")
                return reply_text(event, countryReply("Togo"))
            elsif (eventMsgText.include? "trinidad-and-tobago")
                return reply_text(event, countryReply("Trinidad-and-Tobago"))
            elsif (eventMsgText.include? "tunisia")
                return reply_text(event, countryReply("Tunisia"))
            elsif (eventMsgText.include? "turkey")
                return reply_text(event, countryReply("Turkey"))
            elsif (eventMsgText.include? "turks-and-caicos")
                return reply_text(event, countryReply("Turks And Caicos"))
            elsif (eventMsgText.include? "uae")
                return reply_text(event, countryReply("UAE"))
            elsif (eventMsgText.include? "uganda")
                return reply_text(event, countryReply("Uganda"))
            elsif (eventMsgText.include? "uk")
                return reply_text(event, countryReply("UK"))
            elsif (eventMsgText.include? "ukraine")
                return reply_text(event, countryReply("Ukraine"))
            elsif (eventMsgText.include? "uruguay")
                return reply_text(event, countryReply("Uruguay"))
            elsif (eventMsgText.include? "us-virgin-islands")
                return reply_text(event, countryReply("US-Virgin-Islands"))
            elsif (eventMsgText.include? "usa")
                return reply_text(event, countryReply("USA"))
            elsif (eventMsgText.include? "uzbekistan")
                return reply_text(event, countryReply("Uzbekistan"))
            elsif (eventMsgText.include? "vatican-city")
                return reply_text(event, countryReply("Vatican-City"))
            elsif (eventMsgText.include? "venezuela")
                return reply_text(event, countryReply("Venezuela"))
            elsif (eventMsgText.include? "vietnam")
                return reply_text(event, countryReply("Vietnam"))
            elsif (eventMsgText.include? "western-sahara")
                return reply_text(event, countryReply("Western-Sahara"))
            elsif (eventMsgText.include? "yemen")
                return reply_text(event, countryReply("Yemen"))
            elsif (eventMsgText.include? "zambia")
                return reply_text(event, countryReply("Zambia"))
            elsif (eventMsgText.include? "zimbabwe")
                return reply_text(event, countryReply("Zimbabwe"))
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

def api_handler_countrylist
    url = URI("https://covid-193.p.rapidapi.com/countries")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(url)
    request["x-rapidapi-host"] = 'covid-193.p.rapidapi.com'
    request["x-rapidapi-key"] = ENV['X_RAPIDAPI_KEY']

    response = http.request(request)
    jsonData = JSON.parse(response.read_body)
    return jsonData['response']
end

def api_handle_singlecountry (country)
    url = URI("https://covid-193.p.rapidapi.com/statistics?country="+country.to_s)

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(url)
    request["x-rapidapi-host"] = 'covid-193.p.rapidapi.com'
    request["x-rapidapi-key"] = ENV['X_RAPIDAPI_KEY']

    response = http.request(request)
    jsonData = JSON.parse(response.read_body)
    return jsonData['response'][0]
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

def countryReply(country)
    apiHandlerIndex = api_handle_singlecountry(country)
    apiHandlerIndexCase = apiHandlerIndex['cases']
    data = "Negara #{apiHandlerIndex['country']}, \n" +
            "Total terkonfirmasi: #{number_to_delimited(apiHandlerIndexCase['total'])} \n"+
            "Data pasien aktif: #{number_to_delimited(apiHandlerIndexCase['active'])} (#{apiHandlerIndexCase['new']})\n"+ 
            "Data pasien kritis: #{number_to_delimited(apiHandlerIndexCase['critical'])} \n"+
            "Data meninggal: #{number_to_delimited(apiHandlerIndex['deaths']['total'])} #{apiHandlerIndex['deaths']['new'] != nil ? "("+apiHandlerIndex['deaths']['new']+")" : ""} \n"+ 
            "Data sembuh: #{number_to_delimited(apiHandlerIndexCase['recovered'])} \n"+
            "Update terakhir: #{apiHandlerIndex['day']}"
    return data
end