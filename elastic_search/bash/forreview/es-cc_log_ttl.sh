curl -XPOST 10.250.132.130:9200/cc_log_user_interaction/cc_log_user_interaction/_mapping -d '
{
    cc_log_user_interaction: {
        _ttl : {
            enabled : true,
            default : "2w"
        },
        properties: {
            asset: {
                properties: {
                    id: {
                        type: "long"
                    },
                    type: {
                        type: "string"
                    }
                }
            },
            createdAt: {
                format: "dateOptionalTime",
                type: "date"
            },
            data: {
                properties: {
                    message: {
                        type: "string"
                    },
                    commands: {
                        properties: {
                            func: {
                                type: "string"
                            },
                            comment: {
                                type: "string"
                            }
                        }
                    },
                    comment: {
                        type: "string"
                    }
                }
            },
            action: {
                type: "string"
            },
            savedAt: {
                format: "dateOptionalTime",
                type: "date"
            },
            user: {
                type: "string"
            }
        }
    }
}
'
