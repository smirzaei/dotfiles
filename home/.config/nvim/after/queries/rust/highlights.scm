;; extends

((call_expression
   function: (field_expression
     field: (field_identifier) @custom.method.warn))
 (#any-of? @custom.method.warn "unwrap" "expect")
 (#set! "priority" 130))
