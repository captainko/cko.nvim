(element
  (start_tag
    (attribute
      (attribute_name) @_attribute_name
      (quoted_attribute_value
        (attribute_value) @_attribute_value)))
  (text) @yaml
  (#eq? @_attribute_name "lang")
  (#match? @_attribute_value "(yaml|yml)"))

(element
  (start_tag
    (attribute
      (attribute_name) @_attribute_name
      (quoted_attribute_value
        (attribute_value) @_attribute_value)))
  (text) @json
  (#eq? @_attribute_name "lang")
  (#match? @_attribute_value "json"))

(attribute
  (attribute_name) @_tag_name (#eq? @_tag_name "style")
  (quoted_attribute_value
    (attribute_value) @scss))
