package TestMaker::MyTestClass;
{
  $TestMaker::MyTestClass::VERSION = '1.1';
}

# ABSTRACT: Class to hold custom base test class definition

use strict;

sub fileData {
    return q!package My::Test::Class;

use Test::More;
use base qw<Test::Class Class::Data::Inheritable>;

BEGIN {
    __PACKAGE__->mk_classdata('class');
}

sub startup : Tests( startup => 1 ) {
    my $test = shift;

    (my $class = ref $test) =~ s/^Test:://;
    return ok 1, "$class loaded" if $class eq __PACKAGE__;
    use_ok $class or die;
    $test->class($class);
}

1;
!;
}

1;

__END__

=pod

=head1 NAME

TestMaker::MyTestClass - Class to hold custom base test class definition

=head1 VERSION

version 1.1

=head1 AUTHOR

Tom Beresford <me at tomberesford dot co dot uk>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Tom Beresford.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
