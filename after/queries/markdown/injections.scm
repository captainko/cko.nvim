

; ==============================================================================
; ```ts/js
; ```
; ==============================================================================

(fenced_code_block
        (_ (language) @_language (#eq? @_language "ts"))
        (code_fence_content) @typescript)

(fenced_code_block
        (_ (language) @_language (#eq? @_language "js"))
        (code_fence_content) @javascript)

; ==============================================================================
; ```sh/shell/shell-script/zsh
; ```
; ==============================================================================
(fenced_code_block
        (_ (language) @_language (#match? @_language "(sh|shell|shell-script|zsh)"))
        (code_fence_content) @bash)
