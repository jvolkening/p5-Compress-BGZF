use 5.010001;
use strict;
use warnings FATAL => 'all';
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME             => 'Compress::BGZF',
    AUTHOR           => q{Jeremy Volkening <jdv*at*base2bio*dot*com>},
    VERSION_FROM     => 'lib/Compress/BGZF.pm',
    ABSTRACT_FROM    => 'lib/Compress/BGZF.pm',
    LICENSE          => 'GPL_3',
    PL_FILES         => {},
    MIN_PERL_VERSION => 5.010001,
    CONFIGURE_REQUIRES => {
        'ExtUtils::MakeMaker' => 0,
    },
    BUILD_REQUIRES => {
        'Test::More' => 0,
    },
    PREREQ_PM => {
        'Compress::Zlib' => 0,
        'IO::Uncompress::RawInflate' => 0,
        'IO::Compress::RawDeflate' => 0,
        'List::Util' => 0,
    },
    EXE_FILES => [qw|
        bin/bgzip.pl
    |],
    META_MERGE => {
        'meta-spec' => { version => 2 },
        resources => {
            repository => {
                type => 'git',
                url => 'https://github.com/jvolkening/p5-Compress-BGZF.git',
                web => 'https://github.com/jvolkening/p5-Compress-BGZF',
            },
        },
    },
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES => 'Compress-BGZF-*' },
);
