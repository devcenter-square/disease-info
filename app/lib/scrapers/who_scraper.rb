require 'open-uri'

module Scrapers::WhoScraper
  extend self

  WHO_DISEASE_PAGE = 'http://www.who.int/topics/infectious_diseases/factsheets/en/'
  CORE_ATTR = %w(symptoms transmission diagnosis treatment prevention)
  DATA_SOURCE = 'WHO'

  def get_data
    disease_list_pages = open_page(WHO_DISEASE_PAGE).css(".auto_archive>li>a")
    save_diseases(disease_list_pages)
  end

  private

  def open_page(page_url)
    Nokogiri::HTML(open(page_url, 'User-Agent' => 'ruby'))
  end

  def save_diseases(disease_list)
    disease_list.each do |link|
      begin
        disease_data = collect_data(link)
        Disease.create(disease_data)
      rescue
        next
      end
    end
  end

  def collect_data(disease_link)
    disease_page = open_page("http://www.who.int#{disease_link.attributes["href"].value}")
    disease_data = {
        name: disease_page.css('.headline').children.text.capitalize + ' - ' + DATA_SOURCE,
        date_updated: disease_page.css('.meta span').text.split.last(2).join(" "),
        facts: facts(disease_page),
        more: "Source is http://www.who.int#{disease_link.attributes["href"].value}"
    }

    disease_page.css('h3').each_with_index do |tag, index|
      CORE_ATTR.each do |attr|
        begin
          if tag.text.downcase.include?(attr)
            xpath_text = "//h3[text()=\'#{tag.text}\']/following::p[not(preceding::h3[text()=\'#{disease_page.css("h3")[index+1].text}\'])]".to_s
            attr_text =  disease_page.xpath(xpath_text).text
            disease_data[attr.to_sym] = attr_text
          end
        rescue
          next
        end
      end
    end
    disease_data
  end

  def facts(disease_page)
    disease_page.at('h3:contains("Key facts")').try(:next_element).try(:text)
  end
end
