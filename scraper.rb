#!/bin/env ruby
# encoding: utf-8

require 'scraperwiki'
require 'wikidata/fetcher'
require 'nokogiri'
require 'colorize'
require 'pry'
require 'rest-client'
require 'open-uri/cached'
OpenURI::Cache.cache_path = '.cache'


def noko_for(url)
  Nokogiri::HTML(open(URI.escape(URI.unescape(url))).read) 
end

def wikinames_from(url)
  noko = noko_for(url)
  names = noko.xpath('//table[.//tr[th[.="Electoral district"]]]//tr[td]//td[2]//a[not(@class="new")]/@title').map(&:text) 
  abort "No names" if names.count.zero?
  names
end

def fetch_info(names)
  WikiData.ids_from_pages('en', names).each do |name, id|
    data = WikiData::Fetcher.new(id: id).data('en', 'fr') rescue nil
    unless data
      warn "No data for #{p}"
      next
    end
    data[:original_wikiname] = name
    ScraperWiki.save_sqlite([:id], data)
  end
end

names = wikinames_from('https://en.wikipedia.org/wiki/List_of_House_members_of_the_42nd_Parliament_of_Canada') +
  wikinames_from('https://en.wikipedia.org/wiki/List_of_House_members_of_the_41st_Parliament_of_Canada')

fetch_info names.uniq

warn RestClient.post ENV['MORPH_REBUILDER_URL'], {} if ENV['MORPH_REBUILDER_URL']

