package Test::TestMaker;

use strict;
use base 'My::Test::Class';
use Test::Most;

sub constructor : Tests() {
    my $test = shift;

    can_ok($test->class(), 'new');
    isa_ok($test->class->new(), 'TestMaker');
}

sub createTests : Tests() {
    my $test = shift;

    can_ok($test->class(), 'createTests');

  TODO: {
        local $TODO = 'Refactor to make this testable';
        ok(0);
    }
}

sub _wanted : Tests() {
    my $test = shift;

    can_ok($test->class(), '_wanted');

  TODO: {
        local $TODO = 'Refactor to make this testable';
        ok(0);
    }
}

sub checkForModules : Tests() {
    my $test = shift;

    can_ok($test->class(), 'checkForModules');

  TODO: {
        local $TODO = 'Refactor to make this testable';
        ok(0);
    }
}

sub createTestBase : Tests() {
    my $test = shift;

    can_ok($test->class(), 'createTestBase');

  TODO: {
        local $TODO = 'Refactor to make this testable';
        ok(0);
    }
}

sub _makeRunFile : Tests() {
    my $test = shift;

    can_ok($test->class(), '_makeRunFile');

  TODO: {
        local $TODO = 'Refactor to make this testable';
        ok(0);
    }
}

sub _makeMyTestClass : Tests() {
    my $test = shift;

    can_ok($test->class(), '_makeMyTestClass');

  TODO: {
        local $TODO = 'Refactor to make this testable';
        ok(0);
    }
}

1;
