#!/bin/env ruby
# encoding: utf-8

require 'wikidata/fetcher'
require 'pry'

parl42 = EveryPolitician::Wikidata.wikipedia_xpath(
  url: 'https://en.wikipedia.org/wiki/List_of_House_members_of_the_42nd_Parliament_of_Canada',
  xpath: '//table[.//tr[th[contains(.,"Electoral district")]]]//tr[td]//td[2]//a[not(@class="new")]/@title',
)

parl41 = EveryPolitician::Wikidata.wikipedia_xpath(
  url: 'https://en.wikipedia.org/wiki/List_of_House_members_of_the_41st_Parliament_of_Canada',
  xpath: '//table[.//tr[th[contains(.,"Electoral district")]]]//tr[td]//td[2]//a[not(@class="new")]/@title',
)

# Find all members of (terms that started after 2011)
query = <<EOS
  SELECT DISTINCT ?item
  WHERE
  {
    ?item p:P39 ?st .
    ?st ps:P39 wd:Q15964890 ; pq:P2937 ?term .
    ?term wdt:P571|wdt:P580 ?start
    FILTER (?start >= "2011-01-01T00:00:00Z"^^xsd:dateTime) .
  }
EOS
p39s = EveryPolitician::Wikidata.sparql(query)

EveryPolitician::Wikidata.scrape_wikidata(ids: p39s, names: { en: parl41 | parl42 })

