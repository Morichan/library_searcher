package lib::Publisher;

use Mouse;

extends "lib::Param";

sub BUILD {
    my $self = shift;

    $self->title('出版社');
    $self->default('オライリー・ジャパン');
    $self->name("publisher");
}

1;
