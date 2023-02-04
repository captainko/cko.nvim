(attribute ((quoted_attribute_value ((attribute_value) @angular))) @_value
  (#lua-match? @_value "%{%{.+%}%}")
  (#offset! @angular 0 2 0 -2))


(attribute
  (attribute_name) @_tag_name (#eq? @_tag_name "style")
  (quoted_attribute_value
    (attribute_value) @scss))
