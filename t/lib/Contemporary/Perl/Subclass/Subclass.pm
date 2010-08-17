package Contemporary::Perl::Subclass::Subclass;

use strict;
use warnings;
use true; # before use base qw(...);
use base qw(Contemporary::Perl::Subclass);

sub import {
    my $class = shift;
    $class->SUPER::import(@_);
}
