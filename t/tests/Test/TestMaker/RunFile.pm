package Test::TestMaker::RunFile;

use strict;
use base 'My::Test::Class';
use Test::Most;

sub fileData : Tests() {
    my $test = shift;

    can_ok($test->class(), 'fileData');
}

1;
