grepTrash() {
    grep -v '"_index"' | \
    grep -v '"_id"' | \
    grep -v '"_type"' | \
    grep -v '"_score"' | \
    grep -v '"sort"'
}

sedTrash() {
    sed -e 's/"asset":{"type":"article","id":3208169},//' | \
    sed -e 's/"user":"cms.danielle.gusmaroli",//' | \
    sed -e 's/"action":"transaction",//' | \
    sed -e 's/"createdAt":"2015-..-..T..:..:......Z",//'

}

curl -s -XPOST  10.250.132.130:9200/cc_log_user_interaction/_search?pretty -d '
{
    "query":{
        "bool":{
            "must":[
                    {
                        "term":{
                            "cc_log_user_interaction.user":"cms.danielle.gusmaroli"
                        }
                    },
                    {
                        "term":{
                        "cc_log_user_interaction.asset.id":"3208169"
                        }
                    },
                    {
                        "range":{
                        "cc_log_user_interaction.savedAt":{
                        "from":"2015-08-23T23:05:47.729Z",
                        "to":"2015-08-23T23:45:47.729Z"
                    }
                    }
                    }
                ],
            "must_not":[ ],
            "should":[ ]
        }
    },
    "from":0,
    "size":5000,
    "sort":[
        {
            "cc_log_user_interaction.savedAt":{ "order":"asc" }
        }
    ],
    "facets":{ }
}
' | grepTrash |sedTrash
