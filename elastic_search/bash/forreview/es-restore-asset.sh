curl -s -XPOST  10.250.132.130:9200/cc_log_user_interaction/_search?pretty -d '
    "query":{
        "bool":{
            "must":[
                {
                    "term":{
                        "linklist.linkListId":"1000011"
                    }
                },
                {
                    "range":{
                        "linklist.modifiedDate":{
                            "from":"2015-09-03T15:53:03+0100",
                            "to":"2015-10-09T15:53:03+0100"
                        }
                    }
                }
            ],
            "must_not":[
            ],
            "should":[
            ]
        }
    },
    "from":0,
    "size":1,
    "sort":[
    ],
    "facets":{
    }
}
' > _asset.json
cat _asset.json
echo "continue? Yes/No: "
select yn in "Yes" "No"; do
    case $yn in
        Yes ) echo "aaaaaaaaaaaaaaaaaa"; break;;
        No ) echo "no changes"; exit;;
    esac
done

curl -s -XPOST http://and-hsk-molwpsint-vip.andintweb.dmgt.net/linklist-management/model/linklist -d `cat _asset.json`
