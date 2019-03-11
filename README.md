# true

[![Build Status](https://secure.travis-ci.org/chocolateboy/true.svg)](http://travis-ci.org/chocolateboy/true)
[![CPAN Version](https://badge.fury.io/pl/true.svg)](https://metacpan.org/pod/true)

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [NAME](#name)
- [SYNOPSIS](#synopsis)
- [DESCRIPTION](#description)
- [METHODS](#methods)
  - [import](#import)
  - [unimport](#unimport)
- [EXPORTS](#exports)
- [NOTES](#notes)
- [VERSION](#version)
- [SEE ALSO](#see-also)
- [AUTHOR](#author)
- [COPYRIGHT AND LICENSE](#copyright-and-license)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# NAME

true - automatically return a true value when a file is required

# SYNOPSIS

```perl
package Contemporary::Perl;

use strict;
use warnings;
use true;

sub import {
    strict->import();
    warnings->import();
    true->import();
}
```

# DESCRIPTION

Perl's `require` builtin (and its `use` wrapper) requires the files it loads to return a true value.
This is usually accomplished by placing a single

```perl
1;
```

statement at the end of included scripts or modules. It's not onerous to add but it's
a speed bump on the Perl novice's road to enlightenment. In addition, it appears to be
a _non-sequitur_ to the uninitiated, leading some to attempt to mitigate its appearance
with a comment:

```perl
1; # keep require happy
```

or:

```perl
1; # Do not remove this line
```

or even:

```perl
1; # Must end with this, because Perl is bogus.
```

This module packages this "return true" behaviour so that it doesn't need to be written explicitly.
It can be used directly, but it is intended to be invoked from the `import` method of a
[Modern::Perl](https://metacpan.org/pod/Modern::Perl)-style module that enables modern Perl features and conveniences
and cleans up legacy Perl warts.

# METHODS

`true` is file-scoped rather than lexically-scoped. Importing it anywhere in a
file (e.g. at the top-level or in a nested scope) causes that file to return true,
and unimporting it anywhere in a file restores the default behaviour. Redundant imports/unimports
are ignored.

## import

Enable the "automatically return true" behaviour for the currently-compiling file. This should
typically be invoked from the `import` method of a module that loads `true`. Code that uses
this module solely on behalf of its callers can load `true` without importing it e.g.

```perl
use true (); # don't import

sub import {
    true->import();
}

1;
```

But there's nothing stopping a wrapper module also importing `true` to obviate its own need to
explicitly return a true value:

```perl
use true; # both load and import it

sub import {
    true->import();
}

# no need to return true
```

## unimport

Disable the "automatically return true" behaviour for the currently-compiling file.

# EXPORTS

None by default.

# NOTES

Because the unquoted name `true` represents the boolean value `true` in YAML, the module name must be
quoted when written as a dependency in META.yml. In cases where this can't easily be done,
a dependency can be declared on the package [true::VERSION](https://metacpan.org/pod/true::VERSION), which has the same version as `true.pm`.

# VERSION

1.0.1

# SEE ALSO

* [latest](https://metacpan.org/pod/latest)
* [Modern::Perl](https://metacpan.org/pod/Modern::Perl)
* [nonsense](https://metacpan.org/pod/nonsense)
* [perl5i](https://metacpan.org/pod/perl5i)
* [Toolkit](https://metacpan.org/pod/Toolkit)

# AUTHOR

[chocolateboy](mailto:chocolate@cpan.org)

# COPYRIGHT AND LICENSE

Copyright © 2010-2019 by chocolateboy.

This is free software; you can redistribute it and/or modify it under the terms of the
[Artistic License 2.0](http://www.opensource.org/licenses/artistic-license-2.0.php).
