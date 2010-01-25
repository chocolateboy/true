use strict;
use warnings;

use ExtUtils::MakeMaker;

WriteMakefile(
    NAME              => 'true',
    VERSION_FROM      => 'lib/true.pm',
    PREREQ_PM         => {
        'B::Hooks::Parser' => 0.09
    },
    ($] >= 5.005 ?
      (ABSTRACT_FROM  => 'lib/true.pm',
       AUTHOR         => 'chocolateboy <chocolate@cpan.org>') : ()),
    ($ExtUtils::MakeMaker::VERSION >= 6.31 ? (LICENSE => 'perl') : ()),
);
