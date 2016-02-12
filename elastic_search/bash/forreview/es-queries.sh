# http://asquera.de/blog/2014-06-02/elasticsearch-script-filters/
# http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/_executing_aggregations.html
curl -s -XPOST  10.251.64.50:9200/image_cropper/_search?pretty -d '
{
    "query": {
        "filtered": {
            "filter": {
                "script": {
                    "script": "doc[\"name_not_analyzed\"].value != null && doc[\"name_not_analyzed\"].value.matches(\"(?i:^par.*$)\")"
                }
            }
        }
    },
    "aggs" : {
        "distinct_names" : {
            "filter": {
                "script": {
                    "script": "doc[\"name_not_analyzed\"].value != null && doc[\"name_not_analyzed\"].value.matches(\"(?i:^par.*$)\")"
                }
            },
            "aggs": {
                "by_name": {
                    "terms": {
                        "size": 20,
                        "field": "name_not_analyzed",
                        "order" : {
                            "_term": "asc"
                        }
                    },
                    "aggs": {
                        "min_id": {
                            "min": {
                                "field": "id"
                            }
                        }
                    }
                }
            }
        }
    }
}
'| jq ''
exit 0
#######################
curl -s -XPOST  10.251.64.50:9200/image_cropper/_search -d '
{
    "query": {
        "filtered": {
            "filter": {
                "script": {
                    "script": "doc[\"name_not_analyzed\"].value != null && doc[\"name_not_analyzed\"].value.matches(\"(?i:^paramount.*$)\")"
                }
            }
        }
    },
    "aggs" : {
        "distinct_names" : {
            "filter": {
                "script": {
                    "script": "doc[\"name_not_analyzed\"].value != null && doc[\"name_not_analyzed\"].value.matches(\"(?i:^paramount.*$)\")"
                }
            },
            "aggs": {
                "by_name": {
                    "terms": {
                        "field": "name_not_analyzed"
                    },
                    "aggs": {
                        "min_id": {
                            "min": {
                                "field": "id"
                            }
                        }
                    }
                }
            }
        }
    }
}
'| jq ''
exit 0
#######################
curl -s -XPOST  10.251.64.50:9200/image_cropper/_search -d '
{
  "size": 20,
  "filter": {
    "script": {
      "script": "doc[\"name\"].value != null && doc[\"name\"].value.matches(\"(?i:^paramount.*$)\")"
    }
  },
  "aggs": {
    "distinct_name": {
      "terms": {
        "field": "name",
        "size": 20
      },
      "aggs": {
        "by_name": {
          "terms": {
            "field": "name",
            "size": 20
          }
        }
      }
    }
  }
}
'| jq ''
exit 0
#######################
curl -s -XPOST  10.251.64.50:9200/image_cropper/_search -d '
{
    "size": 20,
    "filter": {
        "script": {
            "script": "doc[\"name\"].value != null && doc[\"name\"].value.matches(\"(?i:^paramount.*$)\")"
        }
    },
    "aggs": {
        "top-tags": {
            "terms": {
                "field": "tags",
                "size": 3
            },
            "aggs": {
                "top_tag_hits": {
                    "top_hits": {
                        "sort": [
                            {
                                "name": {
                                    "order": "desc"
                                }
                            }
                        ],
                        "_source": {
                            "include": [
                                "name"
                            ]
                        },
                        "size" : 1
                    }
                }
            }
        }
    }
}
'| jq ''
exit 0
#######################
,
  "aggs": {
    "top-sites": {
      "terms": {
        "field": "domain",
        "order": {
          "top_hit": "desc"
        }
      },
      "aggs": {
        "top_tags_hits": {
          "top_hits": {}
        },
        "top_hit": {
          "max": {
            "script": "_score"
          }
        }
      }
    }
  }

exit 0
#######################
#http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/search-aggregations-metrics-top-hits-aggregation.html
curl -s -XPOST  10.251.64.50:9200/image_cropper/_search -d '
{
  "size": 20,
  "filter": {
    "script": {
      "script": "doc['name'].value != null && doc['name'].value.matches('(?i:^paramount.*$)')"
    }
  },
    "aggs": {
        "top-tags": {
            "terms": {
                "field": "tags",
                "size": 3
            },
            "aggs": {
                "top_tag_hits": {
                    "top_hits": {
                        "sort": [
                            {
                                "name": {
                                    "order": "desc"
                                }
                            }
                        ],
                        "_source": {
                            "include": [
                                "name"
                            ]
                        },
                        "size" : 1
                    }
                }
            }
        }
    }
}
'| jq '.hits.hits'
