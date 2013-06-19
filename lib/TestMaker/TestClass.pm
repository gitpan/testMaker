package TestMaker::TestClass;
{
  $TestMaker::TestClass::VERSION = '1.1';
}

# ABSTRACT: Class to generate test classes

use strict;
use warnings;
use autodie;
use File::Path qw(make_path);
use TestMaker::TestSub;

sub new {
    my ($class, $args) = @_;

    die "libPath not defined" unless $args->{libPath};

    my $self = {};
    bless $self, $class;

    $self->libPath($args->{libPath});

    return $self;
}

sub libPath {
    my ($self, $libPath) = @_;

    if (@_ > 1) {
        die "Bad libPath" unless $self->_validateLibPath($libPath);
        $self->{libPath} = $libPath;
    }
    return $self->{libPath};
}

sub _validateLibPath {
    my ($self, $libPath) = @_;

    unless (defined $libPath) {
        warn "Invalid libPath: Not defined";
        return 0;
    }

    unless ($libPath) {
        warn "Invalid libPath: $libPath does not evalute to true";
        return 0;
    }

    unless (-f $libPath) {
        warn "Invalid libPath: $libPath not a regular file";
        return 0;
    }

    unless (-r $libPath) {
        warn "Invalid libPath: $libPath cannot be read from";
        return 0;
    }

    return 1;
}

sub makeTestFile {
    my ($self) = @_;

    return if -e $self->_testFilePath();

    $self->_makeTestDir() unless -d $self->_testDir();

    open(my $testFH, '>', $self->_testFilePath());
    print $testFH $self->_makeTestFileContent();
}

sub _testFilePath {
    my ($self) = @_;
    return $self->_testDir() . "/" . $self->_testFile();
}

sub _makeTestDir {
    my ($self) = @_;
    make_path($self->_testDir());
}

sub _testDir {
    my ($self) = @_;
    my $testDir = $self->libPath();
    $testDir =~ s/\.pm//;
    $testDir =~ s!lib/!t/tests/Test/!;
    $testDir =~ s!(.*)/\w+$!$1!;
    return $testDir;
}

sub _testFile {
    my ($self) = @_;
    my $testFile = $self->libPath();
    $testFile =~ s!.*/(\w+\.pm)$!$1!;
    return $testFile;
}

sub _makeTestFileContent {
    my ($self) = @_;

    my $content = $self->_header();

    open(my $libfh, '<', $self->libPath());

    while (<$libfh>) {
        next unless $_ =~ /^\s*sub /;
        my $subName = $self->_tidySubName($_);
        my $sub = TestMaker::TestSub->new({subName => $subName});
        $content .= $sub->testSubDefinition();
    }
    $content .= "1;\n";

    return $content;
}

sub _tidySubName {
    my ($self, $subName) = @_;
    chomp($subName);
    $subName =~ s/^\s*sub\s+([^\(\s\{]+).*/$1/;
    return $subName;
}

sub _testPackageName {
    my ($self) = @_;
    my $testPackageName = $self->libPath();
    $testPackageName =~ s/\.pm//;
    $testPackageName =~ s!lib/(.*)!Test::$1!;
    $testPackageName =~ s!/!::!g;
    return $testPackageName;
}

sub _header {
    my ($self) = @_;

    return "package " . $self->_testPackageName() . ";

use strict;
use base 'My::Test::Class';
use Test::More;

";
}

1;

__END__

=pod

=head1 NAME

TestMaker::TestClass - Class to generate test classes

=head1 VERSION

version 1.1

=head1 AUTHOR

Tom Beresford <me at tomberesford dot co dot uk>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Tom Beresford.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
