package lib::Price;

use Mouse;

extends "lib::Param";

sub BUILD {
    my $self = shift;

    $self->title('価格');
    $self->default('3,888円');
    $self->name("price");
}

1;
