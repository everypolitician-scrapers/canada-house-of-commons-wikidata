#!/bin/env ruby
# encoding: utf-8

require 'wikidata/fetcher'
require 'pry'


parl42 = EveryPolitician::Wikidata.wikipedia_xpath( 
  url: 'https://en.wikipedia.org/wiki/List_of_House_members_of_the_42nd_Parliament_of_Canada',
  xpath: '//table[.//tr[th[.="Electoral district"]]]//tr[td]//td[2]//a[not(@class="new")]/@title',
) 

parl41 = EveryPolitician::Wikidata.wikipedia_xpath( 
  url: 'https://en.wikipedia.org/wiki/List_of_House_members_of_the_41st_Parliament_of_Canada',
  xpath: '//table[.//tr[th[.="Electoral district"]]]//tr[td]//td[2]//a[not(@class="new")]/@title',
) 

names = (parl41 + parl42).uniq
EveryPolitician::Wikidata.scrape_wikidata(names: { en: names })
warn EveryPolitician::Wikidata.notify_rebuilder

