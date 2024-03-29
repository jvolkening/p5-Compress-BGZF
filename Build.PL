use 5.012;

use strict;
use warnings;
use Module::Build;
use Config;

# require 64-bit integer support
if (! $Config{use64bitint}) {
    warn "64-bit integer support required for installation\n";
    exit(0);
}

my $deployer = Module::Build->subclass(
      class => 'Module::Build::Deploy',
      code => <<'SUBCLASS' );
sub ACTION_deploy {

    require CPAN::Uploader;
    require MetaCPAN::Client;
    use version;

    my $self = shift;
    $self->depends_on("dist");

    # check that this is a newer version
    my $name = $self->dist_name;
    my $mpan = MetaCPAN::Client->new();
    my $existing = $mpan->release($name)->version;
    if (version->parse($existing) >= version->parse($self->dist_version)) {
        warn "This version is <= the version on CPAN, aborting nicely\n";
        return 1;
    }

    my $tarball = $self->dist_dir() . '.tar.gz';
    die "tarball not found"
        if (! -e $tarball);
    print "Uploading $tarball\n";
    CPAN::Uploader->upload_file( $tarball, {
        user     => $ENV{PAUSE_USER},
        password => $ENV{PAUSE_PASS},
    } );
}
SUBCLASS

my $builder = $deployer->new(
    module_name        => 'Compress::BGZF',
    license            => 'GPL_3',
    dist_author        => q{Jeremy Volkening <volkening@cpan.org>},
    configure_requires => {
        'Config'        => 0,
        'Module::Build' => 0,
    },
    build_requires => {
        'Test::More'  => 0,
        'Test::Fatal' => 0,
    },
    requires => {
        'Compress::Zlib'             => 0,
        'IO::Uncompress::RawInflate' => 0,
        'IO::Compress::RawDeflate'   => 0,
        'List::Util'                 => 0,
    },
    meta_merge => {
        resources => {
            repository => 'https://github.com/jvolkening/p5-Compress-BGZF'
        }
    },
    add_to_cleanup => [ 'Compress-BGZF-*' ],
    create_license => 1,
);
$builder->create_build_script;
