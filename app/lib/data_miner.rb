require 'open-uri'

module DataMiner
  extend self

  WHO_DISEASE_PAGE = 'http://www.who.int/topics/infectious_diseases/factsheets/en/'

  def get_who_data
    disease_list_pages = open_list_page.css(".auto_archive>li>a")

    save_diseases(disease_list_pages)
  end

  def open_list_page
    Nokogiri::HTML(open(WHO_DISEASE_PAGE))
  end

  def save_diseases(disease_list)
    disease_list.each do |link|
      disease_data = collect_data(link)
      Disease.create(disease_data)
    end
  end

  def collect_data(disease_link)
    disease_page = Nokogiri::HTML(open("http://www.who.int#{disease_link.attributes["href"].value}"))
    {
        name: disease_page.css('.headline').children.text,
        date_updated: disease_page.css('.meta span').text.split.last(2).join(" "),
        facts: disease_page.at('h3:contains("Key facts")').next_element.text.split("\n  \t"),
        symptoms: disease_page.at('h3:contains("Symptoms")').present? ? disease_page.at('h3:contains("Symptoms")').next_element.text : "",
        transmission: disease_page.at('h3:contains("Transmission")').present? ? disease_page.at('h3:contains("Transmission")').next_element.text : "",
        diagnosis: disease_page.at('h3:contains("Diagnosis")').present? ? disease_page.at('h3:contains("Diagnosis")').next_element.text : "",
        treatment: disease_page.at('h3:contains("Treatment")').present? ? disease_page.at('h3:contains("Treatment")').next_element.text : "",
        prevention: disease_page.at('h3:contains("Prevention")').present? ? disease_page.at('h3:contains("Prevention")').next_element.text : "",
        more: "Source is http://www.who.int#{disease_link.attributes["href"].value}"
    }
  end
end
