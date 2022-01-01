---
order: 60
---

# Forms
{:.no_toc}
* toc
{:toc}

<form class="prevent-default">
  <h3>Preview</h3>
  <p>Description</p>
  <div class="grid">
    <div>
      <div data-type="text">
        <label for="string">Title text</label>
        <input type="text" name="string" placeholder="String">
        <span>Description</span>
      </div>
      <div data-type="textarea">
        <label for="textarea">Title textarea</label>
        <textarea id="textarea" name="textarea" placeholder="Textarea" data-skip-falsy="true"></textarea>
        <span>Description</span>
      </div>
      <div data-type="number">
        <label for="number">Title number</label>
        <input type="number" name="number" placeholder="1" data-value-type="number">
        <span>Description</span>
      </div>
      <div data-type="range">
        <label for="range">Title Range</label>
        <input type="range" name="range" data-value-type="number"><output name="range_output" for="range"></output>
        <span>Description</span>
      </div>
      <div data-type="array">
        <div>
          <label>Array <a href="#array" data-index="0" data-add="array" class="prevent-default">add</a></label>
        </div>
        <template>
          <div class="array-item">
            <div>
              <label for="array[]">
                array[] <a href="#array[]" title="Remove item" data-remove="array[]" data-prevent="true">Remove</a>
            </label>
            <input type="text" id="array[]" name="array[]" aria-label="array[]">
            </div>
          </div>
        </template>
      </div>
    </div>
    <div>
      <div data-type="select">
        <label for="select">Selector</label>
        <select name="select" data-value-type="boolean">
          <option value="true">True</option>
          <option value="false">False</option>
        </select>
        <span>Notes selectors</span>
      </div>
      <div data-type="select multiple">
        <label for="select">Selector multiple</label>
        <select name="select_multiple[]" multiple> 
          <option value="1">Option 1</option>
          <option value="2">Option 2</option>
          <option value="3">Option 3</option>
          <option value="4">Option 4</option>
          <option value="5">Option 5</option>
          <option value="6">Option 6</option>
        </select>
        <span>Notes multiple selectors</span>
      </div>
      <div data-type="color">
        <label for="nested[color]">Color picker</label>
        <input type="color" id="nested[color]" name="nested[color]" aria-label="color" value="#151ce6" />
        <span>Notes colors</span>
      </div>
    </div>
  </div>
  <div data-type="button">
    <input type="submit" value="Save">
    <input type="reset">
    <input type="button" value="Button">
  </div>
</form>

## Storing data

**Authentication and saving path**

To save a data file is required a logged user with writing permission.
```js
storage.get("login.role") = "admin"
```
{:.minimal}

When done in a original repository (not a fork), the file will be directy committed in `/_data/path/file.json`.
```js
storage.get("repository.fork") = false
```
{:.minimal}

When done in a forked repository, the file will be saved in `/_data/user/<username>/path/file.json` and a Pull request will be performed.
```js
storage.get("repository.fork") = true
```
{:.minimal}

**Working on schemas**

- Schema path

**Working on documents**

- Schema path and optional document path

## Schema FORM

```liquid
{% raw %}{% include widgets/schema.html schema='practices' %}{% endraw %}
```
{:.minimal}
{% include widgets/schema.html schema='practices' %}

## Document FORM

```liquid
{% raw %}{% include widgets/document.html schema='practices' %}{% endraw %}
```
{:.minimal}
{% include widgets/document.html schema='practices' %}