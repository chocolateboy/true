#!/usr/bin/env perl

use strict;
use warnings;

use File::Spec;
use FindBin qw($Bin);
use Test::More tests => 3;

use lib (File::Spec->catdir($Bin, 'lib'));

eval 'use Good';
is $@, '', 'use: module using true';
is Good::Good(), 'Good', 'use: module loaded OK';

eval 'use Bad';
like $@, qr{Bad.pm did not return a true value\b}, 'use: module not using true';;
