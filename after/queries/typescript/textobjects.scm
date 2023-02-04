(interface_declaration
  body: (object_type) @class.inner) @class.outer

(expression_statement) @expression.outer

(([
  (import_statement)
  (expression_statement)
]) @expression.outer)

(lexical_declaration
  (variable_declarator
  value: (_) @expression.inner)) @expression.outer

(assignment_expression
  right: (_) @expression.inner) @expression.outer

(call_expression
  arguments: (arguments (_) @prop.inner))

; { a : value [inner] } [outer]
(object (pair
    value: [(string) (template_string) (object)] @prop.inner ) @prop.outer )
