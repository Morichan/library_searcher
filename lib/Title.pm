package lib::Title;

use Mouse;

extends "lib::Param";

sub BUILD {
    my $self = shift;

    $self->text("fuga");
}

1;
