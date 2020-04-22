
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

def api_handler_province
    res = Net::HTTP.get_response(URI.parse("https://api.kawalcorona.com/indonesia/provinsi/"))
    jsonData = JSON.parse(res.body)
    return jsonData
end
