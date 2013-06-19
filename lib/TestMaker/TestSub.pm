package TestMaker::TestSub;
{
  $TestMaker::TestSub::VERSION = '1.1';
}

# ABSTRACT: Class to generate test sub definitions

use strict;
use warnings;

sub new {
    my ($class, $args) = @_;

    die "subName not defined" unless $args->{subName};

    my $self = {};
    bless $self, $class;

    $self->subName($args->{subName});
    $self->testSubName($args->{subName});

    return $self;
}

sub subName {
    my ($self, $subName) = @_;

    if (@_ > 1) {
        die "Bad subName" unless $self->_validateSubName($subName);
        chomp($subName);
        $self->{subName} = $subName;
    }
    return $self->{subName};
}

sub testSubName {
    my ($self, $subName) = @_;

    if (@_ > 1) {
        die "Bad subName" unless $self->_validateSubName($subName);
        chomp($subName);
        if ($subName eq 'new') {
            $self->{testSubName} = 'constructor';
        }
        else {
            $self->{testSubName} = $subName;
        }
    }
    return $self->{testSubName};
}

sub _validateSubName {
    my ($self, $subName) = @_;

    unless (defined $subName) {
        warn "Invalid subName: Not defined";
        return 0;
    }

    unless ($subName) {
        warn "Invalid subName: $subName does not evalute to true";
        return 0;
    }

    if ($subName eq 'sub') {
        warn "Invalid subName: cannot use subName sub";
        return 0;
    }

    return 1;
}

sub testSubDefinition {
    my ($self) = @_;

    die "subName not defined" unless $self->subName();

    my $subDef .= q!sub ! . $self->testSubName() . q! : Tests() {
    my $test = shift;

    can_ok($test->class(), '! . $self->subName() . q!');
}

!;
    return $subDef;
}

1;

__END__

=pod

=head1 NAME

TestMaker::TestSub - Class to generate test sub definitions

=head1 VERSION

version 1.1

=head1 AUTHOR

Tom Beresford <me at tomberesford dot co dot uk>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Tom Beresford.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
