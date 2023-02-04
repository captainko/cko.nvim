; <tag :directive_attribute="<expression>"></tag>
((directive_attribute
  (quoted_attribute_value (attribute_value) @attribute.inner)) @attribute.outer)

; <tag attribute_name="<value>"></tag>
((attribute
  (quoted_attribute_value (attribute_value) @attribute.inner)?) @attribute.outer)

((comment) @comment.outer)
