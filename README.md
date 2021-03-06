# Scrub Params

:lock: Safer Rails parameters by default

JavaScript and HTML have no business in most parameters. Take the **whitelist approach** and remove them by default.

**Note:** Rails does amazing work to prevent [cross-site scripting (XSS)](http://en.wikipedia.org/wiki/Cross-site_scripting), but storing `<script>badThings()</script>` in your database makes it much easier to make mistakes.

Works with Rails 3.2 and above

## Get Started

Add this line to your application’s Gemfile:

```ruby
gem 'scrub_params'
```

You now have another line of defense against XSS.

### Test It

Submit HTML in one of your forms.

```html
Hello <script>alert('World')</script>
```

This becomes:

```
Hello alert('World')
```

And you should see this in your logs:

```
Scrubbed parameters: name
```

### Original Parameters

Access the original parameters with:

```ruby
unscrubbed_params
```

### Whitelist Actions

To skip scrubbing for certain actions, use:

```ruby
skip_before_filter :scrub_params, only: [:create, :update]
```

## TODO

- whitelist parameters
- whitelist tags

## Contributing

Everyone is encouraged to help improve this project. Here are a few ways you can help:

- [Report bugs](https://github.com/ankane/scrub_params/issues)
- Fix bugs and [submit pull requests](https://github.com/ankane/scrub_params/pulls)
- Write, clarify, or fix documentation
- Suggest or add new features
