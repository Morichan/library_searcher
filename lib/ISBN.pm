package lib::ISBN;

use utf8;
use Mouse;

extends "lib::Param";

sub BUILD {
    my $self = shift;

    $self->title('ISBN');
    $self->default('9784873115672');
    $self->maxlength(13);
    $self->name("isbn");
}

1;
