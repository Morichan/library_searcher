package lib::Price;

use utf8;
use Mouse;

extends "lib::Param";

sub BUILD {
    my $self = shift;

    $self->title('価格');
    $self->value('3,888円');
    $self->name("price");
}

1;
