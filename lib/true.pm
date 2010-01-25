package true;

use strict;
use warnings;

use B::Hooks::Parser;

our $VERSION = '0.01';

sub import {
    B::Hooks::Parser::inject('1;');
}

1;

__END__

=head1 NAME

true - automatically return a true value when a file is required

=head1 SYNOPSIS

  package Contemporary::Perl;

  use strict;
  use warnings;
  use true;

  sub import {
      strict->import();
      warnings->import();
      true->import();
  }

=head1 DESCRIPTION

Perl's C<require> builtin (and its C<use> wrapper) requires the files it loads to return a true value.
This is usually accomplished by placing a single

    1;
    
statement at the end of included scripts or modules. It's not onerous to add but it's
a speed bump on the Perl novice's road to enlightenment. In addition, it appears to be
a I<non-sequitur> to the uninitiated, leading some to attempt to mitigate its appearance
with a comment:

    1; # keep require happy

or:

    1; # Do not remove this line
    
or even:

    1; # Must end with this, because Perl is bogus.

This module packages this "return true" behaviour so that it need not be written explicitly.
It shouldn't be used directly, except, perhaps, for pedagogical purposes. Rather it is intended
to be invoked from the C<import> method of a L<Modern::Perl|Modern::Perl>-style module that
enables modern Perl features and conveniences and cleans up legacy Perl warts.

=head2 METHODS

=head3 import

This method should be invoked from the C<import> method of a module that uses C<true>. It takes no arguments.

The C<import> method inserts "1;" at the perl parser's current position. Code that uses
this module solely on behalf of its caller can load C<true> without invoking it e.g.

    use true (); # don't import

    sub import {
        true->import();
    }

    1;

But there's nothing stopping a wrapper module also using C<true> to obviate its own need to
explicitly return a true value:

    use true; # both load and use it

    sub import {
        true->import();
    }

    # no need to return true

=head2 EXPORT

None by default.

=head2 CAVEATS

No attempt is made to inject the true return value at the top-level of the currently-compiling file. Thus,
modules that export C<true> should be used at the top-level e.g.

This works:

    package MyModule;

    use Contemporary::Perl;

    # no need to return true

This doesn't:

    package MyModule;

    {
        use Contemporary::Perl;

        # true value injected here
    }

    # true value not injected here; error when the module is required

=head1 SEE ALSO

=over

=item * L<Modern::Perl|Modern::Perl>

=item * L<Toolkit|Toolkit>

=item * L<latest|latest>

=item * L<uni::perl|uni::perl>

=back

=head1 AUTHOR

chocolateboy, E<lt>chocolate@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2010 by chocolateboy

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.10.0 or,
at your option, any later version of Perl 5 you may have available.

=cut
