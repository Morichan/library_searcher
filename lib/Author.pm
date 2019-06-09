package lib::Author;

use utf8;
use Mouse;

extends "lib::Param";

sub BUILD {
    my $self = shift;

    $self->title('著者');
    $self->value('Randal L. Schwartz');
    $self->name("author");
}

1;
