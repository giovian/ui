---
order: 50
---

# Schema
{:.no_toc}
- toc
{:toc}

> <https://json-schema.org/>

Data structure are defined with JSON Schema and managed with FORMS.

Data resides in [`_data`]({% include widgets/github_url.html path="_data" %}) folder, available for Jekyll with `{% raw %}{{ site.data }}{% endraw %}`{:.language-liquid}.

## Keywords

**Custom keywords**

- **Meta-data**: don’t affect validation e.g. `units`
- **non-impairing**: don’t apply other schemas and don’t modify existing keywords e.g. `isEven`, need a custom validation
- **impairing**: apply other schemas or modify existing keywords e.g. `requiredProperties`

**Annotations**

Describe a schema
- `title`: string
- `description`: string
- `readOnly`: boolean to exclude from writing
- `writeOnly`: boolean, hidden to user

**Format**

`format` is an annotation keyword for semantic information.

## Type

Primitive types of an instance are `string, number, array, object, boolean, null` (integer too) and can be defined in this ways:

- `type`: may either be a string or a unique strings array
- `enum`: restrict the value to a fixed set (array), a SELECT input will be used  
  In the `array` case, will have the `multiple` attribute
- `const`: restrict the value to a single value (like enum with one item)

Every instance can have a `default` pre-filled value, should validate against the schema in which it resides, but that isn’t required.

### String

**Validation keywords**
- `minLength` and `maxLength`: integers > 0
- `pattern`: ECMA-262 regular expression e.g. `^(\\([0-9]{3}\\))?[0-9]{3}-[0-9]{4}$` North American telephone number with optional area code e.g. `(888)555-1212`

**Format attributes**

- `date-time`: Date and time together, e.g. `2018-11-13T20:20:39+00:00`.
- `time`: e.g. `20:20:39+00:00`
- `date`: e.g. `2018-11-13`.
- `duration`: `P{n}Y{n}M{n}W{n}DT{n}H{n}M{n}S` A duration as defined by the ISO 8601 ABNF for “duration” e.g. P3D expresses a duration of 3 days.  
  `P3Y6M4DT12H30M5S` represents a duration of three years, six months, four days, twelve hours, thirty minutes, and five seconds.
- `email`: Internet email address, see RFC 5322, section 3.4.1.
- `uri`: Universal Resource Identifier

**Custom formats attributes**
- `textarea`: use TEXTAREA for input
- `color`: color picker with hex format `#rrggbb`

**Custom keywords**
- `tooltip`: text visualized on mousehover
- `placeholder`: semi-opaque text rendered in the empty input field

### Numbers

- `number`
- `integer`: negative and zero fractional are ok)  
  `<input>`{:.language-html} use `step="1" pattern="\d+"` attributes

**Validation keywords**
- `multipleOf`: number > 0
- `minimum` and `maximum`: inclusive limits (numbers)
- `exclusiveMinimum` and `exclusiveMaximum`: exclusive limits (numbers)

**Custom formats attributes**
- `range`: use a INPUT `type="range"`, need `minimum` and `maximum` and optionally `multipleOf`.  
  Current value will use OUTPUT element

**Custom keywords**
- `tooltip`: text visualized on mousehover (string)
- `placeholder`: semi-opaque text rendered in the empty input field (string)
- `units`: annotation string

### Object

They map `keys` to `values`, each of these pairs is conventionally referred to as a _property_ and defined using the `properties` keywords.

- In JSON, the `keys` must always be strings.
- `required`: is unique strings array (the required properties) and is defined under an object property (scope).
- `dependentRequired`: requires that certain properties must be present if a given property is present.  
  ```json
  "dependentRequired": {
    "credit_card": ["billing_address"],
    "billing_address": ["credit_card"]
  }
  ```
- Conditional property definition:  
  ```json
  "if": {
    "properties": { "country": { "const": "United States of America" } }
  },
  "then": {
    "properties": { "postal_code": { "pattern": "[0-9]{5}(-[0-9]{4})?" } }
  },
  "else": {
    "properties": { "postal_code": { "pattern": "[A-Z][0-9][A-Z] [0-9][A-Z][0-9]" } }
  }
  ```

### Array

- `items: {type: number}`: List validation (is a schema)
- `items: [{type: string}, {type: number}]`: Tuple validation (are different schemas)
- `minItems` and `maxItems`: non-negative integers
- `uniqueItems`: boolean

### Boolean

`true` or `false`

## Reusing

Schemas have an absolute URI `{{ site.github.repository_url }}/_data/` and a JSON pointer (slash-separated path to traverse the properties).

A schema in the file `_data/schema.json` will have `$id: {{ site.github.repository_url }}/_data/schema`

- `$ref` URI reference a schema or a definition (`$def` is an object with properties).  
  ```json
  {
    "$defs": {
      "point": {
        "type": "object",
        "properties": {
          "x": { "type": "number" },
          "y": { "type": "number" }
        },
        "additionalProperties": false,
        "required": [ "x", "y" ]
      }
    },
    "type": "array",
    "items": { "$ref": "#/$defs/point" },
  }
  ```

- `#` is used for recursive referencing.  
  ```json
  {
    "type": "object",
    "properties": {
      "name": { "type": "string" },
      "children": {
        "type": "array",
        "items": { "$ref": "#" }
      }
    }
  }
  ```

## Special keywords

- `watch`: array of properties to watch, current property update when properties change
- `pool`: use with `watch`, it is the numeric limit for the sum of watched properties (also numbers)
- `eval`: math formula with string interpolation  
  ```js
  function parse(str) {
    return Function(`'use strict'; return (${str})`)()
  }
  parse("1+2+3"); 
  ```

## Experimental UI

**Columns**

`columns` is a nested array, every first order item is an array of properties pertaining to that column.

```js
{
  "columns": [
    [col1-1, col1-2],
    [col2-1]
  ]
}
```

Or simple attribute: `col: 2`

**Colors**

`colors` is an object, the properties are theme colors and are arrays of properties pertaining to that color.

```js
{
  "colors": {
    "blue": [prop-1, prop-2],
    "red": [prop-3]
  }
}
```

Or simple attributes: `ink: black, background: black`

**To do**

- `$def` property definitions and reuse
- `default` keyword
- `enum` and `const` as types
- `enum` as select input
- `items` tuple validation
- Conditional property definition `if`, `then`, `else`
- Logical subschema definition `allOf`, `anyOf`, `oneOf`, `not`
- Properties dependent required `dependentRequired`