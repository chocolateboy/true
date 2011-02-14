package true::VERSION;

require true; our $VERSION = $true::VERSION;


=head1 NAME

true::VERSION - shim to allow depending on true.pm

=head1 DESCRIPTION

This module exists to work around bugs in the dependency system which
prevent modules from depending on L<true>.

Instead of depending on L<true>, depend on L<true::VERSION> with the
same version number.

This module was introduced with version 0.15 of true.

=cut
