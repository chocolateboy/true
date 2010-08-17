package Contemporary::Perl::Subclass;

use strict;
use warnings;
use base qw(Contemporary::Perl);
use true; # after use base qw(...)

sub import {
    my $class = shift;
    $class->SUPER::import(@_);
}
