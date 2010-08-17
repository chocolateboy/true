package true;

use strict;
use warnings;

use B::Hooks::OP::Annotation;
use B::Hooks::OP::Check;
use Devel::StackTrace;
use XSLoader;

our $VERSION = '0.11';
our %TRUE;

XSLoader::load(__PACKAGE__, $VERSION);

sub ccfile() {
    my ($ccfile, $ccline);
    my $trace = Devel::StackTrace->new;

    while (my $frame = $trace->next_frame) {
        my $sub = $frame->subroutine;
        next unless ($sub =~ /::BEGIN$/);
        my $prev_frame = $trace->prev_frame;
        $ccfile = $prev_frame->filename;
        $ccline = $prev_frame->line;
        last;
    }

    if (defined($ccfile) && not(length($ccfile))) {
        ($ccfile, $ccline) = (undef, undef);
    }

    return wantarray ? ($ccfile, $ccline) : $ccfile;
}

sub import {
    my ($ccfile, $ccline) = ccfile();

    if (defined($ccfile) && not($TRUE{$ccfile})) {
        $TRUE{$ccfile} = 1;
        # warn "enabling true for $ccfile at line $ccline: ", pp(\%TRUE), $/;
        xs_enter();
    }
}

sub unimport {
    my ($ccfile, $ccline) = ccfile();

    if (defined($ccfile) && $TRUE{$ccfile}) {
        # warn "disabling true for $ccfile at line $ccline: ", pp(\%TRUE), $/;
        delete $TRUE{$ccfile};
        xs_leave() unless (%TRUE);
    }
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
It can be used directly, but it is intended to be invoked from the C<import> method of a
L<Modern::Perl|Modern::Perl>-style module that enables modern Perl features and conveniences
and cleans up legacy Perl warts.

=head2 METHODS

C<true> is file-scoped rather than lexically-scoped. Importing it anywhere in a
file (e.g. at the top-level or in a nested scope) causes that file to return true,
and unimporting it anywhere in a file restores the default behaviour. Duplicate imports/unimports
are ignored.

Note also that these methods are only useful at compile-time.

=head3 import

This method, which takes no arguments, should be invoked from the C<import> method of a module that
loads C<true>. Code that uses this module solely on behalf of its caller can load C<true> without
importing it e.g.

    use true (); # don't import

    sub import {
        true->import();
    }

    1;

But there's nothing stopping a wrapper module also importing C<true> to obviate its own need to
explicitly return a true value:

    use true; # both load and import it

    sub import {
        true->import();
    }

    # no need to return true

=head3 unimport

This method disables the "automatically return true" behaviour for the current file.

=head2 EXPORT

None by default.

=head1 SEE ALSO

=over

=item * L<Modern::Perl|Modern::Perl>

=item * L<Toolkit|Toolkit>

=item * L<latest|latest>

=item * L<perl5i|perl5i>

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
