max=20
indices=article\
,autosave\
,cc_log_user_interaction\
,channel\
,columnist\
,gallery\
,history-user\
,image_cropper-v1\
,image_source-v1\
,linklist\
,module\
,poll\
,standardmodule\
,styles\
,topics\
,video

# cleanup localhost
#curl -XDELETE 'http://localhost:9200/*'

# structure export from server
es-export-mappings --url http://10.251.64.50:9200 --file es.dump.json._mappings --index $indices;
es-export-settings --url http://10.251.64.50:9200 --file es.dump.json._settings --index $indices;
es-export-aliases  --url http://10.251.64.50:9200 --file es.dump.json._aliases  --index $indices;

es-import-mappings --url http://localhost:9200 --file es.dump.json._mappings




# data export from server
bulkExport="es-export-bulk --url http://10.251.64.50:9200 --sort _timestamp:desc"

# data import to local
bulkImport="es-import-bulk --url http://localhost:9200 "

$bulkExport --max $max --file es.dump.json.article          --index article-v5      ; $bulkImport --file es.dump.json.article
$bulkExport --max $max --file es.dump.json.channel          --index channel         ; $bulkImport --file es.dump.json.channel
$bulkExport --max $max --file es.dump.json.columnist        --index columnist       ; $bulkImport --file es.dump.json.columnist
$bulkExport --max $max --file es.dump.json.gallery          --index gallery         ; $bulkImport --file es.dump.json.gallery
$bulkExport --max $max --file es.dump.json.image_cropper    --index image_cropper-v1; $bulkImport --file es.dump.json.image_cropper
$bulkExport --max $max --file es.dump.json.image_source     --index image_source-v1 ; $bulkImport --file es.dump.json.image_source
$bulkExport --max $max --file es.dump.json.linklist         --index linklist        ; $bulkImport --file es.dump.json.linklist
$bulkExport --max $max --file es.dump.json.module           --index module          ; $bulkImport --file es.dump.json.module
$bulkExport --max $max --file es.dump.json.poll             --index poll            ; $bulkImport --file es.dump.json.poll
$bulkExport --max $max --file es.dump.json.standardmodule   --index standardmodule  ; $bulkImport --file es.dump.json.standardmodule
$bulkExport --max $max --file es.dump.json.styles           --index styles          ; $bulkImport --file es.dump.json.styles
$bulkExport --max $max --file es.dump.json.topics           --index topics          ; $bulkExport --file es.dump.json.topics
$bulkExport --max $max --file es.dump.json.video            --index video           ; $bulkImport --file es.dump.json.video

es-import-aliases  --url http://localhost:9200 --file es.dump.json._aliases
#sleep 4
#curl -XPOST 'localhost:9200/article-v5/_close'
#sleep 4
es-import-settings --url http://localhost:9200 --file es.dump.json._settings
#sleep 4
#curl -XPOST 'localhost:9200/article-v5/_open'



#curl -s -XPOST  10.251.64.50:9200/article-v5/_search?pretty -d '
#{
#  "query": {
#    "match_all": {}
#  },
#  "size": 250,
#  "sort": [
#    {
#        "_timestamp": {
#            "order": "desc"
#        }
#    }
#  ]
#}
#' > article-v5.json
