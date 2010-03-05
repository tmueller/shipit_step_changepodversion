use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'ShipIt::Step::ChangePodVersion',
    license             => 'perl',
    dist_author         => q{Thomas Mueller <tmueller@cpan.org>},
    dist_version_from   => 'lib/ShipIt/Step/ChangePodVersion.pm',
    build_requires => {qw~
        Test::More          0
        Test::Exception     0
    ~},
    requires       => {qw~
        ShipIt              0.53
    ~},
    add_to_cleanup      => [ 'ShipIt-Step-ChangePodVersion-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
