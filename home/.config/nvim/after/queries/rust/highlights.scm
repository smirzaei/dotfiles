;; extends

((call_expression
   function: (field_expression
     field: (field_identifier) @custom.method.warn))
 (#any-of? @custom.method.warn "unwrap" "expect")
 (#set! "priority" 130))

((call_expression
   function: (field_expression
     field: (field_identifier) @custom.method.alloc))
 (#any-of? @custom.method.alloc
    "clone"
    "to_string"
    "to_owned"
    "into_owned"
    "to_vec"
    "into_vec"
    "to_path_buf"
    "to_os_string"
    "to_boxed_slice"
    "into_boxed_slice"
    "to_ascii_lowercase"
    "to_ascii_uppercase"
    "collect"
    "concat"
    "join"
    "repeat"
    "replace"
   "replacen")
 (#set! "priority" 130))

((call_expression
   function: (scoped_identifier
     name: (identifier) @custom.method.alloc))
 (#any-of? @custom.method.alloc
   "clone"
   "to_string"
    "to_owned"
    "into_owned"
    "to_vec"
    "into_vec"
    "to_path_buf"
    "to_os_string"
    "to_boxed_slice"
    "into_boxed_slice"
    "to_ascii_lowercase"
    "to_ascii_uppercase"
    "collect"
    "concat"
    "join"
    "repeat"
    "replace"
    "replacen")
 (#set! "priority" 130))

((macro_invocation
   macro: (identifier) @custom.method.alloc)
 (#any-of? @custom.method.alloc
   "format"
   "vec")
 (#set! "priority" 130))

((macro_invocation
   macro: (scoped_identifier
     name: (identifier) @custom.method.alloc))
 (#any-of? @custom.method.alloc
   "format"
   "vec")
 (#set! "priority" 130))

((call_expression
   function: (scoped_identifier
     path: (identifier) @custom.alloc.type
     name: (identifier) @custom.method.alloc))
 (#any-of? @custom.alloc.type
   "Arc"
   "Box"
   "CString"
   "HashMap"
   "OsString"
   "PathBuf"
   "Rc"
   "String"
   "Vec")
 (#any-of? @custom.method.alloc
   "from"
   "from_iter"
   "from_utf8"
   "from_utf8_lossy"
   "with_capacity")
 (#set! "priority" 130))

((call_expression
   function: (scoped_identifier
     path: (scoped_identifier
       name: (identifier) @custom.alloc.type)
     name: (identifier) @custom.method.alloc))
 (#any-of? @custom.alloc.type
   "Arc"
   "Box"
   "CString"
   "HashMap"
   "OsString"
   "PathBuf"
   "Rc"
   "String"
   "Vec")
 (#any-of? @custom.method.alloc
   "from"
   "from_iter"
   "from_utf8"
   "from_utf8_lossy"
   "with_capacity")
 (#set! "priority" 130))

((call_expression
   function: (scoped_identifier
     path: (identifier) @custom.alloc.type
     name: (identifier) @custom.method.alloc))
 (#any-of? @custom.alloc.type
   "Arc"
   "Box"
   "CString"
   "Rc")
 (#eq? @custom.method.alloc "new")
 (#set! "priority" 130))

((call_expression
   function: (scoped_identifier
     path: (generic_type
       type: (type_identifier) @custom.alloc.type)
     name: (identifier) @custom.method.alloc))
 (#any-of? @custom.alloc.type
   "Arc"
   "Box"
   "CString"
   "HashMap"
   "OsString"
   "PathBuf"
   "Rc"
   "String"
   "Vec")
 (#any-of? @custom.method.alloc
   "from"
   "from_iter"
   "from_utf8"
   "from_utf8_lossy"
   "with_capacity")
 (#set! "priority" 130))

((call_expression
   function: (scoped_identifier
     path: (generic_type
       type: (scoped_identifier
         name: (identifier) @custom.alloc.type))
     name: (identifier) @custom.method.alloc))
 (#any-of? @custom.alloc.type
   "Arc"
   "Box"
   "CString"
   "HashMap"
   "OsString"
   "PathBuf"
   "Rc"
   "String"
   "Vec")
 (#any-of? @custom.method.alloc
   "from"
   "from_iter"
   "from_utf8"
   "from_utf8_lossy"
   "with_capacity")
 (#set! "priority" 130))

((call_expression
   function: (scoped_identifier
     path: (scoped_identifier
       name: (identifier) @custom.alloc.type)
     name: (identifier) @custom.method.alloc))
 (#any-of? @custom.alloc.type
   "Arc"
   "Box"
   "CString"
   "Rc")
 (#eq? @custom.method.alloc "new")
 (#set! "priority" 130))

((call_expression
   function: (scoped_identifier
     path: (generic_type
       type: (type_identifier) @custom.alloc.type)
     name: (identifier) @custom.method.alloc))
 (#any-of? @custom.alloc.type
   "Arc"
   "Box"
   "CString"
   "Rc")
 (#eq? @custom.method.alloc "new")
 (#set! "priority" 130))

((call_expression
   function: (scoped_identifier
     path: (generic_type
       type: (scoped_identifier
         name: (identifier) @custom.alloc.type))
     name: (identifier) @custom.method.alloc))
 (#any-of? @custom.alloc.type
   "Arc"
   "Box"
   "CString"
   "Rc")
 (#eq? @custom.method.alloc "new")
 (#set! "priority" 130))
