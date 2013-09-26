# CONTRIBUTING

## Reporting a bug or issue

Feel free to submit issues [on Github](https://github.com/openminds/sneakers/issues?state=open).

Please include as much relevant information as possible. Host OS, Vagrant version, Virtualbox version, …

Please take note that debugging and fixing an issue can take time.

## Pull Requests

Please understand that Sneakers is intended to mimic our production environments. We will not accept pull requests that violate this.

## Submitting a fix

You can do this through pull requests. It's helpful and very much appreciated if you also provide the corresponding tests (chefspec).

## Submitting new features

It's encouraged to discuss new features through [Github issues](https://github.com/openminds/sneakers/issues?state=open) first. Additions like ffmpeg, wkhtmltopdf, .. should go in the extras cookbook.

## Workflow for submitting

Please use proper naming for your branch (`feature/xyz`, `bug/zyx`). At the bare minimum, make sure you've ran `cd chef ; bundle exec strainer test $CookbookYouChanged` before doing a pull request. Adding tests as well is very much appreciated.
