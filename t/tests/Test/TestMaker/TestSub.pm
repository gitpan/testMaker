package Test::TestMaker::TestSub;

use strict;
use base 'My::Test::Class';
use Test::Most;

sub constructor : Tests() {
    my $test = shift;

    can_ok($test->class(), 'new');

    dies_ok {
        $test->class->new();
    }
    '.... dies with no args';

    dies_ok {
        $test->class->new({subName => undef});
    }
    '.... dies with subName undef';

    lives_ok {
        $test->class->new({subName => 'new'});
    }
    '.... lives with subName as new';
}

sub subName : Tests() {
    my $test = shift;

    can_ok($test->class(), 'subName');

    my $testSub = $test->testSubFactory('blah');
    is($testSub->subName(), 'blah', '.... we return the expected subName after construction');

    dies_ok {
        $testSub->subName(undef);
    }
    '.... dies if we try and set subName to undef';

    $testSub->subName('a');
    is($testSub->subName(), 'a', '.... we return the expected subName after changing it');
}

sub testSubName : Tests() {
    my $test = shift;

    can_ok($test->class(), 'testSubName');

    my $testSub = $test->testSubFactory('blah');
    is($testSub->testSubName(), 'blah', '.... we return the expected testSubName after construction');

    dies_ok {
        $testSub->testSubName(undef);
    }
    '.... dies if we try and set testSubName to undef';

    $testSub->testSubName('a');
    is($testSub->testSubName(), 'a', '.... we return the expected testSubName after changing it');

    $testSub->testSubName('new');
    is($testSub->testSubName(), 'constructor', '.... we return constructor if testSubName is passed new');
}

sub _validateSubName : Tests() {
    my $test = shift;

    can_ok($test->class(), '_validateSubName');

    my $testSub = $test->testSubFactory('blah');
    is($testSub->_validateSubName(undef), 0, '.... returns 0 on undef');
    is($testSub->_validateSubName(0),     0, '.... returns 0 on 0');
    is($testSub->_validateSubName('sub'), 0, '.... returns 0 on sub');

    is($testSub->_validateSubName('_validateSubName'), 1, '.... returns 1 on valid sub');
}

sub testSubDefinition : Tests() {
    my $test = shift;

    can_ok($test->class(), 'testSubDefinition');

    my $testSub = $test->testSubFactory('blah');
    is(
        $testSub->testSubDefinition(),
        $test->_expectedSubDefinition(),
        '.... got expected test sub definition back'
    );
}

sub testSubFactory {
    my ($test, $subName) = @_;
    if ($subName) {
        return $test->class->new({subName => $subName});
    }
    else {
        return $test->class->new({subName => 'testSub'});
    }
}

sub _expectedSubDefinition {
    my $test = shift;
    return q!sub blah : Tests() {
    my $test = shift;

    can_ok($test->class(), 'blah');
}

!
}

1;
