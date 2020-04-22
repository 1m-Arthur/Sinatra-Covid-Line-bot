require 'sinatra'
require 'line/bot'
require 'net/http'
require 'json'
require 'active_support'
require 'date'
require 'openssl'

include ActiveSupport::NumberHelper
include ActiveSupport::Inflector

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
                return reply_text(event, countryReply(titleize("afghanistan")))
            elsif (eventMsgText.include? "albania")
                return reply_text(event, countryReply(titleize(eventMsgText)))
            elsif (eventMsgText.include? "algeria")
                return reply_text(event, countryReply(titleize(eventMsgText)))
            elsif (eventMsgText.include? "andorra")
                return reply_text(event, countryReply(titleize(eventMsgText)))
            elsif (eventMsgText.include? "angola")
                return reply_text(event, countryReply(titleize(eventMsgText)))
            elsif (eventMsgText.include? "anguilla")
                return reply_text(event, countryReply(titleize(eventMsgText)))
            elsif (eventMsgText.include? "antigua-and-barbuda")
                return reply_text(event, countryReply("Antigua-and-Barbuda"))
            elsif (eventMsgText.include? "argentina")
                return reply_text(event, countryReply(titleize(eventMsgText)))
            elsif (eventMsgText.include? "armenia")
                return reply_text(event, countryReply(titleize(eventMsgText)))
            elsif (eventMsgText.include? "aruba")
                return reply_text(event, countryReply(titleize(eventMsgText)))
            elsif (eventMsgText.include? "Australia")
                return reply_text(event, countryReply(titleize(eventMsgText)))
            elsif (eventMsgText.include? "Austria")
                return reply_text(event, countryReply(titleize(eventMsgText)))

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
            "Data meninggal: #{number_to_delimited(apiHandlerIndex['deaths']['total'])} #{+"("+apiHandlerIndex['deaths']['new']+")"+} \n"+ 
            "Data sembuh: #{number_to_delimited(apiHandlerIndexCase['recovered'])} \n"+
            "Update terakhir: #{apiHandlerIndex['day']}"
    return data
end