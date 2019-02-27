package lib::Result;

use Mouse;

has title => ( is => "rw", default => "" );
has author => ( is => "rw", default => "" );
has isbn => ( is => "rw", default => "" );
has publisher => ( is => "rw", default => "" );

sub has_result {
    my $self = shift;

    return $self->title ne "";
}

1;
