package lib::Author;

use utf8;
use Mouse;

extends "lib::Param";

sub BUILD {
    my $self = shift;

    $self->title('著者');
    $self->default('Randal L. Schwartz');
    $self->name("author");
}

1;
