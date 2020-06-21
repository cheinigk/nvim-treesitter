;; From tree-sitter-python licensed under MIT License
; Copyright (c) 2016 Max Brunsfeld

; Identifier naming conventions

(identifier) @Normal
((identifier) @type
 (match? @type "^[A-Z]"))
((identifier) @constant
 (match? @constant "^[A-Z][A-Z_0-9]*$"))

((identifier) @constant.builtin
 (match? @constant.builtin "^__[a-zA-Z0-9_]*__$"))

; Function calls

(decorator) @function
((decorator (dotted_name (identifier) @function))
 (match? @function "^([A-Z])@!.*$"))

(call
  function: (identifier) @function)

(call
  function: (attribute
              attribute: (identifier) @method))

((call
   function: (identifier) @constructor)
 (match? @constructor "^[A-Z]"))

((call
  function: (attribute
              attribute: (identifier) @constructor))
 (match? @constructor "^[A-Z]"))

;; Builtin functions

((call
  function: (identifier) @function.builtin)
 (match?
   @function.builtin
   "^(abs|all|any|ascii|bin|bool|breakpoint|bytearray|bytes|callable|chr|classmethod|compile|complex|delattr|dict|dir|divmod|enumerate|eval|exec|filter|float|format|frozenset|getattr|globals|hasattr|hash|help|hex|id|input|int|isinstance|issubclass|iter|len|list|locals|map|max|memoryview|min|next|object|oct|open|ord|pow|print|property|range|repr|reversed|round|set|setattr|slice|sorted|staticmethod|str|sum|super|tuple|type|vars|zip|__import__)$"))

;; Function definitions

(function_definition
  name: (identifier) @function)

(type (identifier) @type)

((call
  function: (identifier) @isinstance
  arguments: (argument_list
    (*)
    (identifier) @type))
 (eq? @isinstance "isinstance"))

; Normal parameters
(parameters
  (identifier) @parameter)
; Default parameters
(keyword_argument
  name: (identifier) @parameter)
; Naming parameters on call-site
(default_parameter
  name: (identifier) @parameter)
; Variadic parameters *args, **kwargs
(parameters
  (list_splat ; *args
    (identifier) @parameter))
(parameters
  (dictionary_splat ; **kwargs
    (identifier) @parameter))


; Literals

(none) @constant.builtin
(true) @boolean
(false) @boolean
((identifier) @constant.builtin
              (match? @constant.builtin "self"))

(integer) @number
(float) @float

(comment) @comment
(string) @string
(escape_sequence) @string.escape

; Tokens

"-" @operator
"->" @operator
"-=" @operator
"!=" @operator
"*" @operator
"**" @operator
"**=" @operator
"*=" @operator
"/" @operator
"//" @operator
"//=" @operator
"/=" @operator
"&" @operator
"%" @operator
"%=" @operator
"^" @operator
"+" @operator
"+=" @operator
"<" @operator
"<<" @operator
"<=" @operator
"<>" @operator
"=" @operator
"==" @operator
">" @operator
">=" @operator
">>" @operator
"|" @operator
"~" @operator
"and" @operator
"in" @operator
"is" @operator
"not" @operator
"or" @operator

; Keywords

"as" @include
"assert" @keyword
"async" @keyword
"await" @keyword
"break" @repeat
"class" @keyword
"continue" @repeat
"def" @keyword
"del" @keyword
"elif" @conditional
"else" @conditional
"except" @keyword
"exec" @keyword
"finally" @keyword
"for" @repeat
"from" @include
"global" @keyword
"if" @conditional
"import" @include
"lambda" @keyword
"nonlocal" @keyword
"pass" @keyword
"print" @keyword
"raise" @keyword
"return" @keyword
"try" @keyword
"while" @repeat
"with" @keyword
"yield" @keyword

; Additions for nvim-treesitter
"(" @punctuation.bracket
")" @punctuation.bracket
"[" @punctuation.bracket
"]" @punctuation.bracket
"{" @punctuation.bracket
"}" @punctuation.bracket

(interpolation
  "{" @punctuation.special
  "}" @punctuation.special) @embedded

"," @punctuation.delimiter
"." @punctuation.delimiter
":" @punctuation.delimiter

; Class definitions

(class_definition
  name: (identifier) @type)
(class_definition
  superclasses: (argument_list
    (identifier) @type))

((attribute
    attribute: (identifier) @field)
 (match? @field "^([A-Z])@!.*$"))

((class_definition
  body: (block
          (expression_statement
            (assignment
              left: (expression_list
                      (identifier) @field)))))
 (match? @field "^([A-Z])@!.*$"))

;; Error
(ERROR) @error
