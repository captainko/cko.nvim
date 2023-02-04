; ==============================================================================
; Graphql
; ==============================================================================

;; function buildSchema(`type A{}`);
(call_expression
  function: ((identifier) @_name
             (#eq? @_name "buildSchema"))
  arguments: (arguments (template_string) @graphql
              (#offset! @graphql 0 1 0 -1)))

;; const type = `extend type Address {children [Address]}`
(lexical_declaration
  (variable_declarator
    name: ((identifier) @_name
            (#eq? @_name "type"))
    value: ((template_string) @graphql
            (#offset! @graphql 0 1 0 -1))))

(decorator (call_expression
  function: ((identifier) @_decorator_name
             (#eq? @_decorator_name "Service"))
  arguments: (arguments (object (pair (object (pair
              key: ((property_identifier) @_prop_graph
                     (#eq? @_prop_graph "graphql"))
              value: (object (pair
                      key: ((property_identifier) @_prop_type (#eq? @_prop_type "type"))
                      value: ((template_string) @graphql (#offset! @graphql 0 1 0 -1)))))))))))
