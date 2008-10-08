use inc::Module::Install;
include 'Module::AutoInstall';

name 'Data-Pack';
all_from 'lib/Data/Pack.pm';
perl_version '5.006';

requires 'Scalar::Util';

recommends 'Test::Pod';
recommends 'Test::Pod::Coverage';

test_requires 'Test::More' => '0.70';
test_requires 'Test::Differences';
test_requires 'Test::Compile';

auto_install;
auto_include;
WriteAll;
