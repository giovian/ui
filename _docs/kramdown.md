---
order: 2
---

# Kramdown

## Forms

<form class="prevent-default">
  <h3>Form</h3>
  <p>Description</p>
  <div>
    <label for="name">Label for name</label>
    <input type="text" name="name" placeholder="Name">
    <span>Notes on the field</span>
  </div>
  <div>
    <label for="select">Selector</label>
    <select name="select">
      <option value="1">Option 1</option>
      <option value="2">Option 2</option>
    </select>
    <span>Notes selectors</span>
  </div>
  <h4>Boolean field</h4>
  <div>
    <label for="boolean[checkbox1]" class="boolean">checkbox 1 (default)</label>
    <input type="checkbox" id="boolean[checkbox1]" name="boolean[checkbox1]" aria-label="checkbox1" value="true" data-boolean="true" />
    <span>This is the checkbox-description</span>
  </div>
  <div>
    <label for="boolean[checkbox2]" class="boolean">checkbox 2 (default)</label>
    <input type="checkbox" id="boolean[checkbox2]" name="boolean[checkbox2]" aria-label="checkbox2" value="true" data-boolean="true" />
    <span>This is the checkbox-description</span>
  </div>
  <div>
    <label for="boolean[radio]">radio buttons</label>
    <label class="radio"><input type="radio" id="boolean[radio]" name="boolean[radio]" data-boolean="true" value="true" />true</label>
    <label class="radio"><input type="radio" id="boolean[radio]" name="boolean[radio]" checked="" data-boolean="true" value="false" />false</label>
    <span>This is the radio-description</span>
  </div>
  <div>
    <label for="string[color]">color picker</label>
    <input type="color" id="string[color]" name="string[color]" aria-label="color" value="#151ce6" />
  </div>
  <div class="buttons">
    <input type="submit">
    <input type="reset">
  </div>
</form>

## Tables

Variabile | Description | Value
---|---|:---:
`html_pages` | Pages `HTML` rendered | {{ site.html_pages.size }}
`documents` | Documents in every collection | {{ site.documents.size }}

## Details

<details>
  <summary>Details</summary>
  Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
</details>

## Typography

<del>Deleted</del>
<ins>Inserted</ins>