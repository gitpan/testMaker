package Test::TestMaker::TestClass;

use strict;
use base 'My::Test::Class';
use Test::Most;

sub constructor : Tests() {
    my $test = shift;

    can_ok($test->class(), 'new');

    dies_ok {
        $test->class->new();
    }
    '.... dies with libPath arg';

    dies_ok {
        $test->class->new({libPath => undef});
    }
    '.... dies with libPath undef';

    dies_ok {
        $test->class->new({libPath => 'new'});
    }
    '.... dies with libPath not valid file';

    lives_ok {
        $test->testClassFactory();
    }
    '.... lives with libPath as real file';
}

sub libPath : Tests() {
    my $test = shift;

    can_ok($test->class(), 'libPath');

    my $testClass = $test->testClassFactory();
    is($testClass->libPath(), 'lib/TestMaker.pm', '.... we return the expected libPath after construction');

    dies_ok {
        $testClass->libPath(undef);
    }
    '.... dies if we try and set libPath to undef';

    $testClass->libPath('lib/TestMaker/TestSub.pm');
    is($testClass->libPath(), 'lib/TestMaker/TestSub.pm',
        '.... we return the expected libPath after changing it');
}

sub _validateLibPath : Tests() {
    my $test = shift;

    can_ok($test->class(), '_validateLibPath');

    my $testClass = $test->testClassFactory();
    is($testClass->_validateLibPath(),       0, '.... returns 0 when called with no arg');
    is($testClass->_validateLibPath(undef),  0, '.... returns 0 when called with undef arg');
    is($testClass->_validateLibPath(0),      0, '.... returns 0 when called with arg 0');
    is($testClass->_validateLibPath('lib/'), 0, '.... returns 0 when called with a directory');

  TODO: {
        local $TODO = 'Work out how to test on file we dont have read access on';
        is($testClass->_validateLibPath('blah'),
            0, '.... returns 0 when called with a file we dont have read access on');
    }
}

sub makeTestFile : Tests() {
    my $test = shift;

    can_ok($test->class(), 'makeTestFile');

  TODO: {
        local $TODO = 'Refactor to make this testable';
        ok(0);
    }
}

sub _testFilePath : Tests() {
    my $test = shift;

    can_ok($test->class(), '_testFilePath');

    my $testClass = $test->testClassFactory('lib/TestMaker.pm');
    is($testClass->_testFilePath(), 't/tests/Test/TestMaker.pm', '.... correctly got full test path');
    $testClass->libPath('lib/TestMaker/RunFile.pm');
    is($testClass->_testFilePath(), 't/tests/Test/TestMaker/RunFile.pm', '.... correctly got full test path');
}

sub _makeTestDir : Tests() {
    my $test = shift;

    can_ok($test->class(), '_makeTestDir');

  TODO: {
        local $TODO = 'Refactor to make this testable';
        ok(0);
    }
}

sub _testDir : Tests() {
    my $test = shift;

    can_ok($test->class(), '_testDir');

    my $testClass = $test->testClassFactory('lib/TestMaker.pm');
    is($testClass->_testDir(), 't/tests/Test', '.... correctly got dir name');
    $testClass->libPath('lib/TestMaker/RunFile.pm');
    is($testClass->_testDir(), 't/tests/Test/TestMaker', '.... correctly got dir name');
}

sub _testFile : Tests() {
    my $test = shift;

    can_ok($test->class(), '_testFile');

    my $testClass = $test->testClassFactory('lib/TestMaker.pm');
    is($testClass->_testFile(), 'TestMaker.pm', '.... correctly got filename');
    $testClass->libPath('lib/TestMaker/RunFile.pm');
    is($testClass->_testFile(), 'RunFile.pm', '.... correctly got filename');
}

sub _makeTestFileContent : Tests() {
    my $test = shift;

    can_ok($test->class(), '_makeTestFileContent');

  TODO: {
        local $TODO = 'Refactor to make this testable';
        ok(0);
    }
}

sub _tidySubName : Tests() {
    my $test = shift;

    can_ok($test->class(), '_tidySubName');

    my $testClass = $test->testClassFactory('lib/TestMaker.pm');
    is($testClass->_tidySubName(' sub    blah   {'),        'blah',   '.... well spaced tidied');
    is($testClass->_tidySubName(' sub    __blah   {'),      '__blah', '.... underscored sub tidied');
    is($testClass->_tidySubName(' sub    blah($$$$$)   {'), 'blah',   '.... prototyped sub tidied');
}

sub _testPackageName : Tests() {
    my $test = shift;

    can_ok($test->class(), '_testPackageName');

    my $testClass = $test->testClassFactory('lib/TestMaker.pm');
    is($testClass->_testPackageName(), 'Test::TestMaker', '.... converted lib/TestMaker.pm correctly');
    $testClass->libPath('lib/TestMaker/RunFile.pm');
    is($testClass->_testPackageName(),
        'Test::TestMaker::RunFile', '.... converted lib/TestMaker/RunFile.pm correctly');
}

sub _header : Tests() {
    my $test = shift;

    can_ok($test->class(), '_header');
}

sub testClassFactory {
    my ($test, $libPath) = @_;
    if ($libPath) {
        return $test->class->new({libPath => $libPath});
    }
    else {
        return $test->class->new({libPath => 'lib/TestMaker.pm'});
    }
}

1;
