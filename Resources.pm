package App::Ack::Resources;

use App::Ack;

use File::Next;

use warnings;
use strict;

=head1 SYNOPSIS

This is the base class for App::Ack::Resources, an iterator factory
for App::Ack::Resource objects.

=head1 METHODS

=head2 from_argv( $opt, \@ARGV )

=cut

sub from_argv {
    my $class = shift;
    my $opt  = shift;
    my $argv = shift;

    my $self = bless {}, $class;

    my $file_filter    = undef;
    my $descend_filter = undef;

    $self->{iter} =
        File::Next::files( {
            file_filter     => $file_filter,
            descend_filter  => $descend_filter,
            error_handler   => sub { my $msg = shift; App::Ack::warn( $msg ) },
            sort_files      => $opt->{sort_files},
            follow_symlinks => $opt->{follow},
        }, @{$argv} );

    return $self;
}

sub next {
    my $self = shift;

    my $file = $self->{iter}->() or return;

    return App::Ack::Resource::Basic->new( $file );
}

1;
