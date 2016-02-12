curl -XPOST 10.250.132.130:9200/cc_asset/cc_asset/_mapping -d '
{
    cc_asset: {
        _ttl : {
            enabled : true,
            default : "30m"
        }
    }
}
'
