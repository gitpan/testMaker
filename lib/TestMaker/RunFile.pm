package TestMaker::RunFile;
{
  $TestMaker::RunFile::VERSION = '1.1';
}

# ABSTRACT: Class to hold test class runner definition

use strict;

sub fileData {
    return '#!/usr/bin/env perl

use Test::Class::Load qw<t/tests>;
Test::Class->runtests;
';
}

1;

__END__

=pod

=head1 NAME

TestMaker::RunFile - Class to hold test class runner definition

=head1 VERSION

version 1.1

=head1 AUTHOR

Tom Beresford <me at tomberesford dot co dot uk>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Tom Beresford.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
