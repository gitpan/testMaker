package TestMaker;
{
  $TestMaker::VERSION = '1.1';
}

# ABSTRACT: Create test class classes from your existing lib/

use strict;
use warnings;
use autodie;
use File::Path qw(make_path);
use File::Find;
use TestMaker::MyTestClass;
use TestMaker::RunFile;
use TestMaker::TestClass;

sub new {
    my $class = shift;
    return bless {}, $class;
}

sub createTests {
    find({wanted => \&_wanted, no_chdir => 1}, 'lib');
}

sub _wanted {
    my $path = $File::Find::name;
    return unless -f $path;

    my $testClass = TestMaker::TestClass->new({libPath => $path});
    $testClass->makeTestFile();
}

sub checkForModules {

    # to require a module from a variable name we need to do some mucking about to
    # translate from :: to /
    for my $module (qw/Test::Class Test::More Class::Data::Inheritable/) {

        # Foo::Bar::Baz => Foo/Bar/Baz.pm
        (my $fn = "$module.pm") =~ s|::|/|g;
        eval {
            require $fn;
            1;
        };
        if ($@) {
            die "$module is required to run the tests created by this script and doesn't seem to be installed
should you wish to run it anyway please use the -f option to override this check
";
        }
    }
}

sub createTestBase {
    make_path('t')               unless -d 't';
    make_path('t/tests/My/Test') unless -d 't/tests/My/Test';

    _makeRunFile();
    _makeMyTestClass();
}

sub _makeRunFile {
    my $runfile = 't/run.t';
    return if -f $runfile;
    open(my $fh, '>', $runfile);
    print $fh TestMaker::RunFile->fileData();
}

sub _makeMyTestClass {
    my $testClass = 't/tests/My/Test/Class.pm';
    return if -f $testClass;
    open(my $fh, '>', $testClass);
    print $fh TestMaker::MyTestClass->fileData();
}

1;

__END__

=pod

=head1 NAME

TestMaker - Create test class classes from your existing lib/

=head1 VERSION

version 1.1

=head1 SYNOPSIS

testMaker

To be run in base dir of project

assuming existing structure:

=over 4

=item lib/My/Class.pm

=item lib/My/Class/Stuff.pm

=back

will create

=over 4

=item t/run.t

Test::Class test runner

=item t/tests/My/Test/Class.pm

Test::Class custom base class

=item t/tests/Test/My/Class.pm

A test class based on lib/My/Class.pm

=item t/tests/Test/My/Class/Stuff.pm

A test class based on lib/My/Class/Stuff.pm

=back

=head1 DESCRIPTION

If you have an existing structure of classes in /lib running this script
will create a skeleton Test::Class test class for each. Within that test
class each of the subs in you lib class will have a test sub created with
a can_ok test.

The test classes will contain test subs, with a use_ok for that sub. The
custom base test class, as parent, will make sure each child test class
on startup performs a use_ok for the lib class you are testing

The script expects to be run in the base of your project (eg the dir
which contains lib/ t/ and so on).

Should a Test::Class test runner not exist one will be created.

A custom base class will also be created if it does not exist, which all
test classes created by this script inherit from.

Once the script has been run, all being well, you will be able to run your
test suite from the base dir of your project using

C<prove -lv --merge>

This script performs a check for L<Test::Class>, L<Test::More> and
L<Class::Data::Inheritable> and will complain at you if they are not
installed. To go ahead and run the script anyway use the -f flag:

C<testMaker.pl -f>

=head1 CAVEATS

It currently does not filter out any sub definitions which are contained
within pod sections of your class, and probably never will.

=head1 SEE ALSO

L<Test::Class>

L<Class::Data::Inheritable>

L<Test::More>

L<Test::Most>

=head1 ACKNOWLEDGEMENTS

Based on the excellent tutorial on Test::Class by Curtis "Ovid" Poe,
<ovid at cpan.org> L<found here|http://www.modernperlbooks.com/mt/2009/03/organizing-test-suites-with-testclass.html>

=head1 AUTHOR

Tom Beresford <me at tomberesford dot co dot uk>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Tom Beresford.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
