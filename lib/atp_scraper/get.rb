require 'open-uri'
require 'nokogiri'
module AtpScraper
  # ATPのサイトのhtmlを取得するクラス
  class Get
    def self.get_html(url)
      charset = nil
      html = open(url) do |f|
        charset = f.charset
        f.read
      end
      { html: html, charset: charset }
    end

    def self.parse_html(html, charset)
      Nokogiri::HTML.parse(html, nil, charset)
    end
  end
end
